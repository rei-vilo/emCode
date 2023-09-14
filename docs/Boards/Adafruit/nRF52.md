---
tags:
    - Active
---

# Manage the Adafruit Feather nRF52832 and nRF52840 boards

## Install

To install the Adafruit Feather nRF52832 and nRF52840 boards,

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install adafruit:nrf52
```

The Feather nRF52832 board (previously named Feather nRF52) requires the installation of additional tools.

+ Please refer to the [Third Party Tool Installation of nrfutil (OS X and Linux Only)](https://learn.adafruit.com/bluefruit-nrf52-feather-learning-guide/arduino-bsp-setup#nrfutil-os-x-and-linux-only) :octicons-link-external-16: on the Adafruit website.

Adafruit now includes in the boards package a customised version of the `nrfutil` utility, named `adafruit-nrfutil`.

Similarly, if the Feather nRF52832 board (previously named Feather nRF52) has been used with a previous version of Adafruit nRF52 boards package, the boot-loader of the boards needs to be updated when moving to release 0.9.0.

+ Please follow the procedure [Flashing the Bootloader](https://learn.adafruit.com/bluefruit-nrf52-feather-learning-guide/flashing-the-bootloader) :octicons-link-external-16: at the Adafruit website.

When using Serial,

+ Add to the main `Makefile`

``` Cmake
APP_LIBS_LIST = Adafruit_TinyUSB_Arduino
```

+ Add to the main sketch

``` cpp
#include "Adafruit_TinyUSB.h"
```

## Develop

emCode adds the following libraries automatically for Serial, file system and Bluetooth:

``` Cmake
APP_LIBS_LIST += Adafruit_TinyUSB_Arduino
APP_LIBS_LIST += Adafruit_LittleFS InternalFileSytem
APP_LIBS_LIST += Adafruit_nRFCrypto Bluefruit52Lib
```

### Use the libraries for Serial

+ Add to the main sketch

``` cpp
#include "Adafruit_TinyUSB.h"
```

### Use the libraries for Bluetooth

### Use the libraries for SD

## Upload

![](img/Logo-064-Adafruit.png) For the Adafruit Feather nRF52832 and nRF52840 boards, Adafruit offers up to three options to upload the executable to the boards.

The first option is the standard upload procedure through serial over USB.

The second option, called UF2 for USB Flashing Format, turns the board into a mass storage device. Programming is done with a simple drag-and-drop or copy of the executable onto the mass storage device. This option is only available on the Adafruit Feather nRF52840 board.

The third option uses an external programmer-debugger like the Segger J-Link. The Adafruit Feather nRF52840 board comes with the SWD 2x5 1.27 mm connector. It needs to be soldered on the Adafruit Feather nRF52832 board.

### Upload using UF2

For the Adafruit Feather nRF52840, the drag-and-drop procedure requires the same specific format as for the Adafruit Feather M0 and M4 boards. The Adafruit nRF52 boards package includes the utility to convert the executable into a  `.uf2` file. This option is not available on the Adafruit Feather nRF52832 board.

Before uploading to the Adafruit Feather nRF52840,

+ Select the board Adafruit Feather nRF52840 s140b611 (MSD).

+ Plug the Adafruit board in.

+ Check a volume called `FTHR840BOOT` is shown on the desktop.

+ Otherwise, double-press the ++reset++ button on the board to activate it.

+ Check the LED on the board is green.

+ Launch any of the targets **All**, **Upload** or **Fast**.

For more information on the Feather nRF52840,

+ Please refer to the page [Update Bootloader](https://learn.adafruit.com/introducing-the-adafruit-nrf52840-feather/update-bootloader) :octicons-link-external-16:.

For more information on the Feather nRF52832,

+ Please refer to the page [Flashing the Bootloader](https://learn.adafruit.com/bluefruit-nrf52-feather-learning-guide/flashing-the-bootloader) :octicons-link-external-16:.

### Upload using Segger J-Link

The Adafruit Feather nRF52840 board provides the SWD 2x5 1.27 mm connector, while the Adafruit Feather nRF52832 board provisions the pads to solder the connector on.

Depending on the Segger J-Link model, the programmer-debugger can power the board. Otherwise, the board requires an external LiPo or USB.

+ Connect the programmer-debugger to the board.

+ If the programmer-debugger doesn't power the board, use an external LiPo or USB.

+ Select the board Adafruit Feather nRF52832 s132v611 (J-Link) or Adafruit Feather nRF52840 s140b611 (J-Link) to use **J-Link**,

+ Select the board Adafruit Feather nRF52832 s132v611 (Ozone) or Adafruit Feather nRF52840 s140b611 (Ozone) to use **Ozone**.

+ Launch any of the targets **All**, **Upload**, **Fast** or **Debug**.

## Debug

![](img/Logo-064-J-Link.png) The Segger J-Link provides a JTAG 2x10 2.54 mm 0.1" connector while the Adafruit Feather nRF52832 and nRF52840 feature a 2x5 1.27 mm 0.05" SWD connector.

+ Use for example the [JTAG (2x10 2.54 mm) to SWD (2x5 1.27 mm) Cable Adapter Board](https://www.adafruit.com/products/2094) :octicons-link-external-16: and a [10-pin 2x5 Socket-Socket 1.27 mm IDC (SWD) Cable - 150 mm long](https://www.adafruit.com/products/1675) :octicons-link-external-16: from Adafruit, or similar hardware.

The Adafruit Feather nRF52832 only provisions the pads, but the SWD connector needs to be soldered.

+ Use for example the [SWD 2x5 1.27 mm 0.05" Connector](https://www.adafruit.com/product/752) :octicons-link-external-16: or the even more compact [Mini SWD 2x5 1.27 mm 0.05" Connector](https://www.adafruit.com/product/4048) :octicons-link-external-16: from Adafruit, or similar hardware.

The Segger J-Link Edu mini provides the same 2x5 1.27 mm 0.05" SWD connector as the Adafruit Feather nRF52840.

+ Just use the 10-way flat cable provided with the Segger J-Link Edu mini.

If the software suite for the Segger J-Link isn't installed,

+ Follow the procedure at [Install the Segger J-Link Software Suite](../../Install/Section4/#install-the-segger-j-link-software-suite) :octicons-link-16:.

Because the Adafruit Feather nRF52 boards run on FreeRTOS, J-Link requires specific plug-ins. Ozone manages FreeRTOS better than the command-line J-Link utility and is thus strongly recommended.
