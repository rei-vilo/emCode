# Manage the Espressif platform

![](img/Logo-064-Espressif-Systems.png) The Espressif platform includes the ESP8266 and ESP32 boards.

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install esp8266:esp8266
arduino-cli core install esp32:esp32
```

For more information on the installation process,

+ Please refer to the [Read Me](https://github.com/espressif/arduino-esp32) :octicons-link-external-16: page on the ESP32 repository and the [ESP32 DevKitC Getting Started Guide](https://espressif.com/en/content/esp32-devkitc-getting-started-guide) :octicons-link-external-16: document from the Espressif website.

Additionally, the ESP32 boards supports JTAG debugging with the ESP-Prog programmer-debugger and a specific version of OpenOCD.

+ Please refer to the section [Install the OpenOCD driver for ESP32 driver](../../Install/Section4/#install-the-openocd-driver-for-esp32-driver) :octicons-link-16:.

## Install Python 3

The ESP32 and ESP8266 require Python 3, which may not be available on your Mac.

<center>![](img/Logo-064-Python.png)</center>

To check whether Python 3 is installed on your Mac,

+ Open a **Terminal** window.

+ Launch one of the following commands.

``` bash
$
which python3
python3 --version
```

If the answers are `python3 not found` or `command not found: python3`, Python 3 needs to be installed.

``` bash
$
sudo apt install python3
```

The ESP8266 utilities call Python 3 from a specific non-standard folder, and may raise an error.

To fix this issue,

+ Open a **Terminal** window.

+ Launch the following commands.

``` bash
$
which python3
/usr/local/bin/
```

The answer may differ from the example above. Note the path, here `/usr/local/bin/`, for the next step.

``` bash
$
sudo mkdir /usr/local/bin/
sudo ln -s /usr/bin/python3 /usr/local/bin/python3
```

It creates a symbolic link for `python3` with the path expected by the ESP8266 utilities.

For more information on the installation process,

+ Please refer to the [Read Me](https://github.com/esp8266/Arduino) :octicons-link-external-16: page on the ESP8266 repository.

## Install the USB drivers

Depending on the board, a 3.3 V FTDI programmer may be required. The ESP8266-based board requires up to 400 mA. For more information,

+ Please refer to [Installing and Building an Arduino Sketch for the $5 ESP8266 Micro-Controller](http://makezine.com/2015/04/01/installing-building-arduino-sketch-5-microcontroller/) :octicons-link-external-16: by Alasdair Allan.

The default uploader provided with the IDE, `esptool`, supports all the ESP8266-based boards, including the NodeMCU boards, since release 0.4.5.

However, the NodeMCU boards requires the installation of specific serial drivers.

+ Please follow the instructions at the section [Install the NodeMCU board](../../Install/Section4/#install-the-nodemcu-board) :octicons-link-16:.

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Platform | Package | Date | Comment
---- | ---- |---- | ---- | ----
![](img/Logo-064-Espressif-Systems.png) | ESP32 | 2.0.7 | | Valid for other ESP32 and ESP32C3-based boards
| | ESP8266 | 3.0.1 | | Valid for other ESP8266-based boards
![](img/Logo-064-eC.png) | emCode | 13.0.4 | 28 Feb 2023 |

## Visit the official websites

![](img/Logo-064-Espressif-Systems.png) | **ESP32**
:---- | ----
IDE | Arduino CLI or 2.0 IDE
Website | <http://espressif.com> :octicons-link-external-16:
Download | <https://github.com/espressif/arduino-esp32> :octicons-link-external-16:
Wiki | <http://esp32.net> :octicons-link-external-16:
Forum | <https://www.esp32.com> :octicons-link-external-16:
Forum | <http://bbs.espressif.com> :octicons-link-external-16:

![](img/Logo-064-Espressif-Systems.png) | **ESP8266**
:---- | ----
IDE | Arduino CLI or 2.0 IDE
Website | <http://espressif.com> :octicons-link-external-16:
Download | <https://github.com/esp8266/Arduino> :octicons-link-external-16:
Wiki | <http://www.esp8266.com/wiki/doku.php> :octicons-link-external-16:
Forum | <http://www.esp8266.com> :octicons-link-external-16:
Forum | <http://bbs.espressif.com> :octicons-link-external-16:
