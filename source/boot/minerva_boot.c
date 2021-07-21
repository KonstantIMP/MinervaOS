/**
 * UEFI bootloader for MinervaOS
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 21 Jul 2021
 */
#include "uefi/uefi.h"

#include "bootparam.h"
#include "elf64.h"

/**
 * Bootloader`s start point
 * Params:
 *   argc = Number of CLI arguments
 *   argv = CLI arguments
 */
int main (int argc, char ** argv)
{
  printf ("MinervaOS boot...\n");

  if (argc != 2) {
    printf ("Path to the kernel is not specified\n");
    return -1;
  }

  FILE *kernel;
  char *buff;

  /** Open kernel file for reading */
  if ((kernel = fopen(argv[1], "r"))) {
    /** Get kernel`s size*/
    fseek(kernel, 0, SEEK_END);
    long int size = ftell(kernel);
    fseek(kernel, 0, SEEK_SET);

    /** Allocate memory for kernel */
    buff = malloc(size + 1);
    if (buff == NULL) {
      printf ("Cannot allocate memory for the kernel");
      return -1;
    }

    /** Read the kernel */
    fread(buff, size, 1, kernel);
    fclose(kernel);
  }
  else {
    printf ("Cannot open the kernel\n");
    return -1;
  }

  /** Create bootparam struct */
  bootparam_t bootp;
  memset(&bootp, 0x00, sizeof(bootparam_t));

  /** Get graphic protocols */
  efi_guid_t gopGuid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
  efi_gop_t *gop = NULL;

  efi_status_t status = BS->LocateProtocol(&gopGuid, NULL, (void **)&gop);

  if (!EFI_ERROR(status) && gop) {
    /** Setup video mode */
    status = gop->SetMode (gop, 0);
    ST->ConOut->Reset(ST->ConOut, 0);
    ST->StdErr->Reset(ST->StdErr, 0);

    if (EFI_ERROR(status)) {
      printf ("Cannot setup video mode\n");
      return -1;
    }

    printf("Pointer to the screen buffer : 0x%08x\n", (unsigned int)gop->Mode->FrameBufferBase);
    bootp.framebuffer = (unsigned int*)gop->Mode->FrameBufferBase;
    printf("Width of the screen : %d\n", gop->Mode->Information->HorizontalResolution);
    bootp.width = gop->Mode->Information->HorizontalResolution;
    printf("Height of the screen : %d\n", gop->Mode->Information->VerticalResolution);
    bootp.height = gop->Mode->Information->VerticalResolution;
    printf("Number of pixels per scan line : %d\n", gop->Mode->Information->PixelsPerScanLine);
    bootp.pitch = sizeof(unsigned int) * gop->Mode->Information->PixelsPerScanLine;
  }
  else {
    printf ("Unable to get graphical protocols\n");
    return -1;
  }

  /** Check the Elf64 signature */
  Elf64_Ehdr *elf = (Elf64_Ehdr *)buff;
  
  if (!memcmp(elf->e_ident, ELFMAG, SELFMAG) &&
      elf->e_ident[EI_CLASS] == ELFCLASS64   &&
      elf->e_ident[EI_DATA] == ELFDATA2LSB   &&
      elf->e_type == ET_EXEC                 &&
      elf->e_machine == EM_MACH              &&
      elf->e_phnum > 0                      ) {
    /** Load segments */
    int i; Elf64_Phdr * phdr;
    for (phdr = (Elf64_Phdr *)(buff + elf->e_phoff), i = 0; i < elf->e_phoff;
              i++, phdr = (Elf64_Phdr *)((uint8_t *)phdr + elf->e_phentsize)) {
      if(phdr->p_type == PT_LOAD) {
        memcpy((void*)phdr->p_vaddr, buff + phdr->p_offset, phdr->p_filesz);
        memset((void*)(phdr->p_vaddr + phdr->p_filesz), 0, phdr->p_memsz - phdr->p_filesz);
      }
    }
  }
  else {
    printf("Incorrect ELF for this ARCH\n");
    return -1;
  }

  /** Get entry point */
  uintptr_t entry = elf->e_entry;

  /** Free the memory */
  free(kernel);

  /** Exit UEFI session */
  if (exit_bs()) {
    printf("UEFI error. Cant stop the process\n");
    return -1;
  }

  /** Call the entry point of the kernel */
  (*((void(* __attribute__((sysv_abi)))(bootparam_t *))(entry)))(&bootp);

  /** It should not exit */
  while (1) {};
  return 0;
}
