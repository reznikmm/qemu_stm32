# qemu_stm32

> Experiments with running Ada on STM32 MCU with Qemu

This is a repository of examples of running Ada programs for STM32 MCU
using Qemu system emulator.

## Hello world via UART on unmodified Qemu

In this demo we run *Hello world* built with Ada `arm-eabi` cross toolchain
from Alire and `light-tasking-stm32f4` runtime using unmodified
`qemu-system-arm`.

STM32 RCC support in Qemu is quite rough, so the clock setup routine in Ada
runtime hangs waiting for the MCU to signal that the clock generator is ready.
We can work around this by editing the startup code in `setup_pll.adb`.
For UART text output we can use the corresponding
[`s-textio__stm32f4.adb`](https://github.com/alire-project/bb-runtimes/blob/gnat-fsf-15/src/s-textio__stm32f4.adb)
from `bb-runtimes`.
We should also replace `a-textio.adb` with a
[version using `System.Text_IO`](https://github.com/alire-project/bb-runtimes/blob/gnat-fsf-15/gnat_rts_sources/include/rts-sources/system_io/a-textio.adb),
since the default one in `light-tasking-stm32f4` runtime uses Semihosting
(not supported in qemu).

* Install `apt install qemu-system-arm`
* Build and run:
  ```shell
  cd 01_hello_uart
  alr build
  qemu-system-arm -M netduinoplus2 -kernel bin/uart_test.bin -serial stdio -display none
  # Hello!
  # Hello!
  ```

  If you want to attach with a debugger, add the switch `-gdb tcp::3333`.
  Also add `-S` if you want Qemu not to execute code until GDB connects.
  The `-d unimp,guest_errors` switch can be useful if you want to see
  debug messages about unimplemented registers.