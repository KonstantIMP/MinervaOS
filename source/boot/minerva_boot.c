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
    fprintf (stderr, "Path to the kernel is not specified\n");
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
      fprintf(stderr, "Cannot allocate memory for the kernel");
      return -1;
    }

    /** Read the kernel */
    fread(buff, size, 1, kernel);
    fclose(kernel);
  }
  else {
    fprintf(stderr, "Cannot open the kernel\n");
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
      fprintf(stderr, "Cannot setup video mode\n");
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
    fprintf(stderr, "Unable to get graphical protocols\n");
    return -1;
  }

  return 0;
}
