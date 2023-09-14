# Glossary

The glossary provides a short definition of the most common terms, and provides links to the related entries.

## 4D Systems

The 4D Systems boards combine a colour touch screen with a controller.

+ The IoD boards are powered by an ESP8266 MCU, They rely on the ESP8266 boards package for the Arduino IDE with a modified file and the specific TFT display library.

+ The PICadillo-35T board combines a PIC32 MCU with a 480x320 TFT screen. The IDE used to be MPIDE with additional files and the specific TFT display library. As MPIDE is deprecated, the board is supported by the Arduino IDE with the chipKIT boards package.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:,  [chipKIT](../../Appendixes/Glossary/#chipkit) :octicons-link-16:, [MPIDE](../../Appendixes/Glossary/#mpide) :octicons-link-16:
>
>*Install*: [Install the chipKIT platform](../../Legacy/Section4/Page2) :octicons-link-16:, [Install the 4D Systems platform](../../Legacy/Section4/Page3) :octicons-link-16:

## Adafruit

Adafruit offers a large range of highly-compact boards based on the ATtiny85x and the ATmega328P.

The installation of the Adafruit boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:
>
>*Install*: [Install the Adafruit platform](../../Install/Section4/Adafruit) :octicons-link-16:
>
>*Upload*: [Upload to Adafruit Trinket and Pro Trinket boards](../../Advanced/Specific-1/#upload-to-adafruit-trinket-and-pro-trinket-boards) :octicons-link-16:, [Upload to Feather M0 and M4 boards](../../Advanced/Specific-1/#upload-to-feather-m0-and-m4-boards) :octicons-link-16:
>
>*Debug*: [Check the configuration](../../Debug/Section3/) :octicons-link-16:

## Application libraries

The application libraries are optional libraries to provide additional features, like managing the specific I&sup2;C and SPI ports.

They are defined by each of the IDEs.

By default, no application library is included.

They require to be explicitly mentioned with the `#include` statement on the main sketch and listed on the main `Makefile` after the `APP_LIBS_LIST` variable.

The embedXcode+ edition lists all the application libraries for the selected platform on the main `Makefile`.

>*Related entries*: [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Libraries](../../Appendixes/Glossary/#libraries) :octicons-link-16:

## Architecture

The MCUs are grouped in families or architectures.

As example, one characteristic of the architectures is the number of bits used to process data. It could be

+ 8-bit for the ATtiny and ATmega,

+ 16-bit for the MSP430

+ or 32-bit for the ARM.

Other characteristics include the structure of the hardware and the instruction set.

Each architecture requires its dedicated tool-chain.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [MCU](../../Appendixes/Glossary/#mcu) :octicons-link-16:, [Particle](../../Appendixes/Glossary/#particle) :octicons-link-16:, [Platform](../../Appendixes/Glossary/#platform) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:

## ArduCAM

ArduCAM specialises in cameras and offers two boards with WiFi and an Arduino form-factor.

The ArduCAM CC3200 is based on the CC3200 and runs on Energia.

The ArduCAM ESP8266 is based on ESP8266 and runs on Arduino 1.6 IDE. The installation is performed with the **Boards Manager**.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [ESP8266](../../Appendixes/Glossary/#esp8266) :octicons-link-16:
>
>*Install*: [Install the ArduCAM platform](../../Legacy/Section4/Page1) :octicons-link-16:
>
>*Upload*: [Upload to ArduCAM CC3200 Board](../../Legacy/Section4/#upload-to-arducam-cc3200-board) :octicons-link-16:

## Arduino

The Arduino name includes hardware, a framework and an IDE.

The boards are based on two major architectures, one 8-bit, others 32-bit:

+ 8-bit ATtiny and ATmega,

+ 32-bit ARM Cortex-M with different MCUs:

    + 32-bit ARM SAM for the Arduino Due and the Arduino Zero Pro,

    + 32-bit ARM SAMD for the Arduino Zero and the Arduino M0 Pro.

    + 32-bit ARM nRF52 for the Arduino Primo boards, now discontinued,

    + 32-bit ARM STM32F4 for the Arduino Star Otto boards, never released,

    + 32-bit ARM nRF528x for the Arduino Nano 33 BLE boards, based on Mbed-OS

The Arduino IDE version 1.8 now supports all the boards from previous organisations and IDEs, Arduino.CC with IDE version 1.6 and Arduino.ORG with IDE version 1.7.

>*Related entries*: [4D Systems](../../Appendixes/Glossary/#4d-systems) :octicons-link-16:, [Adafruit](../../Appendixes/Glossary/#adafruit) :octicons-link-16:, [Architecture](../../Appendixes/Glossary/#architecture) :octicons-link-16:, [ArduCAM](../../Appendixes/Glossary/#arduCAM) :octicons-link-16:, [ARM mbed](../../Appendixes/Glossary/#arm-mbed) :octicons-link-16:, [ATTinyCore](../../Appendixes/Glossary/#attinycore) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [DFRobot](../../Appendixes/Glossary/#dFRobot) :octicons-link-16:, [ESP32](../../Appendixes/Glossary/#esp32) :octicons-link-16:, [ESP8266](../../Appendixes/Glossary/#esp8266) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Glowdeck](../../Appendixes/Glossary/#glowdeck) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Intel](../../Appendixes/Glossary/#intel) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:, [LightBlue Bean](../../Appendixes/Glossary/#lightBlue Bean) :octicons-link-16:, [Little Robot Friends](../../Appendixes/Glossary/#little Robot Friends) :octicons-link-16:, [MediaTek LinkIt](../../Appendixes/Glossary/#mediaTek LinkIt) :octicons-link-16:, [Microduino](../../Appendixes/Glossary/#microduino) :octicons-link-16:, [Microsoft](../../Appendixes/Glossary/#microsoft) :octicons-link-16:, [Moteino](../../Appendixes/Glossary/#moteino) :octicons-link-16:, [MPIDE](../../Appendixes/Glossary/#mpide) :octicons-link-16:, [panStamp](../../Appendixes/Glossary/#panStamp) :octicons-link-16:, [Particle](../../Appendixes/Glossary/#particle) :octicons-link-16:, [RedBear](../../Appendixes/Glossary/#redbear) :octicons-link-16:, [RFduino](../../Appendixes/Glossary/#rfduino) :octicons-link-16:, [Seeeduino](../../Appendixes/Glossary/#seeeduino) :octicons-link-16:, [Simblee](../../Appendixes/Glossary/#simblee) :octicons-link-16:, [TinyCircuits](../../Appendixes/Glossary/#tinyCircuits) :octicons-link-16:, [Udoo Neo](../../Appendixes/Glossary/#udoo-neo) :octicons-link-16:
>
>*Install*: [Install the Arduino platform](../../Install/Section4/Arduino) :octicons-link-16:
>
>*Upload*: [Upload to Arduino Leonardo](../../Advanced/Specific-1/#upload-to-arduino-leonardo) :octicons-link-16:, [Upload to Arduino Y&uacute;n using Ethernet or WiFi](../../Advanced/Specific-1/#upload-to-arduino-yn-using-ethernet-or-wifi) :octicons-link-16:, [Upload to Arduino M0 Pro](../../Advanced/Specific-1/#upload-to-arduino-m0-pro) :octicons-link-16:, [Upload to Arduino Zero](../../Advanced/Specific-1/#upload-to-arduino-zero) :octicons-link-16:
>
>*Debug*: [Check the configuration](../../Debug/Section3/) :octicons-link-16:, [Connect the Segger J-Link to the Arduino Due](../../Debug/Section3/#connect-the-segger-j-link-to-the-arduino-due) :octicons-link-16:, [Select the USB Port for the Arduino M0 Pro](../../Debug/Section3/#select-the-usb-port-for-the-arduino-m0-pro) :octicons-link-16:

## ARM mbed

The ARM mbed framework is designed for the ARM MCUs.

It includes a hardware abstraction layer and runs on a large range of boards based on Cortex-M0, M3 and M4 MCUs. It also features a real time operating system, or RTOS.

Up to now, mbed was available solely online. It can now be downloaded and used off line with standard tools as the GCC tool-chain and the OpenOCD debugger.

Most of the high level libraries of ARM mbed are written in C++. The mbed SDK has gone through major updates, first with Mbed-OS 3.0 and now Mbed-OS 5.0

Support for the mbed SDK is discontinued.

The Mbed-OS is also used as an underlying SDK for the Arduino framework, for example for the Nano 33 BLE boards.

The Nucleo boards are now supported by the STM32duino platform.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Freedom](../../Appendixes/Glossary/#freedom) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [Nordic](../../Appendixes/Glossary/#nordic) :octicons-link-16:, [Nucleo](../../Appendixes/Glossary/#nucleo) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:, [RedBear](../../Appendixes/Glossary/#redbear) :octicons-link-16:,  [STM32duino](../../Appendixes/Glossary/#stm32duino) :octicons-link-16:
>
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework) :octicons-link-16:
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) :octicons-link-16:

## ATtinyCore

The ATtinyCore supports the ATtiny MCUs.

The installation of the ATtinyCore boards is  performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:
>
>*Install*: [Install the ATtinyCore platform](../../Install/Section4/#install-the-attinycore-platform) :octicons-link-16:

## BBC micro:bit

The BBC micro:bit is built around the Nordic nRF51 with a Bluetooth radio. It also features a hardware debugger.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:
>
>*Install*: [Install the BBC micro:bit board](../../Install/Section4/Page10) :octicons-link-16:
>
>*Upload*: [Reset the BBC micro:bit board to factory default](../../Advanced/Specific-2/#reset-the-bbc-microbit-board-to-factory-default) :octicons-link-16:

## BeagleBone

The BeagleBone is a board featuring a Cortex-A8 AM3358 processor from Texas Instruments and running on Linux. The recommended Linux distribution is Debian.

Support for the BeagleBone board has been discontinued since embedXcode release 5.0.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:
>
>*Install*: [Install the BeagleBone board](../../Legacy/Section7/#install-the-beaglebone-board) :octicons-link-16:
>
>*Upload*: [Upload to BeagleBone board](../../Legacy/Section7/#upload-to-beaglebone-board) :octicons-link-16:

## Boards

A board is hardware defined by its MCU.

For example, the LaunchPad Stellaris is based on the ARM Cortex-M4 LM4F120H5QR MCU.

All the embedded computing boards use a Processing-based Wiring-derived Arduino- like IDE or run on the mbed platform.

For the Wiring / Arduino framework, the boards share the same Processing-based IDE, use the same Wiring-derived framework and bring the same Arduino-like programming with sketches written in C++.

The IDE includes the tool-chain specific to the boards.

For the mbed framework, the boards feature an ARM Cortex-M0, -M0+, M3 or M4, use the same mbed SDK on the GCC tool-chain.

>*Related entries*: [4D Systems](../../Appendixes/Glossary/#4d-systems) :octicons-link-16:, [Adafruit](../../Appendixes/Glossary/#adafruit) :octicons-link-16:, [Architecture](../../Appendixes/Glossary/#architecture) :octicons-link-16:, [ArduCAM](../../Appendixes/Glossary/#arduCAM) :octicons-link-16:, [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [ARM mbed](../../Appendixes/Glossary/#arm-mbed) :octicons-link-16:, [ATTinyCore](../../Appendixes/Glossary/#attinycore) :octicons-link-16:, [BBC micro:bit](../../Appendixes/Glossary/#bbc-microbit) :octicons-link-16:, [BeagleBone](../../Appendixes/Glossary/#beagleBone) :octicons-link-16:, [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [chipKIT](../../Appendixes/Glossary/#chipkit) :octicons-link-16:, [DFRobot](../../Appendixes/Glossary/#dFRobot) :octicons-link-16:, [Digistump](../../Appendixes/Glossary/#digistump) :octicons-link-16:, [ESP32](../../Appendixes/Glossary/#esp32) :octicons-link-16:, [ESP8266](../../Appendixes/Glossary/#esp8266) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Freedom](../../Appendixes/Glossary/#freedom) :octicons-link-16:, [Glowdeck](../../Appendixes/Glossary/#glowdeck) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Intel](../../Appendixes/Glossary/#intel) :octicons-link-16:, [LaunchPad](../../Appendixes/Glossary/#launchPad) :octicons-link-16:, [LightBlue Bean](../../Appendixes/Glossary/#lightBlue Bean) :octicons-link-16:, [Little Robot Friends](../../Appendixes/Glossary/#little Robot Friends) :octicons-link-16:, [Maple](../../Appendixes/Glossary/#maple) :octicons-link-16:, [MCU](../../Appendixes/Glossary/#mcu) :octicons-link-16:, [MediaTek LinkIt](../../Appendixes/Glossary/#mediaTek LinkIt) :octicons-link-16:, [Microduino](../../Appendixes/Glossary/#microduino) :octicons-link-16:, [Microsoft](../../Appendixes/Glossary/#microsoft) :octicons-link-16:, [Moteino](../../Appendixes/Glossary/#moteino) :octicons-link-16:, [Nordic](../../Appendixes/Glossary/#nordic) :octicons-link-16:, [Nucleo](../../Appendixes/Glossary/#nucleo) :octicons-link-16:, [panStamp](../../Appendixes/Glossary/#panStamp) :octicons-link-16:, [Particle](../../Appendixes/Glossary/#particle) :octicons-link-16:, [Platform](../../Appendixes/Glossary/#platform) :octicons-link-16:, [RedBear](../../Appendixes/Glossary/#redbear) :octicons-link-16:, [RFduino](../../Appendixes/Glossary/#rfduino) :octicons-link-16:, [Robotis](../../Appendixes/Glossary/#robotis) :octicons-link-16:, [Seeeduino](../../Appendixes/Glossary/#seeeduino) :octicons-link-16:, [Simblee](../../Appendixes/Glossary/#simblee) :octicons-link-16:, [Teensy](../../Appendixes/Glossary/#teensy) :octicons-link-16:, [TinyCircuits](../../Appendixes/Glossary/#tinyCircuits) :octicons-link-16:, [Udoo Neo](../../Appendixes/Glossary/#udoo-neo) :octicons-link-16:, [Wiring](../../Appendixes/Glossary/#wiring) :octicons-link-16:

## C++ language

The C++ is a programming language based on the C language. It features object-oriented features like classes.

It is used for programming the embedded computing boards.

>*Related entries*: [ARM mbed](../../Appendixes/Glossary/#arm mbed) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [File .cpp](../../Appendixes/Glossary/#file-cpp) :octicons-link-16:, [File .h](../../Appendixes/Glossary/#file-h) :octicons-link-16:, [File .hpp](../../Appendixes/Glossary/#file-hpp) :octicons-link-16:, [File .ino](../../Appendixes/Glossary/#file-ino) :octicons-link-16:, [File .pde](../../Appendixes/Glossary/#file-pde) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Sketch](../../Appendixes/Glossary/#sketch) :octicons-link-16:, [Tool-Chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:

## chipKIT

chipKIT uses the PIC32 MCUs.

The IDE used to be MPIDE. The installation of the chipKIT board is now performed with the **Boards Manager** on the Arduino 1.8 IDE.

An optional chipKIT PGM provides an external programmer-debugger to the chipKIT boards.

>*Related entries*: [4D Systems](../../Appendixes/Glossary/#4d-systems) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:, [MPIDE](../../Appendixes/Glossary/#mpide) :octicons-link-16:
>
>*Install*: [Install the chipKIT platform](../../Legacy/Section4/Page2) :octicons-link-16:
>
>*Upload*: [Upload to chipKIT boards using a programmer-debugger](../../Legacy/Section4/#upload-to-chipkit-boards-using-a-programmer-debugger) :octicons-link-16:
>
> *Debug*: [Debug the chipKIT boards with MDB](../../Legacy/Section4/#debug-the-chipkit-boards-with-mdb) :octicons-link-16:

## Core libraries

The core libraries include all the basic functions required for development.

Each platform provides its own set compatible with the Wiring and Arduino framework.

All the core libraries are included for compilation using one single `#include` statement on the main sketch. The same `#include` statement is also required on the header files.

This is done with

+ the `#include "Arduino.h"` statement for the Arduino, Energia, Microduino and Teensy platforms,

+ the `#include "Wiring.h"` for the call , while Wiring platform, and

+ the `#include "WProgram.h"` for the chipKIT MPIDE and Maple IDE platforms.

>*Related entries*: [File .h](../../Appendixes/Glossary/#file-h) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Libraries](../../Appendixes/Glossary/#libraries) :octicons-link-16:

## Cosa

Cosa is an object-oriented framework compatible with Arduino for the AVR-based boards.

The installation of the Cosa framework is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:
>
>*Install*: [Install the Cosa framework](../../Legacy/Section6/#install-the-cosa-framework) :octicons-link-16:

## Debugger

Debugging allows to execute a program one line at a time, check and change the values of the variables, trace the calls of functions, ... It consists on a combination of hardware and software.

There are two ways of debugging:

+ **Software debugging**, most of the time performed by injecting code like the basic `printf("i=%d\n", i)` or `Serial.println(i, DEC);`.

+ **Hardware debugging**, with a specific chip called a debugger or emulator along the MCU being debugged, and dedicated external applications.

Some boards, like the LaunchPad boards by Texas Instruments and the Nucleo boards by STMicroelectronics, include a built-in hardware debugger.

To use the hardware debugger, two external applications are required, based on a client-server model: a client connects to a server. The most widely used client is GDB. The server is a proprietary or open-source driver, and includes MSPDebug, Segger J-Link, ST-Link or OpenOCD.

The chipKIT PGM provides an external programmer-debugger to the chipKIT boards.

>*Related entries*: [BBC micro:bit](../../Appendixes/Glossary/#bbc-microbit) :octicons-link-16:, [chipKIT](../../Appendixes/Glossary/#chipkit) :octicons-link-16:, [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [LaunchPad](../../Appendixes/Glossary/#launchPad) :octicons-link-16:, [GDB GNU Debugger](../../Appendixes/Glossary/#gnu-debugger) :octicons-link-16:,  [MPIDE](../../Appendixes/Glossary/#mpide) :octicons-link-16:, [MSPDebug](../../Appendixes/Glossary/#mspdebug) :octicons-link-16:, [Segger J-Link programmer-debugger](../../Appendixes/Glossary/#segger-j-link-programmer-debugger) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:, [XDS110 programmer-debugger](../../Appendixes/Glossary/#xds110-programmer-debugger) :octicons-link-16:

## DFRobot

The BLuno and Wido boards from DFRobot provide an easy introduction to the internet-of-things.

The BLuno board integrates Bluetooth 4.0 or BLE into a standard Arduino Uno board and the Wido board integrates WiFi into a standard Arduino Leonardo board.

The BLuno board is considered as a standard Arduino Uno board and the Wido board as a standard Arduino Leonardo board, so no specific plug-in is required.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:
>
>*Install*: [Install the DFRobot platform](../../Install/Section4/#install-the-dfrobot-platform) :octicons-link-16:

## Digistump

The Digistump platform offers different boards.

+ The Digispark is based on the ATtiny85 and requires a specific upload procedure.

+ The DigiX is compatible with the Arduino Due.

The coming Oak is based on the popular ESP8266.

The installation of the Digistump boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:
>
>*Install*: [Install the Digistump platform](../../Legacy/Section4/Page5) :octicons-link-16:
>
>*Upload*: [Upload to Digistump boards](../../Legacy/Section4/#upload-to-digistump-boards) :octicons-link-16:

## embedXcode

embedXcode is a template for Xcode. It eases development for the most popular embedded computing boards.

It comes in two editions. The embedXcode standard edition focuses on core features and the embedXcode+ edition provides extended functionalities like project sharing and external debugging.

Just like embedXcode for the boards running on the Wiring / Arduino framework, embedXcode relies on the IDEs of the boards for the frameworks and tool-chains.

The features specific to each edition are listed at [Compare the editions](../Appendixes/Section1/#compare-the-editions) :octicons-link-16:.

embedXcode relies on the IDEs of the boards for the frameworks and tool-chains.

>*Related entries*: [embedXcode standard edition](../../Appendixes/Glossary/#embedxcode-standard-edition) :octicons-link-16:, [embedXcode+ edition](../../Appendixes/Glossary/#embedxcode-edition) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Xcode](../../Appendixes/Glossary/#xcode) :octicons-link-16:

## embedXcode standard edition

embedXcode is a template for Xcode. It eases development for the most popular embedded computing boards.

The embedXcode standard edition focuses on core features.

The features specific the embedXcode standard edition are listed at [Compare the editions](../Appendixes/Section1/#compare-the-editions) :octicons-link-16:.

>*Related entries*: [embedXcode](../../Appendixes/Glossary/#embedxcode) :octicons-link-16:, [embedXcode+ edition](../../Appendixes/Glossary/#embedxcode-edition) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Xcode](../../Appendixes/Glossary/#xcode) :octicons-link-16:

## embedXcode+ edition

embedXcode is a template for Xcode. It eases development for the most popular embedded computing boards.

The embedXcode+ edition provides extended functionalities like project sharing and external debugging.

The features specific the embedXcode+ edition are listed at [Compare the editions](../Appendixes/Section1/#compare-the-editions) :octicons-link-16:.

>*Related entries*: [embedXcode](../../Appendixes/Glossary/#embedxcode) :octicons-link-16:, [embedXcode standard edition](../../Appendixes/Glossary/#embedxcode-standard-edition) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Xcode](../../Appendixes/Glossary/#xcode) :octicons-link-16:

## Energia

Energia is the Arduino 1.0-based IDE for the LaunchPad boards.

Although all the LaunchPad line of boards managed by Energia include a hardware debugger, the IDE doesn't feature the corresponding application.

So embedXcode uses two external applications and tools for debugging: GDB, or GNU debugger, already included in the GCC tool-chain, and OpenOCD, or Open On-Chip Debugger.

>*Related entries*: [ArduCAM](../../Appendixes/Glossary/#arduCAM) :octicons-link-16:, [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:, [Energia MT](../../Appendixes/Glossary/#energia MT) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [LaunchPad](../../Appendixes/Glossary/#launchPad) :octicons-link-16:, [Open On- Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:, [RedBear](../../Appendixes/Glossary/#redbear) :octicons-link-16:, [XDS110 programmer-debugger](../../Appendixes/Glossary/#xds110-programmer-debugger) :octicons-link-16:

## Energia MT

Energia Multi-Tasking or Energia MT is an extension of Energia based on TI-RTOS, the real-time operating system from Texas Instruments. Energia MT runs on a selected range of boards.

The Galaxia Library provides the main RTOS elements encapsulated in easy-to-use objects.

>*Related entries*: [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [LaunchPad](../../Appendixes/Glossary/#launchPad) :octicons-link-16:

## ESP32

The ESP32 by Espressif Systems is a SoC featuring WiFi and Bluetooth.

There are many boards based on the ESP32, to be programmed using the Wiring / Arduino framework.

The installation of the ESP32 board is performed with the **Boards Manager** on the Arduino IDE with a modified file and specific libraries for WiFi and Bluetooth.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [ESP8266](../../Appendixes/Glossary/#esp8266) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the Espressif platform](../../Install/Section4/Espressif) :octicons-link-16:
>
> *Upload*: [Upload to ESP32 boards using WiFi](../../Advanced/Specific-1/#upload-to-esp32-boards-using-wifi) :octicons-link-16:
>
> *Debug*: [Install the OpenOCD driver for ESP32](../../Install/Section4/#install-the-openocd-driver-for-esp32) :octicons-link-16:, [Connect the ESP-Prog to the ESP32 board](../../Debug/Section3/#connect-the-esp-prog-to-the-esp32-board) :octicons-link-16:

## ESP8266

The ESP8266 by Espressif Systems is a SoC featuring a WiFi radio and a limited set of inputs/outputs.

There are many boards based on the ESP8266, some of them more advanced like the NodeMCU board. Although promoted for Lua, the NodeMCU board can be programmed using the Wiring / Arduino framework.

The NodeMCU boards support over-the-air upload.

The installation of the ESP8266 board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [ArduCAM](../../Appendixes/Glossary/#arduCAM) :octicons-link-16:, [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [ESP32](../../Appendixes/Glossary/#esp32) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the Espressif platform](../../Install/Section4/Espressif) :octicons-link-16:, [Install the NodeMCU platform](../../Install/Section4/#install-the-nodemcu-board) :octicons-link-16:
>
>*Upload*: [Upload to NodeMCU 1.0 board](../../Advanced/Specific-1/#upload-to-nodemcu-10-board) :octicons-link-16:, [Upload to ESP8266 NodeMCU boards using WiFi](../../Advanced/Specific-1/#upload-to-esp8266-nodemcu-boards-using-wifi) :octicons-link-16:

## File .cpp

File extension for C++ code file.

The `.cpp` C++ code file defines the classes and functions declared in a `.h` header file.

The files with `.pde` or `.ino` extensions are actually C++ code.

>*Related entries*: [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [File .h](../../Appendixes/Glossary/#file-h) :octicons-link-16:, [File .hpp](../../Appendixes/Glossary/#file-hpp) :octicons-link-16:, [File .ino](../../Appendixes/Glossary/#file-ino) :octicons-link-16:, [File .pde](../../Appendixes/Glossary/#file-pde) :octicons-link-16:, [Sketch](../../Appendixes/Glossary/#sketch) :octicons-link-16:

## File .docset

File extension for documentation set, Apple's proprietary format for Xcode help.

>*Related entries*: [File .tex](../../Appendixes/Glossary/#file-tex) :octicons-link-16:

## File .h

File extension for header file.

A header file contains the list of public constants, variables, classes and functions defined in a `.c` C or `.cpp` C++ code file.

A header file also lists the required libraries with `#include` statements.

Among other libraries, it is highly recommended to mention the core libraries. This is done using one single `#include` statement.

>*Related entries*: [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [Core libraries](../../Appendixes/Glossary/#core-libraries) :octicons-link-16:, [File .cpp](../../Appendixes/Glossary/#file-cpp) :octicons-link-16:, [File .hpp](../../Appendixes/Glossary/#file-hpp) :octicons-link-16:, [Libraries](../../Appendixes/Glossary/#libraries) :octicons-link-16:

## File .hpp

Same as `.h`, but aimed at a `.cpp` C++ code file.

The embedXcode standard edition only accepts `.h` header files.

The embedXcode+ edition accepts both `.h` and `.hpp` header files.

However, `.hpp` header files may not be compatible with standard IDEs.

>*Related entries*: [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [Core libraries](../../Appendixes/Glossary/#core-libraries) :octicons-link-16:, [File .cpp](../../Appendixes/Glossary/#file-cpp) :octicons-link-16:, [File .h](../../Appendixes/Glossary/#file-h) :octicons-link-16:, [Libraries](../../Appendixes/Glossary/#libraries) :octicons-link-16:

## File .ino

File extension for the sketch, the main part of a program.

The `.ino` extension is used by Arduino 1.0 and 1.5, Digispark, Energia and Teensy.

It replaces the `.pde` extension.

The `.pde` and `.ino` files aren't recognised as C++ code by Xcode. During the first compilation, the project is prepared by embedXcode: the files are recognised as C++ code to allow code-sense.

>*Related entries*: [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [File .cpp](../../Appendixes/Glossary/#file-cpp) :octicons-link-16:, [File .pde](../../Appendixes/Glossary/#file-pde) :octicons-link-16:, [Sketch](../../Appendixes/Glossary/#sketch) :octicons-link-16:

## File .pde

File extension for the sketch, the main part of a program.

The `.pde` extension is used by Arduino 0023, Maple and Wiring.

It has been superseded by the `.ino` extension.

The `.pde` and `.ino` files aren't recognised as C++ code by Xcode. During the first compilation, the project is prepared by embedXcode: the files are recognised as C++ code to allow code-sense.

>*Related entries*: [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [File .cpp](../../Appendixes/Glossary/#file-cpp) :octicons-link-16:, [File .ino](../../Appendixes/Glossary/#file-ino) :octicons-link-16:, [Sketch](../../Appendixes/Glossary/#sketch) :octicons-link-16:

## File .tex

File extension for LaTeX file, a language for documents with high quality formatting.

The LaTeX files are generated by Doxygen and converted into PDF documents.

>*Related entries*: [File .docset](../../Appendixes/Glossary/#file-docset) :octicons-link-16:

## Framework

The framework includes a set of libraries (including core and application libraries) that provide an hardware abstraction layer.

The libraries are invoked by the `#include` statement.

Thanks to the hardware abstraction layer, the same code can virtually run on any boards with an IDE based on that framework.

The framework for the boards is mostly written in C and C++.

The two references are Wiring and Arduino.

>*Related entries*: [Application libraries](../../Appendixes/Glossary/#application-libraries) :octicons-link-16:, [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [ARM mbed](../../Appendixes/Glossary/#arm mbed) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [Core libraries](../../Appendixes/Glossary/#core-libraries) :octicons-link-16:, [Cosa](../../Appendixes/Glossary/#cosa) :octicons-link-16:, [embedXcode](../../Appendixes/Glossary/#embedxcode) :octicons-link-16:, [embedXcode+](../../Appendixes/Glossary/#embedxcode_1) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Libraries](../../Appendixes/Glossary/#libraries) :octicons-link-16:, [MCU](../../Appendixes/Glossary/#mcu) :octicons-link-16:, [Platform](../../Appendixes/Glossary/#platform) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:, [Wiring](../../Appendixes/Glossary/#wiring) :octicons-link-16:

## Freedom

The Freedom boards feature ARM MCUs from Freescale and run the mbed SDK with the GCC tool-chain.

Support for the mbed SDK is discontinued.

>*Related entries*: [ARM mbed](../../Appendixes/Glossary/#arm mbed) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:
>
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework) :octicons-link-16:, [Install the Freedom platform](../../Legacy/Section8/#install-the-freedom-platform) :octicons-link-16:
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) :octicons-link-16:, [Upload to the Freedom K64F board](../../Legacy/Section8/#upload-to-the-freedom-k64f-board) :octicons-link-16:

## Glowdeck

The Glowdeck board can also be used as a development board. It relies on a 32-bit ARM architecture.

The Glowdeck board requires a plug-in for the Arduino IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:,
>
>*Install*: [Install the Glowdeck platform](../../Legacy/Section4/Page6) :octicons-link-16:
>
>*Upload*: [Upload to Glowdeck Board](../../Legacy/Section4/#upload-to-glowdeck-board) :octicons-link-16:

## GNU Compiler Collection

The GCC or GNU Compiler Collection is *de facto* standard for many micro-controllers. It is part of the GNU tool-chain.

A specific version is available for the ARM MCUs.

>*Related entries*: [ARM mbed](../../Appendixes/Glossary/#arm mbed) :octicons-link-16:, [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [Freedom](../../Appendixes/Glossary/#freedom) :octicons-link-16:, [GDB GNU Debugger](../../Appendixes/Glossary/#gnu-debugger) :octicons-link-16:,  [Nordic](../../Appendixes/Glossary/#nordic) :octicons-link-16:, [Nucleo](../../Appendixes/Glossary/#nucleo) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:, [Particle](../../Appendixes/Glossary/#particle) :octicons-link-16:, [Tool-Chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:

## GNU Debugger

The GDB or GNU Debugger is *de facto* standard debugging tools for many micro-controllers. It is part of the GNU tool-chain.

It is based on a client-server model. The client runs on GDB, and the server is a proprietary or open-source driver, and includes MSPDebug, Segger J-Link, ST-Link or OpenOCD.

>*Related entries*:  [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:,  [MSPDebug](../../Appendixes/Glossary/#mspdebug) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:, [Segger J-Link programmer-debugger](../../Appendixes/Glossary/#segger-j-link-programmer-debugger) :octicons-link-16:, [ST-Link](Appendixes/Glossary/#st-link-programmer-debugger) :octicons-link-16:,[Tool-Chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:

## IDE

IDE stands for integrated development environment and is an application used for developing programs.

The IDEs used for the boards are based on the Processing IDE, making them very similar.

They feature a text editor and runs on Windows, Linux or Mac OS X. They use on the Wiring and Arduino frameworks, use the C++ language and rely on different tool-chains.

They are used to develop programs to be run on different boards. Each board has its own version of the IDE, differentiated by the colours of the interface.

Another example of IDE is Xcode.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:, [embedXcode](../../Appendixes/Glossary/#embedxcode) :octicons-link-16:, [embedXcode+](../../Appendixes/Glossary/#embedxcode_1) :octicons-link-16:, [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [ESP32](../../Appendixes/Glossary/#esp32) :octicons-link-16:, [ESP8266](../../Appendixes/Glossary/#esp8266) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Glowdeck](../../Appendixes/Glossary/#glowdeck) :octicons-link-16:, [Intel](../../Appendixes/Glossary/#intel) :octicons-link-16:, [LightBlue Bean](../../Appendixes/Glossary/#lightBlue Bean) :octicons-link-16:, [Maple IDE](../../Appendixes/Glossary/#maple-ide) :octicons-link-16:, [MediaTek LinkIt](../../Appendixes/Glossary/#mediaTek LinkIt) :octicons-link-16:, [Microduino](../../Appendixes/Glossary/#microduino) :octicons-link-16:, [MPIDE](../../Appendixes/Glossary/#mpide) :octicons-link-16:, [panStamp](../../Appendixes/Glossary/#panStamp) :octicons-link-16:, [Platform](../../Appendixes/Glossary/#platform) :octicons-link-16:, [Processing](../../Appendixes/Glossary/#processing) :octicons-link-16:, [RFduino](../../Appendixes/Glossary/#rfduino) :octicons-link-16:, [Robotis OpenCM](../../Appendixes/Glossary/#robotis-opencm) :octicons-link-16:, [Seeeduino](../../Appendixes/Glossary/#seeeduino) :octicons-link-16:, [Simblee](../../Appendixes/Glossary/#simblee) :octicons-link-16:, [Teensyduino](../../Appendixes/Glossary/#teensyduino) :octicons-link-16:, [TinyCircuits](../../Appendixes/Glossary/#tinyCircuits) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:, [Udoo Neo](../../Appendixes/Glossary/#udoo-neo) :octicons-link-16:, [Wiring](../../Appendixes/Glossary/#wiring) :octicons-link-16:, [Xcode](../../Appendixes/Glossary/#xcode) :octicons-link-16:

## Intel

In June 2017, Intel announced the end of support for the Galileo and Edison boards mid-December 2017.

The Galileo and Edison boards by Intel features a 32-bit Pentium processor on an Arduino-compatible form-factor board.

The installation of the Intel boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

Contrary to other boards, the Galileo is not powered through USB.

+ First always connect the power supply to power the board.

+ Then check the Power LED is on.

+ Finally, connect the board to the computer through USB.

Powering the board directly through USB may damage the board.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the Intel platform](../../Legacy/Section4/#install-the-intel-platform) :octicons-link-16:, [Install the Yocto SDK for Intel Edison](../../Legacy/Section4/#install-the-intel-edison-for-yocto-sdk), [Install the MCU SDK for Intel Edison](../../Legacy/Section4/Page8)
>
>*Upload*: [Upload to Intel Edison Using WiFi or Ethernet over USB](../../Legacy/Section4/#upload-to-intel-edison-using-wifi-or-ethernet-over-usb) :octicons-link-16:

## Internet of Things

The Internet of Things or IoT is a network of objects.

The things are objects powered by a micro-controller and featuring sensors and actuators.

The network can be local &ndash;LAN or local area network&ndash;, or wide &ndash;WAN or wide area network, through a connection to internet&ndash; via a router.

Connection is done through Bluetooth, Bluetooth Low Energy, WiFi, Ethernet, sub-1 GHz, LoRa, among other protocols.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [ESP32](../../Appendixes/Glossary/#esp32) :octicons-link-16:, [ESP8266](../../Appendixes/Glossary/#esp8266) :octicons-link-16:, [Intel](../../Appendixes/Glossary/#intel) :octicons-link-16:, [LaunchPad](../../Appendixes/Glossary/#launchPad) :octicons-link-16:, [LightBlue Bean](../../Appendixes/Glossary/#lightblue-bean) :octicons-link-16:, [MediaTek LinkIt](../../Appendixes/Glossary/#mediaTek LinkIt) :octicons-link-16:, [Microsoft](../../Appendixes/Glossary/#microsoft) :octicons-link-16:, [Moteino](../../Appendixes/Glossary/#moteino) :octicons-link-16:, [panStamp](../../Appendixes/Glossary/#panStamp) :octicons-link-16:, [Particle](../../Appendixes/Glossary/#particle) :octicons-link-16:, [RedBear](../../Appendixes/Glossary/#redbear) :octicons-link-16:, [RFduino](../../Appendixes/Glossary/#rfduino) :octicons-link-16:, [Simblee](../../Appendixes/Glossary/#simblee) :octicons-link-16:, [Udoo Neo](../../Appendixes/Glossary/#udoo-neo) :octicons-link-16:

## LaunchPad

The LaunchPad boards are built by Texas Instruments and feature different architectures, most of them being supported by Energia:

+ 16-bit MSP430G2, MSP430F and MSP430FR,

+ 16-bit C2000,

+ 32-bit Cortex-M3 CC1310 with sub-1 GHz, CC1350 with sub-1 GHz and Bluetooth Low Energy,

+ 32-bit Cortex-M3 CC2650 with Bluetooth Low Energy,

+ 32-bit Cortex-M4 CC1312 with sub-1 GHz, CC1352 with sub-1 GHz and Bluetooth Low Energy,

+ 32-bit Cortex-M4 CC32xx with WiFi,

+ 32-bit Cortex-M4 Stellaris or Tiva C Series.

+ 32-bit Cortex-M4 MSP432.

The IDE is Energia, with the RTOS-based Energia Multi-Tasking extension for selected boards.

All the LaunchPad boards include a programmer-debugger, to be used with MSPDebug, DSLite or OpenOCD.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:, [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [Energia MT](../../Appendixes/Glossary/#energia MT) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:, [XDS110 programmer-debugger](../../Appendixes/Glossary/#xds110-programmer-debugger) :octicons-link-16:
>
>*Install*: [Install the LaunchPad platform](../../Install/Section4/LaunchPad) :octicons-link-16:
>
>*Configure*: [Set options for selected LaunchPad boards](../../Develop/Section2/#set-options-for-selected-launchpad-boards) :octicons-link-16:
>
>*Upload*: [Upload to LaunchPad C2000](../../Advanced/Specific-1/#upload-to-launchpad-c2000) :octicons-link-16:, [Upload to LaunchPad CC3200 WiFi](../../Advanced/Specific-1/#upload-to-launchpad-cc3200-wifi) :octicons-link-16:, [Upload to LaunchPad MSP430F5529 and MSP430FR5969](../../Advanced/Specific-1/#upload-to-launchpad-msp430f5529-and-msp430fr5969) :octicons-link-16:
>
>*Debug*: [Check the configuration](../../Debug/Section3/) :octicons-link-16:, [Configure the LaunchPad CC3200 WiFi](../../Debug/Section3/#configure-the-launchpad-cc3200-wifi) :octicons-link-16:

## Libraries

There are four kinds of libraries:

+ The **core libraries** include all the basic functions required for development. Each platform provides its own set compatible with the Wiring or Arduino framework.

+ The **application libraries** are optional libraries to provide additional features, like managing the specific UART, I&sup2;C and SPI ports.

+ The **user's libraries** are developed, or downloaded and installed, by the user, and stored under the `Library` sub-folder on the sketchbook folder.

+ The **local libraries** are part of the project and located on the same folder as the main sketch.

The embedXcode+ edition introduces a variant for the local libraries, the pre-compiled libraries.

+ Instead of using the source code, the **pre-compiled libraries** are already built and ready to use.

Libraries are managed with an `#include` statement on the main sketch and header files and with variables on the main `Makefile`.

>*Related entries*: [Application libraries](../../Appendixes/Glossary/#application-libraries) :octicons-link-16:, [Core libraries](../../Appendixes/Glossary/#core-libraries) :octicons-link-16:, [File .h](../../Appendixes/Glossary/#file-h) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Local libraries](../../Appendixes/Glossary/#local-libraries) :octicons-link-16:, [User's libraries](../../Appendixes/Glossary/#users-libraries) :octicons-link-16:

## LightBlue Bean

In June 2018, Punch Through Design announced it was discontinuing the Bean boards.

The LightBlue Bean by Punch Through Design combines an Atmega328P with a CC2540-based Bluetooth Low Energy radio. The board fits into a match-box.

LightBlue provides a plug-in to be installed on top of the Arduino IDE. Please refer to the relevant section for installation.

Upload and serial console are performed over-the-air through Bluetooth.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the LightBlue platform](../../Legacy/Section4/Page4) :octicons-link-16:
>
>*Upload*: [Upload to LightBlue Bean using Bluetooth](../../Legacy/Section4/#upload-to-lightblue-bean-using-bluetooth) :octicons-link-16:

## Little Robot Friends

The Little Robot Friends is a nice robot with sensors &ndash;touch, sound, light&ndash; and actuators &ndash;buzzer, LEDs. It can also be programmed.

First generation ran on an ATmega328P and required a plug-in for the Arduino IDE 1.0. The installation of the Little Robot Friends AVR board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

Second generation features an SAMD MCU. The installation of the Little Robot Friends SAMD board is performed manually but requires the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:
>
>*Install*: [Install the Little Robot Friends Platform](../../Legacy/Section4/Page10) :octicons-link-16:

## Local libraries

The local libraries are part of the project and located on the same folder as the main sketch.

They require to be explicitly mentioned with the `#include` statement on the main sketch.

By default, all the local libraries are included.

The embedXcode+ edition allows to create folders for local libraries and select them after the `USER_LIBS_LIST` variable on the main `Makefile`.

>*Related entries*: [Libraries](../../Appendixes/Glossary/#libraries) :octicons-link-16:, [Pre-compiled libraries](../../Appendixes/Glossary/#pre-compiled libraries) :octicons-link-16:

## Maple

The Maple boards are based on 32-bit ARM MCUs.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Maple IDE](../../Appendixes/Glossary/#maple-ide) :octicons-link-16:, [Microduino](../../Appendixes/Glossary/#microduino) :octicons-link-16:, [Robotis](../../Appendixes/Glossary/#robotis) :octicons-link-16:
>
>*Install*: [Install the Maple platform](../../Legacy/Section4/Page11) :octicons-link-16:

## Maple IDE

MapleIDE is the Wiring-based IDE for the Maple boards.

The MapleIDE requires special drivers.
>
>The Maple environment misses two important libraries*: `strings.h` and `stream.h`.

>*Related entries*: [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Maple](../../Appendixes/Glossary/#maple) :octicons-link-16:, [Microduino](../../Appendixes/Glossary/#microduino) :octicons-link-16:, [Robotis OpenCM](../../Appendixes/Glossary/#robotis-opencm) :octicons-link-16:

## MCU

MCU stands for micro-controller unit and includes all the parts of a computer: processing unit, read only memory or EEPROM, flash memory to store the programs and random-access memory or SRAM to store data. The MCUs are grouped in families or architectures.

It also includes general purpose inputs outputs or GPIOs. Some of them can be used for specialised buses like, among the most popular:

+ UART or universal asynchronous receiver/transmitter, most commonly serial port,

+ SPI or serial peripheral interface,

+ I&sup2;C or inter-integrated circuit,

+ TWI or two wire interface,

+ I&sup2;S or inter inter-chip sound,

+ CAN or controller area network.

Other extras may include a real-time clock, a FPU or floating-point unit, ...

>*Related entries*: [Architecture](../../Appendixes/Glossary/#architecture) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [Platform](../../Appendixes/Glossary/#platform) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:

## MediaTek LinkIt

The MediaTek LinkIt boards are dedicated to IoT.

The MediaTek LinkIt One board features WiFi, Bluetooth 2.0 and 4.0 BLE, GSM and GPRS, GPS, on an Arduino form-factor.

The MediaTek LinkIt Smart 7688 Duo has the same dual-core configuration as the Arduino Y&uacute;n board. The processor runs on Linux for WiFi and while the controller is an ATmega328 compatible with Arduino.

The MediaTek LinkIt 7697 board features WiFi, Bluetooth 2.0 and 4.0 BLE, on an compact form-factor.

The installation of the MediaTek boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the MediaTek platform](../../Legacy/Section4/Page12) :octicons-link-16:

## Microduino

The Microduino boards feature two different architectures on a highly compact form-factor.

The 8-bit ATmega architecture includes the Microduino-Core with an ATmega328P at 16 MHz and 5V, the Microduino-Core+ with an ATmega644PA at 16 MHz and 5V and the Microduino-Core USB with an ATmega32u4 at 16 MHz. Those boards run on a plug-in for the Arduino IDE.

The 32-bit architecture corresponds to the Microduino-Core STM32 board, and uses the MapleIDE as IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Maple](../../Appendixes/Glossary/#maple) :octicons-link-16:, [Maple IDE](../../Appendixes/Glossary/#maple-ide) :octicons-link-16:
>
>*Install*: [Install the Microduino platform](../../Legacy/Section4/Page13) :octicons-link-16:

## Microsoft

Microsoft has launched an IoT DevKit for its Azure cloud service.

The board combines a Cortex-M4 with WiFi and a large selection of sensors.

The installation of the Microsoft platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the Microsoft platform](../../Install/Section4/#install-the-microsoft-platform) :octicons-link-16:
>
>*Upload*: [Upload to Microsoft Azure IoT DevKit](../../Advanced/Specific-1/#upload-to-microsoft-azure-iot-devkit) :octicons-link-16:

## Moteino

The Moteino platform by LowPowerLab combines an ATMega328 with a RFM69 sub-1GHz or a RFM95 LoRa radio.

The installation of the Moteino platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

The RFM69 sub-1GHz-based board requires the RFM69 library, while the RFM95 LoRa-based board requires the LoRa library from RadioHead.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the Moteino platform](../../Install/Section4/Moteino) :octicons-link-16:

## MPIDE

MPIDE is the Arduino 0023-based IDE for the chipKIT boards. A beta release is based on Arduino 1.5.

MPIDE stands for Multi-Platform IDE and targets boards with a PIC32 MCU.

MPIDE is deprecated. Use instead the **Boards Manager** featured by Arduino.CC IDE release 1.6.5.

>*Related entries*: [4D Systems](../../Appendixes/Glossary/#4d-systems) :octicons-link-16:, [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [chipKIT](../../Appendixes/Glossary/#chipkit) :octicons-link-16:, [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:

## MSPDebug

MSPDebug is an open-source driver and runs as a server for GDB.

It is used for the LaunchPad boards based on the MSP430 MCUs from Texas Instruments. It is part of the Energia bundle and installed with Energia.

>*Related entries*: [GDB GNU Debugger](../../Appendixes/Glossary/#gnu-debugger) :octicons-link-16:

## Nordic

The Nordic boards provide an easy introduction to the internet-of-things, with Bluetooth 4.0 or BLE. The boards are based on the nRF51822 SoC, which combines a Bluetooth Low Energy radio and a Cortex-M0 MCU.

The boards run on the mbed SDK with the GCC tool-chain.

Support for the mbed SDK is discontinued.

>*Related entries*: [ARM mbed](../../Appendixes/Glossary/#arm mbed) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:
>
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework) :octicons-link-16:, [Install the Nucleo platform](../../Legacy/Section8/#install-the-nordic-platform) :octicons-link-16:
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) :octicons-link-16:

## Nucleo

The Nucleo boards feature ARM MCUs from STMicroelectronics and run the mbed SDK with the GCC tool-chain.

Support for the mbed SDK is discontinued.

The Nucleo boards are now supported by the STM32duino platform.

>*Related entries*: [ARM mbed](../../Appendixes/Glossary/#arm mbed) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:, [STM32duino](../../Appendixes/Glossary/#stm32duino) :octicons-link-16:
>
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework) :octicons-link-16:, [Install the Nucleo platform](../../Legacy/Section8/#install-the-nucleo-platform) :octicons-link-16:
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) :octicons-link-16:

## Open On-Chip Debugger

The Open On-Chip Debugger, or OpenOCD, provides tools for programming and debugging MCUs. It runs with other software like GDB from the GCC tool-chain.

It requires a hardware programmer-debugger.

>*Related entries*: [ARM mbed](../../Appendixes/Glossary/#arm mbed) :octicons-link-16:, [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [GDB GNU Debugger](../../Appendixes/Glossary/#gnu-debugger) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:

## panStamp

The panStamp platform features a sub-1 GHz radio and includes three architectures, one 8 bits, another 16 bits and the last 32 bits, each with a dedicated boards package managed by the **Boards Manager** on the Arduino 1.8 IDE.

The 8-bit architecture corresponds to the panStamp AVR with an ATmega328P at 16 MHz and 5V, while the 16-bit architecture corresponds to the panStamp NG based on the MSP430. Both the panStamp AVR and panStamp NG are discontinued. Finally, the 32-architecture corresponds to the panStamp Quantum based on the STM32L4.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the panStamp AVR platform](../../Legacy/Section4/#install-the-panstamp-avr-platform) :octicons-link-16:, [Install the panStamp NRG platform](../../Legacy/Section4/#install-the-panstamp-nrg-platform) :octicons-link-16:, [Install the panStamp Quantum platform](../../Legacy/Section4/#install-the-panstamp-quantum-platform) :octicons-link-16:
>
>*Upload*: [Upload to panStamp AVR board](../../Legacy/Section4/#upload-to-panstamp-avr-board) :octicons-link-16:, [Upload to panStamp NRG board](../../Legacy/Section4/#upload-to-panstamp-nrg-board) :octicons-link-16:, [Upload to panStamp Quantum board](../../Legacy/Section4/#upload-to-panstamp-quantum-board) :octicons-link-16:

## Particle

The Particle Core board combines an ARM STM32F103 with the CC3000 WiFi radio from Texas Instruments.

Particle provides a dedicated cloud to manage the board from anywhere in the world. A compiled sketch can be uploaded though USB connection or over-the-air using WiFi and the Particle Cloud.

Particle relies on the Wiring / Arduino framework and use the standard GCC tool-chain.

Up to now, there's only an online IDE. The offline IDE called Particle-Dev and based on Atom is currently in development.

Particle was previously Spark.

>*Related entries*: [Architecture](../../Appendixes/Glossary/#architecture) :octicons-link-16:, [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:, [Wiring](../../Appendixes/Glossary/#wiring) :octicons-link-16:
>
>*Install*: [Install the Particle platform](../../Legacy/Section4/Page15) :octicons-link-16:
>
>*Upload*: [Upload to Particle boards](../../Legacy/Section4/#upload-to-particle-boards) :octicons-link-16:

## Platform

A platform is a mix of IDE, frameworks, boards, architectures and tool-chains.

As an example, the Arduino platform includes

+ An IDE called Arduino;

+ Two frameworks, Arduino 1.0 and Arduino 1.5, the later still in beta;

+ Many different boards, which can be grouped in two architectures:

+ the 8-bit ATmega-based boards, as Arduino Uno or Arduino Mega2560,

+ and the 32-bit SAM-based Arduino Due board;

+ Two tool-chains, one for each architecture.

>*Related entries*: [Architecture](../../Appendixes/Glossary/#architecture) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [MCU](../../Appendixes/Glossary/#mcu) :octicons-link-16:, [Tool-chain](../../Appendixes/Glossary/#tool-chain) :octicons-link-16:

## Pre-compiled libraries

The embedXcode+ edition introduces a variant for the local libraries, the pre-compiled libraries.

Instead of using the source code, the pre-compiled libraries are already built and ready to use.

Just like the local libraries, they are part of the project and located on the same folder as the main sketch, they require to be explicitly mentioned by the `#include` statement on the main sketch and, they are all included by default.

A folder for a pre-compiled library, for example `LocalLibrary`, includes at least three files.

+ The file `LocalLibrary.a` is the pre-compiled library.

+ One or more `.h` files correspond to the header files.

+ The additional file `.board` gives the board or MCU the library has been compiled against.

The embedXcode+ edition checks the consistency of the pre-compiled libraries with the current target based on the file `.board`, and includes the pre-compiled libraries with extension `.a` during linking.

>*Related entries*: [Local libraries](../../Appendixes/Glossary/#local-libraries) :octicons-link-16:

## Processing

All the boards use the Processing IDE, adapted for C++.

Processing doesn't feature any board. Instead, it runs on the main computer and provides an easy interface for displaying graphs based on data acquired from the board.

>*Related entries*: [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:

## Raspberry Pi

The Raspberry Pi boards are single-board computers running on Linux. A board package is available for the Arduino IDE.

>*Related entries*: [RasPiArduino](../../Appendixes/Glossary/#raspiarduino) :octicons-link-16:

## RasPiArduino

The RasPiArduino board package brings the Wiring / Arduino SDK to the Raspberry Pi boards. Unless other boards packages, it is not managed by the Board Manager but installed instead on the `hardware` sub-folder of the Arduino sketchbook folder.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Raspberry Pi](../../Appendixes/Glossary/#raspberry-pi) :octicons-link-16:
>
>*Install*: [Install the RasPiArduino platform](../../Install/Section4/Page13) :octicons-link-16:, [Install the RasPiArduino boards package](../../Install/Section4/#install-the-raspiarduino-boards-package) :octicons-link-16:, [Install the tools and SDK on the Raspberry Pi](../../Install/Section4/#install-the-tools-and-sdk-on-the-raspberry-pi) :octicons-link-16:
>
>*Configure*: [Set options for Raspberry Pi](../../Develop/Section2/#set-options-for-raspberry-pi) :octicons-link-16:
>
>*Upload*: [Enter Raspberry Pi IP address and password](../../Develop/Section2/#enter-raspberry-pi-ip-address-and-password) :octicons-link-16:, [Upload to Raspberry Pi](../../Advanced/Specific-1/#upload-to-raspberry-pi) :octicons-link-16:
>
>*Debug*: [Connect to the Raspberry Pi](../../Debug/Section3/#connect-to-the-raspberry-pi) :octicons-link-16:

## RedBear

The RedBear &ndash;formerly RedBearLab&ndash; boards provide an easy introduction to the internet-of-things.

In March 2018, RedBear announced it was acquired by Particle. As a consequence, RedBear will terminate support for its boards on September 2019.

The boards based on the Nordic nRF51822 feature Bluetooth 4.0 or BLE. The Nordic nRF51822 SoC combines a Bluetooth Low Energy radio and a Cortex-M0 MCU. Those boards can be used with the Wiring / Arduino framework as well as with the mbed framework, both with the GCC tool-chain. The installation of the RedBear board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

The RedBear Duo board runs with the Wiring / Arduino framework and features WiFi and BLE connectivity. It requires a plug-in and a library for the Arduino 1.6.5 IDE.

The boards based on the CC3200 feature WiFi. The CC3200 from Texas Instruments combines a WiFi radio and a Cortex-M4 MCU. Those boards are supported natively by the Energia IDE.

Support for the mbed SDK is discontinued.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Energia](../../Appendixes/Glossary/#energia) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:, [arm mbed](../../Appendixes/Glossary/#arm-mbed) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:
>
>*Install*: [Install the RedBear platform for Wiring / Arduino](../../Legacy/Section4/Page16) :octicons-link-16:, [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework) :octicons-link-16:, [Install the RedBear platform for mbed](../../Legacy/Section8/#install-the-redbear-platform-for-mbed) :octicons-link-16:
>
>*Upload*: [Upload to RedBear CC3200 Boards](../../Legacy/Section4/#upload-to-redbear-cc3200-boards) :octicons-link-16:, [Upload to RedBear Duo Board](../../Legacy/Section4/#upload-to-redbear-duo-board) :octicons-link-16:, [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) :octicons-link-16:, [Restore Arduino mode on RedBear boards](../../Legacy/Section4/#restore-arduino-mode-on-redbear-boards) :octicons-link-16:

## RFduino

RFduino combines a Cortex-M0 MCU with Bluetooth Low Energy on a compact board.

RFduino requires a plug-in for the Arduino IDE 1.5.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:, [Simblee](../../Appendixes/Glossary/#simblee) :octicons-link-16:
>
>*Install*: [Install the RFduino platform](../../Legacy/Section4/Page17) :octicons-link-16:

## Robotis

The Robotis OpenCM9.04 board is based on the 32-bit ARM MCU.

The Robotis OpenCM is the dedicated IDE.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Maple](../../Appendixes/Glossary/#maple) :octicons-link-16:, [Robotis OpenCM](../../Appendixes/Glossary/#robotis-opencm) :octicons-link-16:,
>
>*Install*: [Install the Robotis platform](../../Legacy/Section4/Page18) :octicons-link-16:
>
>*Upload*: [Upload to Robotis OpenCM9.04 Board](../../Legacy/Section5/#upload-to-robotis-opencm904-board) :octicons-link-16:

## Robotis OpenCM

The Robotis OpenCM is the Wiring-based IDE for the Robotis boards.

The Robotis OpenCM requires special drivers.
>
>The Robotis environment misses two important libraries*: `strings.h` and `stream.h`.

>*Related entries*: [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Maple IDE](../../Appendixes/Glossary/#maple-ide) :octicons-link-16:, [Robotis](../../Appendixes/Glossary/#robotis) :octicons-link-16:, [Wiring](../../Appendixes/Glossary/#wiring) :octicons-link-16:

## Seeeduino

Seeed Studio is a hardware manufacturer, especially known for its Grove system.

The Seeeduino boards are based on the ATmega 328 or the SAMD compatible with the Arduino Uno and Arduino Zero, or on the Cortex-M SAMD. The Wio Terminal features two MCUs: a general Cortex-M4F SAMD51 and a network-processor RTL8720DN.

The installation of the Seeeduino board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:
>
>*Install*: [Install the Seeeduino AVR platform](../../Install/Section4/#install-the-seeeduino-avr-platform) :octicons-link-16:, [Install the Seeeduino SAMD platform](../../Install/Section4/#install-the-seeeduino-samd-platform) :octicons-link-16:, [Install the Ameba RTL8720DN platform for the Wio Terminal board](../../Install/Section4/#install-the-ameba-rtl8720dn-platform-for-the-wio-terminal-board) :octicons-link-16:
>
>*Upload*: [Upload to Seeeduino SAMD boards](../../Advanced/Specific-1/#upload-to-seeeduino-samd-boards) :octicons-link-16:, [Upload to the RTL8720DN MCU of the Wio Terminal](../../Advanced/Specific-1/#upload-to-the-rtl8720dn-mcu-of-the-wio-terminal-board) :octicons-link-16:, [Reflash the RTL8720DN MCU as a network-processor for the Wio Terminal board](../../Advanced/Specific-2/#reflash-the-rtl8720dn-mcu-as-a-network-processor-for-the-wio-terminal-board) :octicons-link-16:
>
>*Debug*: [Connect the Segger J-Link to the Seeeduino Xiao M0](../../Debug/Section3/#connect-the-segger-j-link-to-the-seeeduino-xiao-m0) :octicons-link-16:

## Segger J-Link programmer-debugger

Segger programmers-debuggers are the *de facto* standard for Cortex-M. The wide range of models includes the J-Link Edu and the J-Link Edu mini.

Segger provides two sets of tools: command-line J-Link and GUI-based Ozone.

>*Related entries*: [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:
>
>*Install*: [Install utilities for Segger debugger](../../Install/Section4/#install-utilities-for-segger-debugger) :octicons-link-16:, [Install the Segger J-Link Software Suite](../../Install/Section4/#install-the-segger-j-link-software-suite) :octicons-link-16:, [Install the Segger Ozone Graphical Debugger](../../Install/Section4/#install-the-segger-ozone-graphical-debugger) :octicons-link-16:.
>
>*Debug*: [Debug the boards with Ozone](../../Debug/Section4/#debug-the-boards-with-ozone) :octicons-link-16:, [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb) :octicons-link-16:

## Simblee

Simblee is an updated version of the RFduino board.

It combines a Cortex-M0 MCU with Bluetooth Low Energy on a compact board.

The installation of the Simblee board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:, [RFduino](../../Appendixes/Glossary/#rfduino) :octicons-link-16:
>
>*Install*: [Install the Simblee platform](../../Legacy/Section4/Page19) :octicons-link-16:

## Sketch

A sketch is basically a program written in C++ and based on the Wiring and Arduino framework.

The valid file extensions for a sketch are `.pde` or `.ino`.

>*Related entries*: [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [File .cpp](../../Appendixes/Glossary/#file-cpp) :octicons-link-16:, [File .ino](../../Appendixes/Glossary/#file-ino) :octicons-link-16:, [File .pde](../../Appendixes/Glossary/#file-pde) :octicons-link-16:,

## STM32duino

The STM32duino platform provides an easy solution for the Nucleo and Discovery boards based on the STM32 MCUs.

The initial project STM32duino has been renamed Arduino STM32. The new STM32duino project is maintained by STMicroelectronics.

The installation of the Arduino STM32 platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Arduino STM32](../../Appendixes/Glossary/#arduino-stm32) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [MapleIDE](../../Appendixes/Glossary/#mapleIDE) :octicons-link-16:
>
>*Install*: [Install the STM32duino platform](../../Install/Section4/#install-the-stm32duino-platform) :octicons-link-16:
>
>*Debug*: [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb) :octicons-link-16:

## Arduino STM32

Previously named STM32duino, the Arduino STM32 project provides support for boards based on the STM32F1xx, STM32F3xx and STM32F4xx MCUs.

The installation of the Arduino STM32 platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

It is now superseded by the new STM32duino project maintained by STMicroelectronics.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [MapleIDE](../../Appendixes/Glossary/#mapleIDE) :octicons-link-16:, [STM32duino](../../Appendixes/Glossary/#stm32duino) :octicons-link-16:
>
>*Install*: [Install the Arduino STM32 platform](../../Legacy/Section4/#install-the-arduino-stm32-platform) :octicons-link-16:, [Install the STM32duino platform](../../Install/Section4/#install-the-stm32duino-platform) :octicons-link-16:

## ST-Link programmer-debugger

The ST-Link programmer-debugger is specific to STMicroelectronics boards. It includes the hardware programmer-debugger and the software driver compatible with GDB.

Although STMicroelectronics recommends [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html) :octicons-link-external-16:, which includes ST-Link but requires Java, embedXcode relies on Texane ST-Link, an open-source and native version of the STMicroelectronics ST-Link tools.

>*Related entries*: [GDB GNU Debugger](../../Appendixes/Glossary/#gnu-debugger) :octicons-link-16:,  [STM32duino](../../Appendixes/Glossary/#stm32duino) :octicons-link-16:
>
>*Install*: [Install the STM32duino platform](../../Install/Section4/#install-the-stm32duino-platform) :octicons-link-16:
>
>*Debug*: [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb) :octicons-link-16:

## Teensy

Teensy includes two major architectures:

+ 8-bit ATmega for Teensy 2 and

+ 32-bit ARM for Teensy 3.

The Teensy boards require Teensyduino, a plug-in for the Arduino IDE.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Teensyduino](../../Appendixes/Glossary/#teensyduino) :octicons-link-16:
>
>*Install*: [Install the Teensy platform](../../Install/Section4/Teensy) :octicons-link-16:
>
>*Configure*: [Set options for Teensy](../../Develop/Section2/#set-options-for-teensy) :octicons-link-16:
>
>*Upload*: [Upload to Teensy 3.0 and 3.1 Boards](../../Advanced/Specific-1/#upload-to-teensy-boards) :octicons-link-16:

## Teensyduino

Teensyduino is the Arduino 1.8 IDE-compatible plug-in for the Teensy boards.

Please refer to the relevant section for installation to avoid possible conflicts with the Arduino 1.8 IDE.

>*Related entries*: [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Teensy](../../Appendixes/Glossary/#teensy) :octicons-link-16:
>
>*Install*: [Install the Teensy platform](../../Install/Section4/Teensy) :octicons-link-16:

## TinyCircuits

TinyCircuits specialises in very compact circuits. The TinyScreen+ embeds a Cortex-M0 with an OLED display.

The installation of the TinyScreen+ board is performed with the **Boards Manager** and the Lbirary Manager on the Arduino 1.6 IDE.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:
>
>*Install*: [Install the TinyCircuits platform](../../Legacy/Section4/Page21) :octicons-link-16:
>
>*Upload*: [Upload to TinyScreen+ board](../../Legacy/Section4/#upload-to-tinyscreen-board) :octicons-link-16:

## Tool-chain

A tool-chain is a set of tools used to build, link, upload and debug a sketch to a board.

The tools from the tool-chain are called by the IDE.

The MCUs are grouped by architectures and each architecture has its specific tool-chain.

Most of the tool-chains used with the embedded computing boards are based on GCC, or GNU Compiler Collection, with GDB, or GNU Debugger, as programmer-debugger.

Other tools include programmers and debuggers, like OpenOCD, or Open On-Chip Debugger.

>*Related entries*: [Architecture](../../Appendixes/Glossary/#architecture) :octicons-link-16:, [C++ language](../../Appendixes/Glossary/#c-language) :octicons-link-16:, [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [GDB GNU Debugger](../../Appendixes/Glossary/#gnu-debugger) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [MCU](../../Appendixes/Glossary/#mcu) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:, [Particle](../../Appendixes/Glossary/#particle) :octicons-link-16:, [Platform](../../Appendixes/Glossary/#platform) :octicons-link-16:

## Udoo Neo

The Udoo Neo is a board featuring a Freescale i.MX 6SoloX processor from Freescale. The processor is dual core with a Cortex-A9 MPU running on Linux and a Cortex-M4 MCU for real-time GPIO.

The MCU supports the Wiring / Arduino framework. Installation relies on the **Boards Manager** featured by Arduino.CC IDE release 1.6.5.

>*Related entries*: [Arduino](../../Appendixes/Glossary/#arduino) :octicons-link-16:, [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Internet of Things](../../Appendixes/Glossary/#internet-of-things) :octicons-link-16:
>
>*Install*: [Install the Udoo Neo Platform](../../Legacy/Section4/Page22) :octicons-link-16:
>
>*Upload*: [Upload to Udoo Neo board](../../Legacy/Section4/#upload-to-udoo-neo-board) :octicons-link-16:

## User's libraries

The local libraries are part of the project and located on the same folder as the main sketch.

By default, no user's library is included.

They require to be

+ explicitly mentioned with the `#include` statement on the main sketch,

+ and listed on the main `Makefile` after the and listed on the main `Makefile` after the `USER_LIBS_LIST` variable.

The embedXcode+ edition lists all the user's libraries for the selected platform on the main `Makefile`.

>*Related entries*: [Libraries](../../Appendixes/Glossary/#libraries) :octicons-link-16:

## Wiring

Wiring focuses on defining the framework.

Some boards are especially designed for Wiring, as the ATmega64-based Wiring S.

>*Related entries*: [Boards](../../Appendixes/Glossary/#boards) :octicons-link-16:, [Framework](../../Appendixes/Glossary/#framework) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:, [Particle](../../Appendixes/Glossary/#particle) :octicons-link-16:, [Robotis OpenCM](../../Appendixes/Glossary/#robotis-opencm) :octicons-link-16:
>
>*Install*: [Install the Wiring platform](../../Legacy/Section4/Page23) :octicons-link-16:

## Xcode

Xcode is the official IDE from Apple.

Xcode versions 9 and 10 are recommended for embedXcode.

For previous versions, consider the legacy releases of embedXcode.

>*Related entries:* [embedXcode](../../Appendixes/Glossary/#embedxcode) :octicons-link-16:, [embedXcode+](../../Appendixes/Glossary/#embedxcode_1) :octicons-link-16:, [IDE](../../Appendixes/Glossary/#ide) :octicons-link-16:,

## XDS110 programmer-debugger

The XDS110 programmer-debugger is specific to Texas Instruments LaunchPad boards.

Most of the boards from the SimpleLink portfolio, including the MSP432, CC32xx, CC26xx and CC13xx LaunchPad boards, feature the XDS110 programmer-debugger.

Although the default programmer is **DSLite**, the XDS110 accepts the open-source **OpenOCD** or Open On-Chip Debugger utility. **OpenOCD** brings additional features, like selecting one board among multiple connected, as well as debugging, acting as a server for the GDB client, part of the GNU tool-chain.

>*Related entries:* [Debugger](../../Appendixes/Glossary/#debugger) :octicons-link-16:, [LaunchPad](../../Appendixes/Glossary/#launchpad) :octicons-link-16:, [GCC GNU Compiler Collection](../../Appendixes/Glossary/#gnu-compiler-collection) :octicons-link-16:, [OpenOCD Open On-Chip Debugger](../../Appendixes/Glossary/#open-on-chip-debugger) :octicons-link-16:
>
>*Install*: [Install debug tools for the LaunchPad boards](../../Install/Section4/#install-debug-tools-for-the-launchpad-boards) :octicons-link-16:, [Install the OpenOCD driver](../../Install/Section4/#install-the-openocd-driver) :octicons-link-16:
>
>*Upload*: [Select among multiple boards connected through XDS110](../../Chapter4/Section4/#select-among-multiple-boards-connected-through-xds110) :octicons-link-16:, [Upload to LaunchPad boards with XDS110](../../Advanced/Specific-1/#upload-to-launchpad-boards-with-xds110) :octicons-link-16:
>
>*Debug*: [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb) :octicons-link-16:

## Visit the official websites

