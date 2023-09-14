---
tags:
    - Legacy
---

# Manage the Arduino nRF52840 boards

The Arduino nRF52840 platform includes the Arduino Primo and Arduino Primo Core boards.

## Install

To install the Arduino nRF52840 boards,

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install arduino:nrf52
```

## Develop

### Use the Bluetooth library

To use the Bluetooth library provided with the boards package,

+ Edit the main `M̀akefile` with

``` CMake
APP_LIBS_LIST = BLE
```

+ Include in the main sketch

``` CPP
#include "BLECentralRole.h"
#include "BLEPeripheral.h"
```

### Use the low-power library

To use the Arduino Low-Power library,

+ Edit the main `M̀akefile` with

``` CMake
USER_LIBS_LIST = Arduino_Low_Power
```

+ Include in the main sketch

``` cpp
#include "ArduinoLowPower.h"
```

### Use the real-time clock library

To use the RTC library provided with the boards package,

+ Edit the main `M̀akefile` with

``` CMake
APP_LIBS_LIST = RTCInt
```

+ Include in the main sketch

``` cpp
#include "RTCInt.h"
```

To use the RTC Zero library,

+ Edit the main `M̀akefile` with

``` CMake
USER_LIBS_LIST = RTCZero
```

+ Include in the main sketch

``` cpp
#include "RTCZero.h"
```

### Use the NFC library

To use the NFC library provided with the boards package,

+ Edit the main `M̀akefile` with

```CMake
APP_LIBS_LIST = NFC
```

+ Include in the main sketch

``` CPP
#include "NFC.h"
```

### Use the sensors library on the Primo Core board

To use the NFC library provided with the boards package,

+ Edit the main `M̀akefile` with

```CMake
APP_LIBS_LIST = CoreSensors
```

+ Include in the main sketch

``` CPP
#include "CoreSensors.h"
```

## Upload

## Debug

