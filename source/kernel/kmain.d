/**
 * Minerva kernel start point
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 21 Jul 2021
 */
module kernel.kmain;

import stl.uda : KERNEL_ABI;

/** 
 * Struct for sending boot parametrs to the kernel
 */
extern (C) struct Bootparam {
    uint * framebuffer; /** Pointer to the sceen buffer*/
    uint   width;       /** Width of the screen */
    uint   height;      /** Height of the screen */
    uint   pitch;       /** Number of pixels per scan line */
}

/** Undefined but required symbol */
@KERNEL_ABI extern (C) void* _Dmodule_ref;

/** 
 * Entry point for the kernel
 * Params:
 *   bootp = Input kernel`s params
 */
@KERNEL_ABI
extern (C) void kmain (Bootparam * bootp) {
    for (ulong i = 0; i < bootp.width * bootp.height; i++) {
        bootp.framebuffer[i] = 0x000008;
    }

    while (true) {}
}
