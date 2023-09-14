---
tags:
    - On hold
---

# Manage the Seeed Xiao expansion board

The Seed Xiao expansion board brings a 128x64 OLED screen, a micro SD-card slot, a LiPo charger, a battery-backed RTC, a buzzer and connectors for a SWD debugger.

The Xiao RP2040 requires specific libraries provided by the RP2040 platform.

The Xiao ESP32-C3 and ESP32-S3 require specific libraries provided by the ESP32 platform.

## Install

### Install the libraries for display

+ Download and install the [U8g2 Arduino Monochrome Graphics Library](https://github.com/olikraus/U8g2_Arduino) :octicons-link-external-16::.

### Install the libraries for clock

+ Download and install the [PCF8563 Arduino Library](https://github.com/Bill2462/PCF8563-Arduino-Library) :octicons-link-external-16::.

### Install the libraries for SD-card

For the Xiao M0, Xiao RP2040, Xiao ESP32C3 and Xiao ESP32S3,

+ Download and install the library [Seeed Arduino FS](https://github.com/Seeed-Studio/Seeed_Arduino_FS) :octicons-link-external-16::.

For the Xiao nRF52840,

+ Download and install the library [SDFat](https://github.com/greiman/SdFat) :octicons-link-external-16::.

## Develop

### Use the libraries for display

+ Add to the main `Makefile`;

``` CMake
APP_LIBS_LIST = Wire
USER_LIBS_LIST = U8g2
```

+ Edit the main sketch.

``` cpp
#include "Wire.h"
#include "U8x8lib.h"
```

### Use the libraries for clock

+ Add to the main `Makefile`;

``` CMake
APP_LIBS_LIST = Wire
USER_LIBS_LIST = U8g2
```

+ Add to the main sketch.

``` cpp
#include "Wire.h"
#include "PCF8563.h"
```

### Use the libraries for buzzer

No library is required.

The buzzer is connected to pin `A3`.

### Use the libraries for SD-card

The SD-card `/CS` signal is connected to pin `D2`.

For the Xiao M0,

+ Add to the main `Makefile`;

``` CMake
APP_LIBS_LIST = SPI
USER_LIBS_LIST = Adafruit_Zero_DMA Seeed_Arduino_FS
```

+ Add to the main sketch.

``` cpp
#include "SPI.h"
#include "Seeed_Arduino_FS.h"
```

or

+ Add to the main `Makefile`;

``` CMake
APP_LIBS_LIST = SPI
USER_LIBS_LIST = Adafruit_Zero_DMA SD
```

+ Add to the main sketch.

``` cpp
#include "SPI.h"
#include "SD.h"
```

For the Xiao nRF52840,

+ Add to the main `Makefile`;

``` CMake
APP_LIBS_LIST = SPI
USER_LIBS_LIST = SdFat
```

+ Add to the main sketch.

``` cpp
#include "SPI.h"
#include "SdFat.h"
```

## Debug

The Seeed Xiao expansion board expose the SWD clock and data signals; the serial RX and TX signals; and the +5V, +3.3V and ground lines to connect a Segger J-Link programmer-debugger.

The debugging features seems to work only against the Xiao M0.
