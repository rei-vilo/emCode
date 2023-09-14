---
tags:
    - On hold
---

# Manage the Seeed Xiao nRF52840 boards

The Seeed platform includes two main lines of boards: the compact Xiao and the Wio Terminal.

!!! warning
    The software for the Seeed Xiao nRF51840 board is not stable enough. Support has been put on hold.

## Install the Seeed Xiao nRF52840

To install the Seeed Xiao nRF52840 board,

+ Ensure the Arduino tools, CLI or IDE, are installed.

+ Ensure the `arduino-cli.yaml` configuration file for Arduino-CLI or the **Additional boards manager URLs** for Arduino IDE includes

``` json
https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json```
```

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install Seeeduino:nrf52@1.1.1
```

!!! warning
    Release `1.1.3` does not work. Use release `1.1.1` instead.

To install the library for Bluetooth, run

``` bash dollar
arduino-cli lib install ArduinoBLE

```

## Develop

### Use the built-in LEDs

Built-in LEDs use reverse logic.

+ `LOW` to turn them on;
+ `HIGH` to turn them off.

### Use the libraries for Serial port

+ Edit the main `Makefile` to list the required libraries for the serial port.

``` CMake
APP_LIBS_LIST += Adafruit_TinyUSB_Arduino
```

+ Add to the main sketch

``` cpp
#include "Adafruit_TinyUSB.h"
```

### Use the libraries for IMU

+ Edit the main `Makefile` to list the required libraries for the LSM6DS3.

``` CMake
USER_LIBS_LIST = Seeed_Arduino_LSM6DS3
```

### Use the libraries for microphone

+ Add to the main sketch.

``` CMake
USER_LIBS_LIST = Seeed_Arduino_Mic
```

### Use the libraries for Bluetooth

+ Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = ArduinoBLE
```

### Use the libraries for SD

## Debug

!!! critical
    Using the Xiao M0 as DAP-Link probe does not work. Use instead the Segger J-Link probe.
