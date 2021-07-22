/**
 * Minerva kernel start point
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 21 Jul 2021
 */
module kernel.kmain;

import stl.uda : KERNEL_API;

/** 
 * Struct for sending boot parametrs to the kernel
 */
struct Bootparam {
    uint * framebuffer; /** Pointer to the sceen buffer*/
    uint   width;       /** Width of the screen */
    uint   height;      /** Height of the screen */
    uint   pitch;       /** Number of pixels per scan line */
}

/** Undefined but required symbol */
@KERNEL_API extern (C) void* _Dmodule_ref;

/** 
 * Entry point for the kernel
 * Params:
 *   bootp = Input kernel`s params
 */
@KERNEL_API
extern (C) void kmain (Bootparam bootp) {
    
}
