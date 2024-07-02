---
tags:
    - On hold
---

# Manage the Seeed Xiao nRF52840 Mbed-OS boards

The Seeed Xiao nRF52840 Mbed-OS platform includes two boards: the Xiao nRF52840 and the Xiao nRF52840 Sense with additional sensors.

!!! warning
    The software for the Seeed Xiao nRF51840 board is not stable enough. Support has been put on hold.

<!--
## Install the Seeed Xiao nRF52840

+ Ensure **Arduino-CLI** is installed.

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

```
APP_LIBS_LIST += Adafruit_TinyUSB_Arduino
```

+ Add to the main sketch

``` cpp
#include "Adafruit_TinyUSB.h"
```

### Use the libraries for IMU

+ Edit the main `Makefile` to list the required libraries for the LSM6DS3.

```
USER_LIBS_LIST = Seeed_Arduino_LSM6DS3
```

### Use the libraries for microphone

+ Add to the main sketch.

```
USER_LIBS_LIST = Seeed_Arduino_Mic
```

### Use the libraries for Bluetooth

+ Edit the main `Makefile` to list the required libraries.

```
USER_LIBS_LIST = ArduinoBLE
```

### Use the libraries for SD

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Platform | IDE | Package | Comment
---- | ---- | ---- | ---- | ---- | ----
![](img/Logo-064-Seeeduino.png) | **Seeeduino** | Arduino 1.8 | AVR 1.3.0 | | For Seeed and Seeed Grove Beginner Kit
| | | | SAMD 1.8.0 | | For Xiao SAMD and Wio Terminal boards
| | | | Realtek 3.0.7 | | For RTL8720DN on Wio Terminal board

## Visit the official websites

![](img/Logo-064-Seeed.png) | **Seeeduino**
:---- | ----
IDE | Arduino-CLI or Arduino IDE
Website | <https://www.seeedstudio.com> :octicons-link-external-16:
Download | <http://wiki.seeed.cc/Seeed_Arduino_Boards> :octicons-link-external-16:
Wiki | <http://wiki.seeed.cc/Seeeduino_v4.2/> :octicons-link-external-16:
Xiao nRF52840 | <https://wiki.seeedstudio.com/XIAO_BLE/> :octicons-link-external-16:
Forum | <https://forum.seeedstudio.com/> :octicons-link-external-16:
-->
