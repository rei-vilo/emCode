---
tags:
    - Active
---

# Manage the Seeed Xiao RP2040 boards

## Install

For the Xiao board based on the RP2040,

+ Please refer to [Install the Raspberry Pi Pico RP2040 platform](../RP2040/index.md) :octicons-link-16:.

## Develop

### Use the libraries for WiFi

### Use the libraries for Bluetooth

### Use the libraries for SD

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Platform | IDE | Package | Date | Comment
---- | ---- | ---- | ---- | ---- | ----
![](img/Logo-064-Seeeduino.png) | **Seeeduino** | Arduino 1.8 | AVR 1.3.0 | | For Seeed and Seeed Grove Beginner Kit
| | | | SAMD 1.8.0 | | For Xiao SAMD and Wio Terminal boards
| | | | Realtek 3.0.7 | | For RTL8720DN on Wio Terminal board

## Visit the official websites

![](img/Logo-064-Seeed.png) | **Seeeduino**
:---- | ----
IDE | Arduino CLI or 2.0 IDE
Website | <https://www.seeedstudio.com> :octicons-link-external-16:
Download | <http://wiki.seeed.cc/Seeed_Arduino_Boards> :octicons-link-external-16:
Wiki | <http://wiki.seeed.cc/Seeeduino_v4.2/> :octicons-link-external-16:
Xiao RP2040 | <https://wiki.seeedstudio.com/XIAO-RP2040/> :octicons-link-external-16:
Forum | <https://forum.seeedstudio.com/> :octicons-link-external-16:

## Install the Seeed Xiao ESP32

For the Xiao boards based on the ESP32,

+ Please refer to [Install the Espressif platform](./Espressif.md) :octicons-link-16:.

## Install the Seeed Wio Terminal

The Wio Terminal includes two MCUs: a SAMD51 Cortex-M4 MCU for general purpose, and an Ameba RTL8720DN for Wifi and Bluetooth radio.

### Install the SAMD platform for the Wio Terminal board

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install Seeeduino:samd
```

### Install the firmware and libraries for WiFi and Bluetooth

The initial firmware of the RTL8720 radio of the Wio Terminal only provides WiFi capabilities.

To use WiFi and Bluetooth, the Wio Terminal requires an update of the firmware and the installation of dedicated libraries.

+ Please follow the procedure [Update the Wireless Core Firmware](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/#update-the-wireless-core-firmware) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_rpcWiFi](https://github.com/Seeed-Studio/Seeed_Arduino_rpcWiFi) :octicons-link-external-16: .

+ Download and install the library [Seeed_Arduino_rpcBLE](https://github.com/Seeed-Studio/Seeed_Arduino_rpcBLE) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_rpcUnified](https://github.com/Seeed-Studio/Seeed_Arduino_rpcUnified) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_FreeRTOS](https://github.com/Seeed-Studio/Seeed_Arduino_FreeRTOS) :octicons-link-external-16:.

The previous firmware based on AT-commands only provides WiFi capabilities.

+ Please follow the procedure [RTL8720 AT-Command Structure Firmware](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/#rtl8720-at-command-structure-firmware) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_atWiFi](https://github.com/Seeed-Studio/Seeed_Arduino_atWiFi) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_atWiFiClientSecure](https://github.com/Seeed-Studio/Seeed_Arduino_atWiFiClientSecure.git) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_atUnified](https://github.com/Seeed-Studio/Seeed_Arduino_atUnified) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_ESP-AT-library](https://github.com/Seeed-Studio/esp-at-lib) :octicons-link-external-16:.

+ Download and install the library [Seeed-Arduino-FreeRTOS](https://github.com/Seeed-Studio/Seeed_Arduino_FreeRTOS) :octicons-link-external-16:.

+ Download and install the library [Seeed_Arduino_mbedtls](https://github.com/Seeed-Studio/Seeed_Arduino_mbedtls) :octicons-link-external-16:.

### Install the Ameba RTL8720DN platform for the Wio Terminal board

Apart from the main SAMD51 MCU, the Seeed SAMD Wio Terminal board includes another MCU, RTL8720DN, in charge of WiFi and Bluetooth.

To install the RTL8720DN of the Wio Terminal board,

``` bash
$
arduino-cli core install realtek:AmebaD
```

+ Download and install the supported versions of the Arduino IDE under the `/Applications` folder, as described in the section [Install the Arduino platform](../../Install/Section4/Arduino) :octicons-link-16:.

+ Launch it.

+ Define the path of the sketchbook folder in the menu **Arduino > Preferences > Sketchbook location**.

+ Avoid spaces in the name and path of the sketchbook folder.

+ Follow the procedure [Install additional boards on Arduino](../../Install/Section4/#install-additional-boards-on-arduino) :octicons-link-16:.

+ Call the **Boards Manager** and check the Seeed SAMD boards are listed.

<center>![](img/131-03-420.png)</center>

If the Seeed boards aren't listed on the **Boards Manager**,

+ Open the **Preferences**.

+ Add the following URL on a separate line, as described in section [Add URLs for new boards](../../Install/Section4/#add-urls-for-new-boards) :octicons-link-16:.

```
https://github.com/ambiot/ambd_arduino/raw/master/Arduino_package/package_realtek.com_amebad_index.json
```

+ Select the boards and click on **Install**.

For more information on the installation process,

+ Please refer to the [Update the Wireless Core Firmware - CLI Methods](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/) :octicons-link-external-16: page on the Seeed Studio website.

+ Get the [RTL8720 firmware](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/#step-3-download-the-latest-firmware) :octicons-link-external-16: [command line utilities](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/#cli-methods) :octicons-link-external-16: on the Seeed Studio website.

Using the RTL8720DN requires a utility running on the SAMD51 to provide a bridge between the  RTL8720DN and the serial over USB.

+ Read [How to Use Wio Terminal as RTL8720DN Dev Board](https://wiki.seeedstudio.com/Wio-Terminal-8720-dev) :octicons-link-external-16: on the Seeed Studio website.

+ Download the [rtl8720_update](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/#step-1-arduino-configuration) :octicons-link-external-16: or [WioTerminal_USB2Serial_Burn8720](https://github.com/Seeed-Studio/Seeed_Arduino_Sketchbook) :octicons-link-external-16: on the Seeed Studio website.

---

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install Seeeduino:avr
arduino-cli core install Seeeduino:nrf52
arduino-cli core install Seeeduino:samd
```

![](img/Logo-064-Seeeduino.png) The installation of the Seeed platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

!!! warning
    Upload to this board hasn't been tested.

## Install the Seeed AVR platform

To install the Seeed AVR boards,

+ Download and install the supported versions of the Arduino IDE under the `/Applications` folder, as described in the section [Install the Arduino platform](../../Install/Section4/Arduino) :octicons-link-16:.

+ Launch it.

+ Define the path of the sketchbook folder in the menu **Arduino > Preferences > Sketchbook location**.

+ Avoid spaces in the name and path of the sketchbook folder.

+ Follow the procedure [Install additional boards on Arduino](../../Install/Section4/#install-additional-boards-on-arduino) :octicons-link-16:.
Call the **Boards Manager** and check the Seeed AVR boards are listed.

<center>![](img/131-01-420.png)</center>

If the Seeed boards aren't listed on the **Boards Manager**,

+ Open the **Preferences**.

+ Add the following URL on a separate line, as described in section [Add URLs for new boards](../../Install/Section4/#add-urls-for-new-boards) :octicons-link-16:.

``` CMake
https://raw.githubusercontent.com/Seeed-Studio/Seeed_Platform/master/package_seeeduino_boards_index.json
```

+ Select the boards and click on **Install**.

For more information on the installation process,

+ Please refer to the [How to Add Seeed Boards to Arduino IDE](http://wiki.seeed.cc/Seeed_Arduino_Boards/) :octicons-link-external-16: page on the Seeed Studio website.

## Install the Seeed SAMD platform

The Seeed SAMD Xiao board includes the compact Xiao board and the IoT-enabled Wio Terminal.

To install the Seeed SAMD platform,

+ Download and install the supported versions of the Arduino IDE under the `/Applications` folder, as described in the section [Install the Arduino platform](../../Install/Section4/Arduino) :octicons-link-16:.

+ Launch it.

+ Define the path of the sketchbook folder in the menu **Arduino > Preferences > Sketchbook location**.

+ Avoid spaces in the name and path of the sketchbook folder.

+ Follow the procedure [Install additional boards on Arduino](../../Install/Section4/#install-additional-boards-on-arduino) :octicons-link-16:.

+ Call the **Boards Manager** and check the Seeed SAMD boards are listed.

<center>![](img/131-02-420.png)</center>

If the Seeed boards aren't listed on the **Boards Manager**,

+ Open the **Preferences**.

+ Add the following URL on a separate line, as described in section [Add URLs for new boards](../../Install/Section4/#add-urls-for-new-boards) :octicons-link-16:.

``` CMake
https://raw.githubusercontent.com/Seeed-Studio/Seeed_Platform/master/package_seeeduino_boards_index.json
```

+ Select the boards and click on **Install**.

For more information on the installation process,

+ Please refer to the [How to Add Seeed Boards to Arduino IDE](http://wiki.seeed.cc/Seeed_Arduino_Boards/) :octicons-link-external-16: page on the Seeed Studio website.

The boards package does not include the utilities for the UF2 upload.

+ Please install them from the [Adafruit Feather nRF52](../../Install/Section4/Adafruit) :octicons-link-16: package.

## Develop

### Use the libraries for WiFi

### Use the libraries for Bluetooth

Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = ArduinoBLE
```

### Use the libraries for SD

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Platform | IDE | Package | Date | Comment
---- | ---- | ---- | ---- | ---- | ----
![](img/Logo-064-Seeeduino.png) | **Seeeduino** | Arduino 1.8 | AVR 1.3.0 | | For Seeed and Seeed Grove Beginner Kit
| | | | SAMD 1.8.0 | | For Xiao SAMD and Wio Terminal boards
| | | | Realtek 3.0.7 | | For RTL8720DN on Wio Terminal board

## Visit the official websites

![](img/Logo-064-Seeed.png) | **Seeeduino**
:---- | ----
IDE | Arduino CLI or 2.0 IDE
Website | <https://www.seeedstudio.com> :octicons-link-external-16:
Download | <http://wiki.seeed.cc/Seeed_Arduino_Boards> :octicons-link-external-16:
Wiki | <http://wiki.seeed.cc/Seeeduino_v4.2/> :octicons-link-external-16:
Xiao M0 | <https://wiki.seeedstudio.com/Seeeduino-XIAO/> :octicons-link-external-16:
Xiao RP2040 | <https://wiki.seeedstudio.com/XIAO-RP2040/> :octicons-link-external-16:
Xiao nRF52840 | <https://wiki.seeedstudio.com/XIAO_BLE/> :octicons-link-external-16:
Xiao ESP32C3 | <https://wiki.seeedstudio.com/XIAO_ESP32C3_Getting_Started/> :octicons-link-external-16:
Xiao ESP32S3 | <https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/> :octicons-link-external-16:
Wio Terminal | <https://wiki.seeedstudio.com/Wio-Terminal-Getting-Started/> :octicons-link-external-16:
Forum | <https://forum.seeedstudio.com/> :octicons-link-external-16:
