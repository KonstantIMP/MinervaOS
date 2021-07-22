/**
 * Minerva kernel start point
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 21 Jul 2021
 */
module kernel.kmain;

/** 
 * Struct for sending boot parametrs to the kernel
 */
struct Bootparam {
    uint * framebuffer; /** Pointer to the sceen buffer*/
    uint   width;       /** Width of the screen */
    uint   height;      /** Height of the screen */
    uint   pitch;       /** Number of pixels per scan line */
}

extern (C) void* _Dmodule_ref;

extern (C) void kmain (Bootparam bootp) {
    
}
