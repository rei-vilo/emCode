---
tags:
    - Active
---

# Manage the Arduino Mbed-OS boards

The Arduino Mbed-OS platform includes the Arduino Nano 33 BLE Sense based on the nRF52840 MCU and the Arduino Nano RP2040 Connect based on the RP2040 MCU.

## Install the Arduino Nano 33 BLE Sense board

To install the Arduino Nano 33 BLE Sense board,

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install arduino:mbed_nano
```

## Install the Arduino Nano RP2040 Connect board

There are two options for the Arduino Nano RP2040 Connect board.

To install the official Arduino core package based on on Mbed-OS,

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install arduino:mbed_rp2040
```

As an alternative for better performance and compatibility,

+ Use the [Raspberry Pi Pico RP2040 platform](../RP2040/RP2040.md) on the Arduino Nano RP2040 Connect board.

## Develop

## Upload

## Debug
