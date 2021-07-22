/**
 * Implement system calls
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module kernel.syscall.syscall;

import stl.uda : KERNEL_ABI;

/** 
 * Attribute for systemcalls
 */
@KERNEL_ABI
struct SYSCALL {
    size_t id; /** Call`s id for handling */
}

/** 
 * Attribute for setting parametrs for syscalls
 */
@KERNEL_ABI
struct SYSCALL_ARGUMENT (T) {
    alias argumentType = T;
    enum argumentString = T.stringof;
}


@KERNEL_ABI
private struct SYSCALL_STORAGE {
    
} 

