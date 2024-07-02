# Manage the Espressif platform

![](img/Logo-064-Espressif-Systems.png) The Espressif platform includes the [ESP8266](./ESP8266.md) and [ESP32](./ESP32.md) boards.

## Install Python 3

The ESP32 and ESP8266 require Python 3.

To check whether Python 3 is installed on your main computer,

+ Open a **Terminal** window.

+ Launch one of the following commands.

``` bash dollar
which python3
python3 --version
```

If the answers are `python3 not found` or `command not found: python3`, Python 3 needs to be installed.

``` bash dollar
sudo apt install python3
```

The ESP8266 utilities call Python 3 from a specific non-standard folder, and may raise an error.

To fix this issue,

+ Open a **Terminal** window.

+ Launch the following commands.

``` bash dollar lines="1"
which python3
/usr/local/bin/
```

The answer may differ from the example above. Note the path, here `/usr/local/bin/`, for the next step.

``` bash dollar
sudo mkdir /usr/local/bin/
sudo ln -s /usr/bin/python3 /usr/local/bin/python3
```

It creates a symbolic link for `python3` with the path expected by the ESP8266 utilities.

For more information on the installation process,

+ Please refer to the [Read Me](https://github.com/esp8266/Arduino) :octicons-link-external-16: page on the ESP8266 repository.

## Install the USB drivers

Depending on the board, a 3.3 V FTDI programmer may be required. The ESP8266-based board requires up to 400 mA.

For more information,

+ Please refer to [Installing and Building an Arduino Sketch for the $5 ESP8266 Micro-Controller](http://makezine.com/2015/04/01/installing-building-arduino-sketch-5-microcontroller/) :octicons-link-external-16: by Alasdair Allan.

The default uploader provided with the IDE, `esptool`, supports all the ESP8266-based boards, including the NodeMCU boards, since release 0.4.5.

However, the NodeMCU boards requires the installation of specific serial drivers.

+ Please follow the instructions at the section [Install the NodeMCU board](../../Install/Section4/#install-the-nodemcu-board).

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Platform | Package | Comment
---- | ---- |---- | ----
![](img/Logo-064-Espressif-Systems.png) | ESP32 | 3.0.2 | Valid for other ESP32-based boards<br>except Arduino Nano ESP32
| | ESP8266 | 3.0.1 | Valid for other ESP8266-based boards
![](img/Logo-064-eC.png) | emCode | 14.4.5 | 

## Visit the official websites

![](img/Logo-064-Espressif-Systems.png) | **ESP32**
:---- | ----
IDE | Arduino-CLI or Arduino IDE
Website | <http://espressif.com> :octicons-link-external-16:
Download | <https://github.com/espressif/arduino-esp32> :octicons-link-external-16:
Wiki | <http://esp32.net> :octicons-link-external-16:
Forum | <https://www.esp32.com> :octicons-link-external-16:
Forum | <http://bbs.espressif.com> :octicons-link-external-16:

![](img/Logo-064-Espressif-Systems.png) | **ESP8266**
:---- | ----
IDE | Arduino-CLI or Arduino IDE
Website | <http://espressif.com> :octicons-link-external-16:
Download | <https://github.com/esp8266/Arduino> :octicons-link-external-16:
Wiki | <http://www.esp8266.com/wiki/doku.php> :octicons-link-external-16:
Documentation | <https://arduino-esp8266.readthedocs.io/en> :octicons-link-external-16:
Forum | <http://www.esp8266.com> :octicons-link-external-16:
Forum | <http://bbs.espressif.com> :octicons-link-external-16:
