---
tags:
    - Active
---

# Manage the Arduino ESP32 boards

The Arduino ESP32 platform includes the Arduino Nano ESP32 board.

Although also supported by the [Espressif platform](../Espressif/ESP32.md), the Arduino Nano ESP32 board uses a specific protocol for upload. 

## Install 

To install the Arduino ESP32 boards,

To install the Arduino SAM boards,

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install arduino:esp32
```

## Upload with dfu-util

The Arduino Nano ESP32 uses a specific uploader.

On Linux, the device table needs to be updated.

+ Launch

``` bash percent
sudo nano /etc/udev/rules.d/99-arduino.rules
```

+ Add the following line.

``` bash
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", GROUP="plugdev", MODE="0666"
```

+ Reload the devices table.

``` bash percent
sudo udevadm control --reload-rules
```

For more information on `udev` rules, 

+ Please refer to [Fix udev rules on Linux](https://support.arduino.cc/hc/en-us/articles/9005041052444-Fix-udev-rules-on-Linux) :octicons-link-external-16:.

## Develop

### Use the libraries for WiFi

### Use the libraries for Bluetooth

### Use the libraries for SD

## Upload

The Arduino Nano ESP32 board uses a specific protocol for upload, `dfu-util`, instead of the standard `esptool`. 

If the RGB LED is not green, double-press on the **RESET** button.

In case the board remains unresponsive, 

+ Please follow the procedure [Reset the Arduino bootloader on the Nano ESP32](https://support.arduino.cc/hc/en-us/articles/9810414060188-Reset-the-Arduino-bootloader-on-the-Nano-ESP32) :octicons-link-external-16:.

## Debug

