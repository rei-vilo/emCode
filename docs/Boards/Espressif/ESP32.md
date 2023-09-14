---
tags:
    - Active
---

# Espressif ESP32 boards

## Install

## Develop

## Upload to ESP32 boards with the ESP-Prog programmer-debugger

![](img/Logo-064-Espressif-Systems.png) The ESP-Prog programmer-debugger provides JTAG debugging and re-routes the serial console.

Proceed as follow:

+ Ensure OpenOCD for ESP32 has been installed. Otherwise, follow the procedure [Install the OpenOCD driver for ESP32](../../Install/Section4/#install-the-openocd-driver-for-esp32) :octicons-link-16:.

+ Follow the table at [Configure Other JTAG Interface](https://docs.espressif.com/projects/esp-idf/en/stable/api-guides/jtag-debugging/configure-other-jtag.html) :octicons-link-external-16: and connect power `+3.3V` and `Ground`, JTAG `TMS`, `TDI`, `TCK`, `TDO` and `RESET`, serial `TXD` and `RXD` pins of the board to the corresponding pins of the ESP-Prog programmer-debugger.

+ Open a **Terminal** and launch the command

``` bash
% sudo kextunload -b com.FTDI.driver.FTDIUSBSerialDriver
```

This command prevents macOS from enumerating all the ports of the ESP-Prog programmer-debugger as serial ports.

+ Connect the external programmer to the USB port.

In case the following message is displayed on the serial console,

```
Brownout detector was triggered
```

+ Power the ESP32 board through the `+5V` pin instead of the `+3.3V` pin.

The ESP32 board requires up to 400 mA and may exceed what a standard USB port can deliver.

+ Power the ESP32 board with an external power supply.

At the end of the session,

+ Open a **Terminal** and launch the command

``` bash
% sudo kextload -b com.FTDI.driver.FTDIUSBSerialDriver
```

This command allows macOS to automatically enumerate all the ports as serial ports again.

To check whether the FTDI driver is loaded,

+ Open a **Terminal** and launch the command

``` bash
% kextstat | grep FTDI
```

For more information on the ESP-Prog,

+ Please refer to [Introduction to the ESP-Prog Board](https://github.com/espressif/esp-iot-solution/blob/master/documents/evaluation_boards/ESP-Prog_guide_en.md) :octicons-link-external-16: and [Introduction to the ESP32 JTAG Debugging](https://docs.espressif.com/projects/esp-idf/en/stable/api-guides/jtag-debugging/index.html#) :octicons-link-external-16: on the Espressif website.

For more information on debugging the ESP32,

+ Please refer to the pages [MacOS](https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/jtag-debugging/configure-wrover.html#macos) :octicons-link-external-16: and [Manually unloading the driver ](https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/jtag-debugging/configure-wrover.html#manually-unloading-the-driver) :octicons-link-external-16: on the Espressif website.

## Upload to ESP32 boards using WiFi

![](img/Logo-064-Espressif-Systems.png) Although the ESP32 boards require no specific procedure for an over-the-air upload, the WiFi network needs to be installed and configured successfully before any upload.

Over-the-air upload requires that a sketch based on the ArduinoOTA library has been installed previously and is currently running. Otherwise,

+ Build and upload the `BasicOTA` example using the **Arduino IDE**.

Before uploading, please

+ Check that the router has discovered the ESP32 board and note the IP address.

+ It is recommended to proceed with a test of the WiFi connection. Either try pinging the board on the **Terminal**, or uploading a sketch from the Arduino IDE.

### Check the running sketch

The over-the-air process is managed by the sketch itself, based on the `ArduinoOTA` library.

If the `ArduinoOTA` object isn't running,

+ Build the `BasicOTA` example.

+ Upload using an USB connection.

!!! note
    The sketch requires twice its size.

### Check the WiFi connection

To identify the IP addresses of the ESP32 board,

+ Open a **Terminal** window.

+ Run the following command.

``` bash
$ arp -a
esp_a1b2c3 (192.168.240.1) at 12:ef:34:a1:b2:c3 on en0 ifscope [ethernet]
```

The address `192.168.240.1` gives access to the board.

+ Test the board is connected with ping.

``` bash
$ ping 192.168.240.1
```

### Enter IP address

During the first compilation, embedXcode looks for the ESP32 board.

If the ESP32 board isn't found on the network, a window asks for the IP address.

<center>![](img/359-03-360.png)</center>

+ Enter the IP address of the ESP32 board.

+ Click on **OK** to validate or **Cancel** to cancel.

When validated, the IP address is saved on the board configuration file `Adafruit Huzzah ESP32 (WiFi)` or `ESP32 DevKitC (WiFi)` in the project.

``` CMake
SSH_ADDRESS = 192.168.240.1
```

The IP address is only asked once.

+ To erase the IP address, just delete the whole line.

+ To edit the IP address, just change the left part after `SSH_ADDRESS =` on the corresponding line.

Password isn't implemented.

### Upload Wiring / Arduino sketch

![](img/Logo-064-Espressif-Systems.png) Once the checks have been performed successfully, proceed as follow:

Connect the ESP32 board to the network through WiFi.

+ Launch any of the targets **All**, **Upload** or **Fast**.

A window may ask for allowing incoming network connections.

+ Click on **Allow** to proceed.

!!! note
    The sketch requires twice its size.

For more information about the installation and use of the over-the-air upload,

Please refer to [Arduino library to upload sketch over network to supported Arduino board](https://github.com/jandrassy/ArduinoOTA#arduino-library-to-upload-sketch-over-network-to-supported-arduino-board) :octicons-link-external-16: at the ArduinoOTA repository.

Another procedure turns the ESP32 board into a web server.

+ Please refer to the procedure [Over the Air through Web browser](https://github.com/espressif/arduino-esp32/blob/master/docs/OTAWebUpdate/OTAWebUpdate.md) :octicons-link-external-16:.

## Debug

### Connect the ESP-Prog to the ESP32 board

![](img/Logo-064-Espressif-Systems.png) The ESP-Prog provides a PROG 2x3 2.54 mm 0.1" connector and a JTAG 2x5 2.54 mm 0.1" connector.

+ Ensure OpenOCD for ESP32 has been installed. Otherwise, follow the procedure [Install the OpenOCD driver for ESP32](../../Install/Section4/#install-the-openocd-driver-for-esp32) :octicons-link-16:.

+ Follow the table at [Configure Other JTAG Interface](https://docs.espressif.com/projects/esp-idf/en/stable/api-guides/jtag-debugging/configure-other-jtag.html) :octicons-link-external-16: and connect power `+3.3V` and `Ground`, JTAG `TMS`, `TDI`, `TCK`, `TDO` and `RESET`, serial `TXD` and `RXD` pins of the board to the corresponding pins of the ESP-Prog programmer-debugger.

+ Open a **Terminal** and launch the command

``` bash
% sudo kextunload -b com.FTDI.driver.FTDIUSBSerialDriver
```

This command prevents macOS from enumerating all the ports of the ESP-Prog programmer-debugger as serial ports.

+ Connect the external programmer to the USB port.

In case the following message is displayed on the serial console,

``` bash
Brownout detector was triggered
```

+ Power the ESP32 board through the `+5V` pin instead of the `+3.3V` pin.

The ESP32 board requires up to 400 mA and may exceed what a standard USB port can deliver.

+ Power the ESP32 board with an external power supply.

At the end of the session,

+ Open a **Terminal** and launch the command

``` bash
% sudo kextload -b com.FTDI.driver.FTDIUSBSerialDriver
```

This command allows macOS to automatically enumerate all the ports as serial ports again.

To check whether the FTDI driver is loaded,

+ Open a **Terminal** and launch the command

``` bash
% kextstat | grep FTDI
```

For more information on the ESP-Prog,

+ Please refer to [Introduction to the ESP-Prog Board](https://github.com/espressif/esp-iot-solution/blob/master/documents/evaluation_boards/ESP-Prog_guide_en.md) :octicons-link-external-16: and [Introduction to the ESP32 JTAG Debugging](https://docs.espressif.com/projects/esp-idf/en/stable/api-guides/jtag-debugging/index.html#) :octicons-link-external-16: on the Espressif website.

For more information on debugging the ESP32,

+ Please refer to the pages [MacOS](https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/jtag-debugging/configure-wrover.html#macos) :octicons-link-external-16: and [Manually unloading the driver ](https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/jtag-debugging/configure-wrover.html#manually-unloading-the-driver) :octicons-link-external-16: on the Espressif website.

