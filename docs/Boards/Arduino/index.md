# Manage the Arduino platform

![](img/Logo-064-Arduino.png) The IDE for all the Arduino boards is called Arduino with release 1.8.

+ [Arduino AVR](./AVR.md) :octicons-link-16:;
+ [Arduino MegaAVR](./MegaAVR.md) :octicons-link-16:;
+ [Arduino SAM](./SAM.md) :octicons-link-16:;
+ [Arduino SAMD](./SAMD) :octicons-link-16:;
+ [Arduino ESP32](./ESP32.md) :octicons-link-16:;
+ [Arduino nRF52](./nRF.md) :octicons-link-16:;
+ [Arduino RP2040](./RP2040.md) :octicons-link-16:;
+ [Arduino Mbed-OS](./Mbed.md) :octicons-link-16:.

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install arduino:avr
arduino-cli core install arduino:mbed_nano
arduino-cli core install arduino:mbed_rp2040
arduino-cli core install arduino:megaavr
arduino-cli core install arduino:nrf52
arduino-cli core install arduino:sam
arduino-cli core install arduino:samd
```

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Package | Release | Date | Comment
---- | ---- | ---- | ---- | ----
![](img/Logo-064-ArduinoCC.png) | | AVR | 1.8.6 | | For Uno and Mega boards
| | mbed-nano | 3.5.1 | | For Nano 33 BLE boards
| | mbed-RP2040 | 3.5.4 | | For Raspberry Pi Pico RP2040 boards, not recommended
| | MegaAVR | 1.8.7 | | For Nano Every board
| | nRF52 | 1.0.2 | | For Primo and Primo Core boards, archived
| | SAM | 1.6.12 | | For Due board
| | SAMD | 1.8.13 | | For Nano 33 IoT, Zero, M0 and Tian boards
![](img/Logo-064-emCode.png) | **emCode** | 13.0.1 | 03 Feb 2023 | Last update

## Visit the official websites

![](img/Logo-064-ArduinoCC.png) | **Arduino**
---- | ----
Arduino IDE | <https://github.com/arduino/arduino-ide> :octicons-link-external-16:
Arduino CLI | <https://github.com/arduino/arduino-cli> :octicons-link-external-16:
Arduino AVR | <https://github.com/arduino/ArduinoCore-avr> :octicons-link-external-16:
Arduino megaAVR | <https://github.com/arduino/ArduinoCore-megaavr> :octicons-link-external-16:
Arduino SAMD | <https://github.com/arduino/ArduinoCore-samd> :octicons-link-external-16:
Arduino SAM | <https://github.com/arduino/ArduinoCore-sam> :octicons-link-external-16:
Arduino Mbed-OS | <https://github.com/arduino/ArduinoCore-mbed> :octicons-link-external-16:
Arduino nRF52 | <https://github.com/arduino/ArduinoCore-primo> :octicons-link-external-16:
