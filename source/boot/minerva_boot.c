/**
 * UEFI bootloader for MinervaOS
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 21 Jul 2021
 */
#include "uefi/uefi.h"

/**
 * Bootloader`s start point
 * Params:
 *   argc = Number of CLI arguments
 *   argv = CLI arguments
 */
int main (int argc, char ** argv)
{
  printf ("Hello, uefi!\n");
  return 0;
}
