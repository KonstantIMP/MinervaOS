/**
 * Structure for sending parametrs to the kernel
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 21 Jul 2021
 */
#ifndef  __BOOTPARAM_H__
#define  __BOOTPARAM_H__

#include "uefi/uefi.h"

typedef struct
{
  unsigned int    *framebuffer;
  unsigned int    width;
  unsigned int    height;
  unsigned int    pitch;
//  int             argc;
//  char            **argv;
} bootparam_t;

#endif //__BOOTPARAM_H__