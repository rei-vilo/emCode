# Glossary

The glossary provides a short definition of the most common terms, and provides links to the related entries.

## 4D Systems

The 4D Systems boards combine a colour touch screen with a controller.

+ The IoD boards are powered by an ESP8266 MCU, They rely on the ESP8266 boards package for the Arduino IDE with a modified file and the specific TFT display library.

+ The PICadillo-35T board combines a PIC32 MCU with a 480x320 TFT screen. The IDE used to be MPIDE with additional files and the specific TFT display library. As MPIDE is deprecated, the board is supported by the Arduino IDE with the chipKIT boards package.

>*Related entries*: [Arduino](#arduino), [Boards](#boards),  [chipKIT](#chipkit), [MPIDE](#mpide)

## Adafruit

Adafruit offers a large range of highly-compact boards based on the ATtiny85x and the ATmega328P.

The installation of the Adafruit boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards)
>
>*Install*: [Install the Adafruit platform](../../Install/Section4/Adafruit)
>
>*Upload*: [Upload to Adafruit Trinket and Pro Trinket boards](../../Boards/Adafruit/AVR/#upload), [Upload to Feather nRF52](../../Boards/Adafruit/nRF52/#upload), [Upload to Feather M0 and M4 boards](../../Boards/Adafruit/Cortex-M/#upload)
>
>*Debug*: [Debug Feather nRF52](../../Boards/Adafruit/nRF52/#debug), [Debug Feather M0 and M4](../../Boards/Adafruit/Cortex-M/#debug)

## Application libraries

The application libraries are optional libraries to provide additional features, like managing the specific I&sup2;C and SPI ports.

They are defined by each of the IDEs.

By default, no application library is included.

They require to be explicitly mentioned with the `#include` statement on the main sketch and listed on the main `Makefile` after the `APP_LIBS_LIST` variable.

The embedXcode+ edition lists all the application libraries for the selected platform on the main `Makefile`.

>*Related entries*: [Framework](#framework), [Libraries](#libraries)

## Architecture

The MCUs are grouped in families or architectures.

As example, one characteristic of the architectures is the number of bits used to process data. It could be

+ 8-bit for the ATtiny and ATmega,

+ 16-bit for the MSP430

+ or 32-bit for the ARM.

Other characteristics include the structure of the hardware and the instruction set.

Each architecture requires its dedicated tool-chain.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [MCU](#mcu), [Particle](#particle), [Platform](#platform), [Tool-chain](#tool-chain)

## ArduCAM

ArduCAM specialises in cameras and offers two boards with WiFi and an Arduino form-factor.

The ArduCAM CC3200 is based on the CC3200 and runs on Energia.

The ArduCAM ESP8266 is based on ESP8266 and runs on Arduino 1.6 IDE. The installation is performed with the **Boards Manager**.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [Energia](#energia), [ESP8266](#esp8266)
<!-- >
>*Install*: [Install the ArduCAM platform](../../Legacy/Section4/Page1)
>
>*Upload*: [Upload to ArduCAM CC3200 Board](../../Legacy/Section4/#upload-to-arducam-cc3200-board) -->

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

>*Related entries*: [4D Systems](#4d-systems), [Adafruit](#adafruit), [Architecture](#architecture), [ArduCAM](#arduCAM), [ARM mbed](#arm-mbed), [ATTinyCore](#attinycore), [Boards](#boards), [DFRobot](#dFRobot), [ESP32](#esp32), [ESP8266](#esp8266), [Framework](#framework), [Glowdeck](#glowdeck), [IDE](#ide), [Intel](#intel), [Internet of Things](#internet-of-things), [LightBlue Bean](#lightblue-bean), [Little Robot Friends](#little-robot-friends), [MediaTek LinkIt](#mediatek-linkit), [Microduino](#microduino), [Microsoft](#microsoft), [Moteino](#moteino), [MPIDE](#mpide), [panStamp](#panstamp), [Particle](#particle), [RedBear](#redbear), [RFduino](#rfduino), [Seeeduino](#seeeduino), [Simblee](#simblee), [TinyCircuits](#tinyCircuits), [Udoo Neo](#udoo-neo)
>
>*Install*: [Install the Arduino platform](../../Install/Section4/Arduino)
>
>*Upload*: [Upload to Arduino Leonardo](../../Advanced/Specific-1/#upload-to-arduino-leonardo), [Upload to Arduino Y&uacute;n using Ethernet or WiFi](../../Advanced/Specific-1/#upload-to-arduino-yn-using-ethernet-or-wifi), [Upload to Arduino M0 Pro](../../Advanced/Specific-1/#upload-to-arduino-m0-pro), [Upload to Arduino Zero](../../Advanced/Specific-1/#upload-to-arduino-zero)
>
>*Debug*: [Check the configuration](../../Debug/Section3/), [Connect the Segger J-Link to the Arduino Due](../../Debug/Section3/#connect-the-segger-j-link-to-the-arduino-due), [Select the USB Port for the Arduino M0 Pro](../../Debug/Section3/#select-the-usb-port-for-the-arduino-m0-pro)

## ARM mbed

The ARM mbed framework is designed for the ARM MCUs.

It includes a hardware abstraction layer and runs on a large range of boards based on Cortex-M0, M3 and M4 MCUs. It also features a real time operating system, or RTOS.

Up to now, mbed was available solely online. It can now be downloaded and used off line with standard tools as the GCC tool-chain and the OpenOCD debugger.

Most of the high level libraries of ARM mbed are written in C++. The mbed SDK has gone through major updates, first with Mbed-OS 3.0 and now Mbed-OS 5.0

Support for the mbed SDK is discontinued.

The Mbed-OS is also used as an underlying SDK for the Arduino framework, for example for the Nano 33 BLE boards.

The Nucleo boards are now supported by the STM32duino platform.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [C++ language](#c-language), [Framework](#framework), [Freedom](#freedom), [GCC GNU Compiler Collection](#gnu-compiler-collection), [Nordic](#nordic), [Nucleo](#nucleo), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger), [RedBear](#redbear),  [STM32duino](#stm32duino)
<!-- >
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework)
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) -->

## ATtinyCore

The ATtinyCore supports the ATtiny MCUs.

The installation of the ATtinyCore boards is  performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards)
>
>*Install*: [Install the ATtinyCore platform](../../Install/Section4/#install-the-attinycore-platform)

## BBC micro:bit

The BBC micro:bit is built around the Nordic nRF51 with a Bluetooth radio. It also features a hardware debugger.

>*Related entries*: [Boards](#boards), [Debugger](#debugger)
>
>*Install*: [Install the BBC micro:bit board](../../Install/Section4/Page10)
>
>*Upload*: [Reset the BBC micro:bit board to factory default](../../Advanced/Specific-2/#reset-the-bbc-microbit-board-to-factory-default)

## BeagleBone

The BeagleBone is a board featuring a Cortex-A8 AM3358 processor from Texas Instruments and running on Linux. The recommended Linux distribution is Debian.

Support for the BeagleBone board has been discontinued since embedXcode release 5.0.

>*Related entries*: [Boards](#boards)
<!-- >
>*Install*: [Install the BeagleBone board](../../Legacy/Section7/#install-the-beaglebone-board)
>
>*Upload*: [Upload to BeagleBone board](../../Legacy/Section7/#upload-to-beaglebone-board) -->

## Boards

A board is hardware defined by its MCU.

For example, the LaunchPad Stellaris is based on the ARM Cortex-M4 LM4F120H5QR MCU.

All the embedded computing boards use a Processing-based Wiring-derived Arduino- like IDE or run on the mbed platform.

For the Wiring / Arduino framework, the boards share the same Processing-based IDE, use the same Wiring-derived framework and bring the same Arduino-like programming with sketches written in C++.

The IDE includes the tool-chain specific to the boards.

For the mbed framework, the boards feature an ARM Cortex-M0, -M0+, M3 or M4, use the same mbed SDK on the GCC tool-chain.

>*Related entries*: [4D Systems](#4d-systems), [Adafruit](#adafruit), [Architecture](#architecture), [ArduCAM](#arduCAM), [Arduino](#arduino), [ARM mbed](#arm-mbed), [ATTinyCore](#attinycore), [BBC micro:bit](#bbc-microbit), [BeagleBone](#beagleBone), [C++ language](#c-language), [chipKIT](#chipkit), [DFRobot](#dFRobot), [Digistump](#digistump), [ESP32](#esp32), [ESP8266](#esp8266), [Framework](#framework), [Freedom](#freedom), [Glowdeck](#glowdeck), [IDE](#ide), [Intel](#intel), [LaunchPad](#launchpad), [LightBlue Bean](#lightBlue-Bean), [Little Robot Friends](#little-robot-friends), [Maple](#maple), [MCU](#mcu), [MediaTek LinkIt](#mediatek-linkit), [Microduino](#microduino), [Microsoft](#microsoft), [Moteino](#moteino), [Nordic](#nordic), [Nucleo](#nucleo), [panStamp](#panstamp), [Particle](#particle), [Platform](#platform), [RedBear](#redbear), [RFduino](#rfduino), [Robotis](#robotis), [Seeeduino](#seeeduino), [Simblee](#simblee), [Teensy](#teensy), [TinyCircuits](#tinyCircuits), [Udoo Neo](#udoo-neo), [Wiring](#wiring)

## C++ language

The C++ is a programming language based on the C language. It features object-oriented features like classes.

It is used for programming the embedded computing boards.

>*Related entries*: [ARM mbed](#arm mbed), [Boards](#boards), [File `.cpp`](#file-cpp), [File `.h`](#file-h), [File `.hpp`](#file-hpp), [File `.ino`](#file-ino), [File `.pde`](#file-pde), [Framework](#framework), [IDE](#ide), [Sketch](#sketch), [Tool-Chain](#tool-chain)

## chipKIT

chipKIT uses the PIC32 MCUs.

The IDE used to be MPIDE. The installation of the chipKIT board is now performed with the **Boards Manager** on the Arduino 1.8 IDE.

An optional chipKIT PGM provides an external programmer-debugger to the chipKIT boards.

>*Related entries*: [4D Systems](#4d-systems), [Boards](#boards), [Debugger](#debugger), [MPIDE](#mpide)
<!-- >
>*Install*: [Install the chipKIT platform](../../Legacy/Section4/Page2)
>
>*Upload*: [Upload to chipKIT boards using a programmer-debugger](../../Legacy/Section4/#upload-to-chipkit-boards-using-a-programmer-debugger)
>
> *Debug*: [Debug the chipKIT boards with MDB](../../Legacy/Section4/#debug-the-chipkit-boards-with-mdb) -->

## Core libraries

The core libraries include all the basic functions required for development.

Each platform provides its own set compatible with the Wiring and Arduino framework.

All the core libraries are included for compilation using one single `#include` statement on the main sketch. The same `#include` statement is also required on the header files.

This is done with

+ the `#include "Arduino.h"` statement for the Arduino, Energia, Microduino and Teensy platforms,

+ the `#include "Wiring.h"` for the call , while Wiring platform, and

+ the `#include "WProgram.h"` for the chipKIT MPIDE and Maple IDE platforms.

>*Related entries*: [File `.h`](#file-h), [Framework](#framework), [Libraries](#libraries)

## Cosa

Cosa is an object-oriented framework compatible with Arduino for the AVR-based boards.

The installation of the Cosa framework is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Framework](#framework)
<!-- >
>*Install*: [Install the Cosa framework](../../Legacy/Section6/#install-the-cosa-framework) -->

## Debugger

Debugging allows to execute a program one line at a time, check and change the values of the variables, trace the calls of functions, ... It consists on a combination of hardware and software.

There are two ways of debugging:

+ **Software debugging**, most of the time performed by injecting code like the basic `printf("i=%d\n", i)` or `Serial.println(i, DEC);`.

+ **Hardware debugging**, with a specific chip called a debugger or emulator along the MCU being debugged, and dedicated external applications.

Some boards, like the LaunchPad boards by Texas Instruments and the Nucleo boards by STMicroelectronics, include a built-in hardware debugger.

To use the hardware debugger, two external applications are required, based on a client-server model: a client connects to a server. The most widely used client is GDB. The server is a proprietary or open-source driver, and includes MSPDebug, Segger J-Link, ST-Link or OpenOCD.

The chipKIT PGM provides an external programmer-debugger to the chipKIT boards.

>*Related entries*: [BBC micro:bit](#bbc-microbit), [chipKIT](#chipkit), [Energia](#energia), [IDE](#ide), [LaunchPad](#launchpad), [GDB GNU Debugger](#gnu-debugger),  [MPIDE](#mpide), [MSPDebug](#mspdebug), [Segger J-Link programmer-debugger](#segger-j-link-programmer-debugger), [Tool-chain](#tool-chain), [XDS110 programmer-debugger](#xds110-programmer-debugger)

## DFRobot

The BLuno and Wido boards from DFRobot provide an easy introduction to the internet-of-things.

The BLuno board integrates Bluetooth 4.0 or BLE into a standard Arduino Uno board and the Wido board integrates WiFi into a standard Arduino Leonardo board.

The BLuno board is considered as a standard Arduino Uno board and the Wido board as a standard Arduino Leonardo board, so no specific plug-in is required.

>*Related entries*: [Arduino](#arduino), [Boards](#boards)
>
>*Install*: [Install the DFRobot platform](../../Install/Section4/#install-the-dfrobot-platform)

## Digistump

The Digistump platform offers different boards.

+ The Digispark is based on the ATtiny85 and requires a specific upload procedure.

+ The DigiX is compatible with the Arduino Due.

The coming Oak is based on the popular ESP8266.

The installation of the Digistump boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Boards](#boards)
<!-- >
>*Install*: [Install the Digistump platform](../../Legacy/Section4/Page5)
>
>*Upload*: [Upload to Digistump boards](../../Legacy/Section4/#upload-to-digistump-boards) -->

## embedXcode

embedXcode is deprecated and replaced by emCode.

embedXcode is a template for Xcode. It eases development for the most popular embedded computing boards.

It comes in two editions. The embedXcode standard edition focuses on core features and the embedXcode+ edition provides extended functionalities like project sharing and external debugging.

Just like embedXcode for the boards running on the Wiring / Arduino framework, embedXcode relies on the IDEs of the boards for the frameworks and tool-chains.

The features specific to each edition are listed at [Compare the editions](../Appendixes/Section1/#compare-the-editions).

embedXcode relies on the IDEs of the boards for the frameworks and tool-chains.

>*Related entries*: [embedXcode standard edition](#embedxcode-standard-edition), [embedXcode+ edition](#embedxcode-edition), [emCode](#emcode), [Framework](#framework), [IDE](#ide), [Visual Studio Code](#visual-studio-code), [Xcode](#xcode)

## embedXcode standard edition

embedXcode is deprecated and replaced by emCode.

embedXcode is a template for Xcode. It eases development for the most popular embedded computing boards.

The embedXcode standard edition focuses on core features.

The features specific the embedXcode standard edition are listed at [Compare the editions](../Appendixes/Section1/#compare-the-editions).

>*Related entries*: [embedXcode](#embedxcode), [embedXcode+ edition](#embedxcode-edition), [emCode](#emcode), [Framework](#framework), [IDE](#ide), [Visual Studio Code](#visual-studio-code), [Xcode](#xcode)

## embedXcode+ edition

embedXcode is deprecated and replaced by emCode.

embedXcode is a template for Xcode. It eases development for the most popular embedded computing boards.

The embedXcode+ edition provides extended functionalities like project sharing and external debugging.

The features specific the embedXcode+ edition are listed at [Compare the editions](../Appendixes/Section1/#compare-the-editions).

>*Related entries*: [embedXcode](#embedxcode), [embedXcode standard edition](#embedxcode-standard-edition), [emCode](#emcode), [Framework](#framework), [IDE](#ide), [Visual Studio Code](#visual-studio-code), [Xcode](#xcode)

## emCode

emCode is a set of tools to ease development for the most popular embedded computing boards.

emCode still relies on the Arduino SDK but no longer targets Apple hardware and software. Instead, it is designed to be used with the excellent Visual Studio Code IDE on Linux or Windows Linux Sub-system (WSL).

>*Related entries*: [IDE](#ide), [Visual Studio Code](#visual-studio-code)
>
>*Install*: [Install emCode](../Install/index.md)

## Energia

Energia is the Arduino 1.0-based IDE for the LaunchPad boards.

Although all the LaunchPad line of boards managed by Energia include a hardware debugger, the IDE doesn't feature the corresponding application.

So embedXcode uses two external applications and tools for debugging: GDB, or GNU debugger, already included in the GCC tool-chain, and OpenOCD, or Open On-Chip Debugger.

>*Related entries*: [ArduCAM](#arduCAM), [Debugger](#debugger), [Energia MT](#energia MT), [GCC GNU Compiler Collection](#gnu-compiler-collection), [IDE](#ide), [LaunchPad](#launchpad), [Open On- Chip Debugger](#open-on-chip-debugger), [RedBear](#redbear), [XDS110 programmer-debugger](#xds110-programmer-debugger)

## Energia MT

Energia Multi-Tasking or Energia MT is an extension of Energia based on TI-RTOS, the real-time operating system from Texas Instruments. Energia MT runs on a selected range of boards.

The Galaxia Library provides the main RTOS elements encapsulated in easy-to-use objects.

>*Related entries*: [Energia](#energia), [LaunchPad](#launchpad)

## ESP32

The ESP32 by Espressif Systems is a SoC featuring WiFi and Bluetooth.

There are many boards based on the ESP32, to be programmed using the Wiring / Arduino framework.

The installation of the ESP32 board is performed with the **Boards Manager** on the Arduino IDE with a modified file and specific libraries for WiFi and Bluetooth.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [ESP8266](#esp8266), [IDE](#ide), [Internet of Things](#internet-of-things)
>
>*Install*: [Install the Espressif platform](../../Install/Section4/Espressif)
>
> *Upload*: [Upload to ESP32 boards using WiFi](../../Advanced/Specific-1/#upload-to-esp32-boards-using-wifi)
>
> *Debug*: [Install the OpenOCD driver for ESP32](../../Install/Section4/#install-the-openocd-driver-for-esp32), [Connect the ESP-Prog to the ESP32 board](../../Debug/Section3/#connect-the-esp-prog-to-the-esp32-board)

## ESP8266

The ESP8266 by Espressif Systems is a SoC featuring a WiFi radio and a limited set of inputs/outputs.

There are many boards based on the ESP8266, some of them more advanced like the NodeMCU board. Although promoted for Lua, the NodeMCU board can be programmed using the Wiring / Arduino framework.

The NodeMCU boards support over-the-air upload.

The installation of the ESP8266 board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [ArduCAM](#arduCAM), [Arduino](#arduino), [Boards](#boards), [ESP32](#esp32), [IDE](#ide), [Internet of Things](#internet-of-things)
>
>*Install*: [Install the Espressif platform](../../Install/Section4/Espressif), [Install the NodeMCU platform](../../Install/Section4/#install-the-nodemcu-board)
>
>*Upload*: [Upload to NodeMCU 1.0 board](../../Advanced/Specific-1/#upload-to-nodemcu-10-board), [Upload to ESP8266 NodeMCU boards using WiFi](../../Advanced/Specific-1/#upload-to-esp8266-nodemcu-boards-using-wifi)

## File `.cpp`

File extension for C++ code file.

The `.cpp` C++ code file defines the classes and functions declared in a `.h` header file.

The files with `.pde` or `.ino` extensions are actually C++ code.

>*Related entries*: [C++ language](#c-language), [File `.h`](#file-h), [File `.hpp`](#file-hpp), [File `.ino`](#file-ino), [File `.pde`](#file-pde), [Sketch](#sketch)

## File `.docset`

File extension for documentation set, Apple's proprietary format for Xcode help.

>*Related entries*: [File `.tex`](#file-tex)

## File `.h`

File extension for header file.

A header file contains the list of public constants, variables, classes and functions defined in a `.c` C or `.cpp` C++ code file.

A header file also lists the required libraries with `#include` statements.

Among other libraries, it is highly recommended to mention the core libraries. This is done using one single `#include` statement.

>*Related entries*: [C++ language](#c-language), [Core libraries](#core-libraries), [File `.cpp`](#file-cpp), [File `.hpp`](#file-hpp), [Libraries](#libraries)

## File `.hpp`

Same as `.h`, but aimed at a `.cpp` C++ code file.

The embedXcode standard edition only accepts `.h` header files.

The embedXcode+ edition accepts both `.h` and `.hpp` header files.

However, `.hpp` header files may not be compatible with standard IDEs.

>*Related entries*: [C++ language](#c-language), [Core libraries](#core-libraries), [File `.cpp`](#file-cpp), [File `.h`](#file-h), [Libraries](#libraries)

## File `.ino`

File extension for the sketch, the main part of a program.

The `.ino` extension is used by Arduino 1.0 and 1.5, Digispark, Energia and Teensy.

It replaces the `.pde` extension.

The `.pde` and `.ino` files aren't recognised as C++ code by Xcode. During the first compilation, the project is prepared by embedXcode: the files are recognised as C++ code to allow code-sense.

>*Related entries*: [C++ language](#c-language), [File `.cpp`](#file-cpp), [File `.pde`](#file-pde), [Sketch](#sketch)

## File `.pde`

File extension for the sketch, the main part of a program.

The `.pde` extension is used by Arduino 0023, Maple and Wiring.

It has been superseded by the `.ino` extension.

The `.pde` and `.ino` files aren't recognised as C++ code by Xcode. During the first compilation, the project is prepared by embedXcode: the files are recognised as C++ code to allow code-sense.

>*Related entries*: [C++ language](#c-language), [File `.cpp`](#file-cpp), [File `.ino`](#file-ino), [Sketch](#sketch)

## File `.tex`

File extension for LaTeX file, a language for documents with high quality formatting.

The LaTeX files are generated by Doxygen and converted into PDF documents.

>*Related entries*: [File `.docset`](#file-docset)

## Framework

The framework includes a set of libraries (including core and application libraries) that provide an hardware abstraction layer.

The libraries are invoked by the `#include` statement.

Thanks to the hardware abstraction layer, the same code can virtually run on any boards with an IDE based on that framework.

The framework for the boards is mostly written in C and C++.

The two references are Wiring and Arduino.

>*Related entries*: [Application libraries](#application-libraries), [Arduino](#arduino), [ARM mbed](#arm mbed), [Boards](#boards), [C++ language](#c-language), [Core libraries](#core-libraries), [Cosa](#cosa), [embedXcode](#embedxcode), [embedXcode+](#embedxcode_1), [IDE](#ide), [Libraries](#libraries), [MCU](#mcu), [Platform](#platform), [Tool-chain](#tool-chain), [Wiring](#wiring)

## Freedom

The Freedom boards feature ARM MCUs from Freescale and run the mbed SDK with the GCC tool-chain.

Support for the mbed SDK is discontinued.

>*Related entries*: [ARM mbed](#arm mbed), [Boards](#boards), [GCC GNU Compiler Collection](#gnu-compiler-collection), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger)
<!-- >
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework), [Install the Freedom platform](../../Legacy/Section8/#install-the-freedom-platform)
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards), [Upload to the Freedom K64F board](../../Legacy/Section8/#upload-to-the-freedom-k64f-board) -->

<!-- >
## Glowdeck

The Glowdeck board can also be used as a development board. It relies on a 32-bit ARM architecture.

The Glowdeck board requires a plug-in for the Arduino IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide)

>*Install*: [Install the Glowdeck platform](../../Legacy/Section4/Page6)
>
>*Upload*: [Upload to Glowdeck Board](../../Legacy/Section4/#upload-to-glowdeck-board) -->

## GNU Compiler Collection

The GCC or GNU Compiler Collection is *de facto* standard for many micro-controllers. It is part of the GNU tool-chain.

A specific version is available for the ARM MCUs.

>*Related entries*: [ARM mbed](#arm mbed), [Energia](#energia), [Freedom](#freedom), [GDB GNU Debugger](#gnu-debugger),  [Nordic](#nordic), [Nucleo](#nucleo), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger), [Particle](#particle), [Tool-Chain](#tool-chain)

## GNU Debugger

The GDB or GNU Debugger is *de facto* standard debugging tools for many micro-controllers. It is part of the GNU tool-chain.

It is based on a client-server model. The client runs on GDB, and the server is a proprietary or open-source driver, and includes MSPDebug, Segger J-Link, ST-Link or OpenOCD.

>*Related entries*:  [GCC GNU Compiler Collection](#gnu-compiler-collection),  [MSPDebug](#mspdebug), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger), [Segger J-Link programmer-debugger](#segger-j-link-programmer-debugger), [ST-Link](Appendixes/Glossary/#st-link-programmer-debugger),[Tool-Chain](#tool-chain)

## IDE

IDE stands for integrated development environment and is an application used for developing programs.

The IDEs used for the boards are based on the Processing IDE, making them very similar.

They feature a text editor and runs on Windows, Linux or Mac OS X. They use on the Wiring and Arduino frameworks, use the C++ language and rely on different tool-chains.

They are used to develop programs to be run on different boards. Each board has its own version of the IDE, differentiated by the colours of the interface.

Another examples of IDE are Xcode and Visual Studio Code.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [C++ language](#c-language), [Debugger](#debugger), [embedXcode](#embedxcode), [embedXcode+](#embedxcode_1), [Energia](#energia), [ESP32](#esp32), [ESP8266](#esp8266), [Framework](#framework), [Glowdeck](#glowdeck), [Intel](#intel), [LightBlue Bean](#lightblue-bean), [Maple IDE](#maple-ide), [MediaTek LinkIt](#mediatek-linkit), [Microduino](#microduino), [MPIDE](#mpide), [panStamp](#panstamp), [Platform](#platform), [Processing](#processing), [RFduino](#rfduino), [Robotis OpenCM](#robotis-opencm), [Seeeduino](#seeeduino), [Simblee](#simblee), [Teensyduino](#teensyduino), [TinyCircuits](#tinyCircuits), [Tool-chain](#tool-chain), [Udoo Neo](#udoo-neo), [Visual Studio Code](#visual-studio-code) [Wiring](#wiring), [Xcode](#xcode)

## Intel

In June 2017, Intel announced the end of support for the Galileo and Edison boards mid-December 2017.

The Galileo and Edison boards by Intel features a 32-bit Pentium processor on an Arduino-compatible form-factor board.

The installation of the Intel boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

Contrary to other boards, the Galileo is not powered through USB.

+ First always connect the power supply to power the board.

+ Then check the Power LED is on.

+ Finally, connect the board to the computer through USB.

Powering the board directly through USB may damage the board.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Internet of Things](#internet-of-things)
<!-- >
>*Install*: [Install the Intel platform](../../Legacy/Section4/#install-the-intel-platform), [Install the Yocto SDK for Intel Edison](../../Legacy/Section4/#install-the-intel-edison-for-yocto-sdk), [Install the MCU SDK for Intel Edison](../../Legacy/Section4/Page8)
>
>*Upload*: [Upload to Intel Edison Using WiFi or Ethernet over USB](../../Legacy/Section4/#upload-to-intel-edison-using-wifi-or-ethernet-over-usb) -->

## Internet of Things

The Internet of Things or IoT is a network of objects.

The things are objects powered by a micro-controller and featuring sensors and actuators.

The network can be local &ndash;LAN or local area network&ndash;, or wide &ndash;WAN or wide area network, through a connection to internet&ndash; via a router.

Connection is done through Bluetooth, Bluetooth Low Energy, WiFi, Ethernet, sub-1 GHz, LoRa, among other protocols.

>*Related entries*: [Arduino](#arduino), [ESP32](#esp32), [ESP8266](#esp8266), [Intel](#intel), [LaunchPad](#launchpad), [LightBlue Bean](#lightblue-bean), [MediaTek LinkIt](#mediatek-linkit), [Microsoft](#microsoft), [Moteino](#moteino), [panStamp](#panstamp), [Particle](#particle), [RedBear](#redbear), [RFduino](#rfduino), [Simblee](#simblee), [Udoo Neo](#udoo-neo)

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

>*Related entries*: [Boards](#boards), [Debugger](#debugger), [Energia](#energia), [Energia MT](#energia MT), [Internet of Things](#internet-of-things), [XDS110 programmer-debugger](#xds110-programmer-debugger)
>
>*Install*: [Install the LaunchPad platform](../../Install/Section4/LaunchPad)
>
>*Configure*: [Set options for selected LaunchPad boards](../../Develop/Section2/#set-options-for-selected-launchpad-boards)
>
>*Upload*: [Upload to LaunchPad C2000](../../Advanced/Specific-1/#upload-to-launchpad-c2000), [Upload to LaunchPad CC3200 WiFi](../../Advanced/Specific-1/#upload-to-launchpad-cc3200-wifi), [Upload to LaunchPad MSP430F5529 and MSP430FR5969](../../Advanced/Specific-1/#upload-to-launchpad-msp430f5529-and-msp430fr5969)
>
>*Debug*: [Check the configuration](../../Debug/Section3/), [Configure the LaunchPad CC3200 WiFi](../../Debug/Section3/#configure-the-launchpad-cc3200-wifi)

## Libraries

There are four kinds of libraries:

+ The **core libraries** include all the basic functions required for development. Each platform provides its own set compatible with the Wiring or Arduino framework.

+ The **application libraries** are optional libraries to provide additional features, like managing the specific UART, I&sup2;C and SPI ports.

+ The **user's libraries** are developed, or downloaded and installed, by the user, and stored under the `Library` sub-folder on the sketchbook folder.

+ The **local libraries** are part of the project and located on the same folder as the main sketch.

The embedXcode+ edition introduces a variant for the local libraries, the pre-compiled libraries.

+ Instead of using the source code, the **pre-compiled libraries** are already built and ready to use.

Libraries are managed with an `#include` statement on the main sketch and header files and with variables on the main `Makefile`.

>*Related entries*: [Application libraries](#application-libraries), [Core libraries](#core-libraries), [File `.h`](#file-h), [Framework](#framework), [Local libraries](#local-libraries), [User's libraries](#users-libraries)

## LightBlue Bean

In June 2018, Punch Through Design announced it was discontinuing the Bean boards.

The LightBlue Bean by Punch Through Design combines an Atmega328P with a CC2540-based Bluetooth Low Energy radio. The board fits into a match-box.

LightBlue provides a plug-in to be installed on top of the Arduino IDE. Please refer to the relevant section for installation.

Upload and serial console are performed over-the-air through Bluetooth.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Internet of Things](#internet-of-things)
<!-- >
>*Install*: [Install the LightBlue platform](../../Legacy/Section4/Page4)
>
>*Upload*: [Upload to LightBlue Bean using Bluetooth](../../Legacy/Section4/#upload-to-lightblue-bean-using-bluetooth) -->

## Little Robot Friends

The Little Robot Friends is a nice robot with sensors &ndash;touch, sound, light&ndash; and actuators &ndash;buzzer, LEDs. It can also be programmed.

First generation ran on an ATmega328P and required a plug-in for the Arduino IDE 1.0. The installation of the Little Robot Friends AVR board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

Second generation features an SAMD MCU. The installation of the Little Robot Friends SAMD board is performed manually but requires the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards)
<!-- >
>*Install*: [Install the Little Robot Friends Platform](../../Legacy/Section4/Page10) -->

## Local libraries

The local libraries are part of the project and located on the same folder as the main sketch.

They require to be explicitly mentioned with the `#include` statement on the main sketch.

By default, all the local libraries are included.

The embedXcode+ edition allows to create folders for local libraries and select them after the `USER_LIBS_LIST` variable on the main `Makefile`.

>*Related entries*: [Libraries](#libraries), [Pre-compiled libraries](#pre-compiled libraries)

## Maple

The Maple boards are based on 32-bit ARM MCUs.

>*Related entries*: [Boards](#boards), [Maple IDE](#maple-ide), [Microduino](#microduino), [Robotis](#robotis)
<!-- >
>*Install*: [Install the Maple platform](../../Legacy/Section4/Page11) -->

## Maple IDE

MapleIDE is the Wiring-based IDE for the Maple boards.

The MapleIDE requires special drivers.
>
>The Maple environment misses two important libraries*: `strings.h` and `stream.h`.

>*Related entries*: [IDE](#ide), [Maple](#maple), [Microduino](#microduino), [Robotis OpenCM](#robotis-opencm)

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

>*Related entries*: [Architecture](#architecture), [Boards](#boards), [Framework](#framework), [Platform](#platform), [Tool-chain](#tool-chain)

## MediaTek LinkIt

The MediaTek LinkIt boards are dedicated to IoT.

The MediaTek LinkIt One board features WiFi, Bluetooth 2.0 and 4.0 BLE, GSM and GPRS, GPS, on an Arduino form-factor.

The MediaTek LinkIt Smart 7688 Duo has the same dual-core configuration as the Arduino Y&uacute;n board. The processor runs on Linux for WiFi and while the controller is an ATmega328 compatible with Arduino.

The MediaTek LinkIt 7697 board features WiFi, Bluetooth 2.0 and 4.0 BLE, on an compact form-factor.

The installation of the MediaTek boards is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Internet of Things](#internet-of-things)
<!-- >
>*Install*: [Install the MediaTek platform](../../Legacy/Section4/Page12) -->

## Microduino

The Microduino boards feature two different architectures on a highly compact form-factor.

The 8-bit ATmega architecture includes the Microduino-Core with an ATmega328P at 16 MHz and 5V, the Microduino-Core+ with an ATmega644PA at 16 MHz and 5V and the Microduino-Core USB with an ATmega32u4 at 16 MHz. Those boards run on a plug-in for the Arduino IDE.

The 32-bit architecture corresponds to the Microduino-Core STM32 board, and uses the MapleIDE as IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Maple](#maple), [Maple IDE](#maple-ide)
<!-- >
>*Install*: [Install the Microduino platform](../../Legacy/Section4/Page13) -->

## Microsoft

Microsoft has launched an IoT DevKit for its Azure cloud service.

The board combines a Cortex-M4 with WiFi and a large selection of sensors.

The installation of the Microsoft platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [Internet of Things](#internet-of-things)
>
>*Install*: [Install the Microsoft platform](../../Install/Section4/#install-the-microsoft-platform)
>
>*Upload*: [Upload to Microsoft Azure IoT DevKit](../../Advanced/Specific-1/#upload-to-microsoft-azure-iot-devkit)

## Moteino

The Moteino platform by LowPowerLab combines an ATMega328 with a RFM69 sub-1GHz or a RFM95 LoRa radio.

The installation of the Moteino platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

The RFM69 sub-1GHz-based board requires the RFM69 library, while the RFM95 LoRa-based board requires the LoRa library from RadioHead.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [Internet of Things](#internet-of-things)
>
>*Install*: [Install the Moteino platform](../../Install/Section4/Moteino)

## MPIDE

MPIDE is the Arduino 0023-based IDE for the chipKIT boards. A beta release is based on Arduino 1.5.

MPIDE stands for Multi-Platform IDE and targets boards with a PIC32 MCU.

MPIDE is deprecated. Use instead the **Boards Manager** featured by Arduino.CC IDE release 1.6.5.

>*Related entries*: [4D Systems](#4d-systems), [Arduino](#arduino), [chipKIT](#chipkit), [Debugger](#debugger), [IDE](#ide)

## MSPDebug

MSPDebug is an open-source driver and runs as a server for GDB.

It is used for the LaunchPad boards based on the MSP430 MCUs from Texas Instruments. It is part of the Energia bundle and installed with Energia.

>*Related entries*: [GDB GNU Debugger](#gnu-debugger)

## Nordic

The Nordic boards provide an easy introduction to the internet-of-things, with Bluetooth 4.0 or BLE. The boards are based on the nRF51822 SoC, which combines a Bluetooth Low Energy radio and a Cortex-M0 MCU.

The boards run on the mbed SDK with the GCC tool-chain.

Support for the mbed SDK is discontinued.

>*Related entries*: [ARM mbed](#arm mbed), [Boards](#boards), [GCC GNU Compiler Collection](#gnu-compiler-collection), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger)
<!-- >
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework), [Install the Nucleo platform](../../Legacy/Section8/#install-the-nordic-platform)
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) -->

## Nucleo

The Nucleo boards feature ARM MCUs from STMicroelectronics and run the mbed SDK with the GCC tool-chain.

Support for the mbed SDK is discontinued.

The Nucleo boards are now supported by the STM32duino platform.

>*Related entries*: [ARM mbed](#arm mbed), [Boards](#boards), [GCC GNU Compiler Collection](#gnu-compiler-collection), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger), [STM32duino](#stm32duino)
<!-- >
>*Install*: [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework), [Install the Nucleo platform](../../Legacy/Section8/#install-the-nucleo-platform)
>
>*Upload*: [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards) -->

## Open On-Chip Debugger

The Open On-Chip Debugger, or OpenOCD, provides tools for programming and debugging MCUs. It runs with other software like GDB from the GCC tool-chain.

It requires a hardware programmer-debugger.

>*Related entries*: [ARM mbed](#arm mbed), [Energia](#energia), [GCC GNU Compiler Collection](#gnu-compiler-collection), [GDB GNU Debugger](#gnu-debugger), [Tool-chain](#tool-chain)

## panStamp

The panStamp platform features a sub-1 GHz radio and includes three architectures, one 8 bits, another 16 bits and the last 32 bits, each with a dedicated boards package managed by the **Boards Manager** on the Arduino 1.8 IDE.

The 8-bit architecture corresponds to the panStamp AVR with an ATmega328P at 16 MHz and 5V, while the 16-bit architecture corresponds to the panStamp NG based on the MSP430. Both the panStamp AVR and panStamp NG are discontinued. Finally, the 32-architecture corresponds to the panStamp Quantum based on the STM32L4.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Internet of Things](#internet-of-things)
<!-- >
>*Install*: [Install the panStamp AVR platform](../../Legacy/Section4/#install-the-panstamp-avr-platform), [Install the panStamp NRG platform](../../Legacy/Section4/#install-the-panstamp-nrg-platform), [Install the panStamp Quantum platform](../../Legacy/Section4/#install-the-panstamp-quantum-platform)
>
>*Upload*: [Upload to panStamp AVR board](../../Legacy/Section4/#upload-to-panstamp-avr-board), [Upload to panStamp NRG board](../../Legacy/Section4/#upload-to-panstamp-nrg-board), [Upload to panStamp Quantum board](../../Legacy/Section4/#upload-to-panstamp-quantum-board) -->

## Particle

The Particle Core board combines an ARM STM32F103 with the CC3000 WiFi radio from Texas Instruments.

Particle provides a dedicated cloud to manage the board from anywhere in the world. A compiled sketch can be uploaded though USB connection or over-the-air using WiFi and the Particle Cloud.

Particle relies on the Wiring / Arduino framework and use the standard GCC tool-chain.

Up to now, there's only an online IDE. The offline IDE called Particle-Dev and based on Atom is currently in development.

Particle was previously Spark.

>*Related entries*: [Architecture](#architecture), [Arduino](#arduino), [Boards](#boards), [GCC GNU Compiler Collection](#gnu-compiler-collection), [Internet of Things](#internet-of-things), [Tool-chain](#tool-chain), [Wiring](#wiring)
<!-- >
>*Install*: [Install the Particle platform](../../Legacy/Section4/Page15)
>
>*Upload*: [Upload to Particle boards](../../Legacy/Section4/#upload-to-particle-boards) -->

## Platform

A platform is a mix of IDE, frameworks, boards, architectures and tool-chains.

As an example, the Arduino platform includes

+ An IDE called Arduino;

+ Two frameworks, Arduino 1.0 and Arduino 1.5, the later still in beta;

+ Many different boards, which can be grouped in two architectures:

+ the 8-bit ATmega-based boards, as Arduino Uno or Arduino Mega2560,

+ and the 32-bit SAM-based Arduino Due board;

+ Two tool-chains, one for each architecture.

>*Related entries*: [Architecture](#architecture), [Boards](#boards), [Framework](#framework), [IDE](#ide), [MCU](#mcu), [Tool-chain](#tool-chain)

## Pre-compiled libraries

The embedXcode+ edition introduces a variant for the local libraries, the pre-compiled libraries.

Instead of using the source code, the pre-compiled libraries are already built and ready to use.

Just like the local libraries, they are part of the project and located on the same folder as the main sketch, they require to be explicitly mentioned by the `#include` statement on the main sketch and, they are all included by default.

A folder for a pre-compiled library, for example `LocalLibrary`, includes at least three files.

+ The file `LocalLibrary.a` is the pre-compiled library.

+ One or more `.h` files correspond to the header files.

+ The additional file `.board` gives the board or MCU the library has been compiled against.

The embedXcode+ edition checks the consistency of the pre-compiled libraries with the current target based on the file `.board`, and includes the pre-compiled libraries with extension `.a` during linking.

>*Related entries*: [Local libraries](#local-libraries)

## Processing

All the boards use the Processing IDE, adapted for C++.

Processing doesn't feature any board. Instead, it runs on the main computer and provides an easy interface for displaying graphs based on data acquired from the board.

>*Related entries*: [IDE](#ide)

## Raspberry Pi

The Raspberry Pi boards are single-board computers running on Linux. A board package is available for the Arduino IDE.

>*Related entries*: [RasPiArduino](#raspiarduino)

## RasPiArduino

The RasPiArduino board package brings the Wiring / Arduino SDK to the Raspberry Pi boards. Unless other boards packages, it is not managed by the Board Manager but installed instead on the `hardware` sub-folder of the Arduino sketchbook folder.

>*Related entries*: [Arduino](#arduino), [Raspberry Pi](#raspberry-pi)
>
>*Install*: [Install the RasPiArduino platform](../../Install/Section4/Page13), [Install the RasPiArduino boards package](../../Install/Section4/#install-the-raspiarduino-boards-package), [Install the tools and SDK on the Raspberry Pi](../../Install/Section4/#install-the-tools-and-sdk-on-the-raspberry-pi)
>
>*Configure*: [Set options for Raspberry Pi](../../Develop/Section2/#set-options-for-raspberry-pi)
>
>*Upload*: [Enter Raspberry Pi IP address and password](../../Develop/Section2/#enter-raspberry-pi-ip-address-and-password), [Upload to Raspberry Pi](../../Advanced/Specific-1/#upload-to-raspberry-pi)
>
>*Debug*: [Connect to the Raspberry Pi](../../Debug/Section3/#connect-to-the-raspberry-pi)

## RedBear

The RedBear &ndash;formerly RedBearLab&ndash; boards provide an easy introduction to the internet-of-things.

In March 2018, RedBear announced it was acquired by Particle. As a consequence, RedBear will terminate support for its boards on September 2019.

The boards based on the Nordic nRF51822 feature Bluetooth 4.0 or BLE. The Nordic nRF51822 SoC combines a Bluetooth Low Energy radio and a Cortex-M0 MCU. Those boards can be used with the Wiring / Arduino framework as well as with the mbed framework, both with the GCC tool-chain. The installation of the RedBear board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

The RedBear Duo board runs with the Wiring / Arduino framework and features WiFi and BLE connectivity. It requires a plug-in and a library for the Arduino 1.6.5 IDE.

The boards based on the CC3200 feature WiFi. The CC3200 from Texas Instruments combines a WiFi radio and a Cortex-M4 MCU. Those boards are supported natively by the Energia IDE.

Support for the mbed SDK is discontinued.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [Energia](#energia), [Internet of Things](#internet-of-things), [arm mbed](#arm-mbed), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger)
<!-- >
>*Install*: [Install the RedBear platform for Wiring / Arduino](../../Legacy/Section4/Page16), [Install the mbed framework](../../Legacy/Section8/#install-the-mbed-framework), [Install the RedBear platform for mbed](../../Legacy/Section8/#install-the-redbear-platform-for-mbed)
>
>*Upload*: [Upload to RedBear CC3200 Boards](../../Legacy/Section4/#upload-to-redbear-cc3200-boards), [Upload to RedBear Duo Board](../../Legacy/Section4/#upload-to-redbear-duo-board), [Upload to mbed boards](../../Legacy/Section8/#upload-to-mbed-boards), [Restore Arduino mode on RedBear boards](../../Legacy/Section4/#restore-arduino-mode-on-redbear-boards) -->

## RFduino

RFduino combines a Cortex-M0 MCU with Bluetooth Low Energy on a compact board.

RFduino requires a plug-in for the Arduino IDE 1.5.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Internet of Things](#internet-of-things), [Simblee](#simblee)
<!-- >
>*Install*: [Install the RFduino platform](../../Legacy/Section4/Page17) -->

## Robotis

The Robotis OpenCM9.04 board is based on the 32-bit ARM MCU.

The Robotis OpenCM is the dedicated IDE.

>*Related entries*: [Boards](#boards), [Maple](#maple), [Robotis OpenCM](#robotis-opencm)
<!-- >
>*Install*: [Install the Robotis platform](../../Legacy/Section4/Page18)
>
>*Upload*: [Upload to Robotis OpenCM9.04 Board](../../Legacy/Section5/#upload-to-robotis-opencm904-board) -->

## Robotis OpenCM

The Robotis OpenCM is the Wiring-based IDE for the Robotis boards.

The Robotis OpenCM requires special drivers.
>
>The Robotis environment misses two important libraries*: `strings.h` and `stream.h`.

>*Related entries*: [IDE](#ide), [Maple IDE](#maple-ide), [Robotis](#robotis), [Wiring](#wiring)

## Seeeduino

Seeed Studio is a hardware manufacturer, especially known for its Grove system.

The Seeeduino boards are based on the ATmega 328 or the SAMD compatible with the Arduino Uno and Arduino Zero, or on the Cortex-M SAMD. The Wio Terminal features two MCUs: a general Cortex-M4F SAMD51 and a network-processor RTL8720DN.

The installation of the Seeeduino board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide)
>
>*Install*: [Install the Seeeduino AVR platform](../../Install/Section4/#install-the-seeeduino-avr-platform), [Install the Seeeduino SAMD platform](../../Install/Section4/#install-the-seeeduino-samd-platform), [Install the Ameba RTL8720DN platform for the Wio Terminal board](../../Install/Section4/#install-the-ameba-rtl8720dn-platform-for-the-wio-terminal-board)
>
>*Upload*: [Upload to Seeeduino SAMD boards](../../Advanced/Specific-1/#upload-to-seeeduino-samd-boards), [Upload to the RTL8720DN MCU of the Wio Terminal](../../Advanced/Specific-1/#upload-to-the-rtl8720dn-mcu-of-the-wio-terminal-board), [Reflash the RTL8720DN MCU as a network-processor for the Wio Terminal board](../../Advanced/Specific-2/#reflash-the-rtl8720dn-mcu-as-a-network-processor-for-the-wio-terminal-board)
>
>*Debug*: [Connect the Segger J-Link to the Seeeduino Xiao M0](../../Debug/Section3/#connect-the-segger-j-link-to-the-seeeduino-xiao-m0)

## Segger J-Link programmer-debugger

Segger programmers-debuggers are the *de facto* standard for Cortex-M. The wide range of models includes the J-Link Edu and the J-Link Edu mini.

Segger provides two sets of tools: command-line J-Link and GUI-based Ozone.

>*Related entries*: [Debugger](#debugger)
>
>*Install*: [Install utilities for Segger debugger](../../Install/Section4/#install-utilities-for-segger-debugger), [Install the Segger J-Link Software Suite](../../Install/Section4/#install-the-segger-j-link-software-suite), [Install the Segger Ozone Graphical Debugger](../../Install/Section4/#install-the-segger-ozone-graphical-debugger).
>
>*Debug*: [Debug the boards with Ozone](../../Debug/Section4/#debug-the-boards-with-ozone), [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb)

## Simblee

Simblee is an updated version of the RFduino board.

It combines a Cortex-M0 MCU with Bluetooth Low Energy on a compact board.

The installation of the Simblee board is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Internet of Things](#internet-of-things), [RFduino](#rfduino)
<!-- >
>*Install*: [Install the Simblee platform](../../Legacy/Section4/Page19) -->

## Sketch

A sketch is basically a program written in C++ and based on the Wiring and Arduino framework.

The valid file extensions for a sketch are `.pde` or `.ino`.

>*Related entries*: [C++ language](#c-language), [File `.cpp`](#file-cpp), [File `.ino`](#file-ino), [File `.pde`](#file-pde)

## STM32duino

The STM32duino platform provides an easy solution for the Nucleo and Discovery boards based on the STM32 MCUs.

The initial project STM32duino has been renamed Arduino STM32. The new STM32duino project is maintained by STMicroelectronics.

The installation of the Arduino STM32 platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

>*Related entries*: [Arduino](#arduino), [Arduino STM32](#arduino-stm32), [Boards](#boards), [IDE](#ide), [MapleIDE](#mapleIDE)
>
>*Install*: [Install the STM32duino platform](../../Install/Section4/#install-the-stm32duino-platform)
>
>*Debug*: [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb)

## Arduino STM32

Previously named STM32duino, the Arduino STM32 project provides support for boards based on the STM32F1xx, STM32F3xx and STM32F4xx MCUs.

The installation of the Arduino STM32 platform is performed with the **Boards Manager** on the Arduino 1.8 IDE.

It is now superseded by the new STM32duino project maintained by STMicroelectronics.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [MapleIDE](#mapleIDE), [STM32duino](#stm32duino)
<!-- >
>*Install*: [Install the Arduino STM32 platform](../../Legacy/Section4/#install-the-arduino-stm32-platform), [Install the STM32duino platform](../../Install/Section4/#install-the-stm32duino-platform) -->

## ST-Link programmer-debugger

The ST-Link programmer-debugger is specific to STMicroelectronics boards. It includes the hardware programmer-debugger and the software driver compatible with GDB.

Although STMicroelectronics recommends [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html) :octicons-link-external-16:, which includes ST-Link but requires Java, embedXcode relies on Texane ST-Link, an open-source and native version of the STMicroelectronics ST-Link tools.

>*Related entries*: [GDB GNU Debugger](#gnu-debugger),  [STM32duino](#stm32duino)
>
>*Install*: [Install the STM32duino platform](../../Install/Section4/#install-the-stm32duino-platform)
>
>*Debug*: [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb)

## Teensy

Teensy includes two major architectures:

+ 8-bit ATmega for Teensy 2 and

+ 32-bit ARM for Teensy 3.

The Teensy boards require Teensyduino, a plug-in for the Arduino IDE.

>*Related entries*: [Boards](#boards), [Teensyduino](#teensyduino)
>
>*Install*: [Install the Teensy platform](../../Install/Section4/Teensy)
>
>*Configure*: [Set options for Teensy](../../Develop/Section2/#set-options-for-teensy)
>
>*Upload*: [Upload to Teensy 3.0 and 3.1 Boards](../../Advanced/Specific-1/#upload-to-teensy-boards)

## Teensyduino

Teensyduino is the Arduino 1.8 IDE-compatible plug-in for the Teensy boards.

Please refer to the relevant section for installation to avoid possible conflicts with the Arduino 1.8 IDE.

>*Related entries*: [IDE](#ide), [Teensy](#teensy)
>
>*Install*: [Install the Teensy platform](../../Install/Section4/Teensy)

## TinyCircuits

TinyCircuits specialises in very compact circuits. The TinyScreen+ embeds a Cortex-M0 with an OLED display.

The installation of the TinyScreen+ board is performed with the **Boards Manager** and the Lbirary Manager on the Arduino 1.6 IDE.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide)
<!-- >
>*Install*: [Install the TinyCircuits platform](../../Legacy/Section4/Page21)
>
>*Upload*: [Upload to TinyScreen+ board](../../Legacy/Section4/#upload-to-tinyscreen-board) -->

## Tool-chain

A tool-chain is a set of tools used to build, link, upload and debug a sketch to a board.

The tools from the tool-chain are called by the IDE.

The MCUs are grouped by architectures and each architecture has its specific tool-chain.

Most of the tool-chains used with the embedded computing boards are based on GCC, or GNU Compiler Collection, with GDB, or GNU Debugger, as programmer-debugger.

Other tools include programmers and debuggers, like OpenOCD, or Open On-Chip Debugger.

>*Related entries*: [Architecture](#architecture), [C++ language](#c-language), [Debugger](#debugger), [Framework](#framework), [GCC GNU Compiler Collection](#gnu-compiler-collection), [GDB GNU Debugger](#gnu-debugger), [IDE](#ide), [MCU](#mcu), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger), [Particle](#particle), [Platform](#platform)

## Udoo Neo

The Udoo Neo is a board featuring a Freescale i.MX 6SoloX processor from Freescale. The processor is dual core with a Cortex-A9 MPU running on Linux and a Cortex-M4 MCU for real-time GPIO.

The MCU supports the Wiring / Arduino framework. Installation relies on the **Boards Manager** featured by Arduino.CC IDE release 1.6.5.

>*Related entries*: [Arduino](#arduino), [Boards](#boards), [IDE](#ide), [Internet of Things](#internet-of-things)
<!-- >
>*Install*: [Install the Udoo Neo Platform](../../Legacy/Section4/Page22)
>
>*Upload*: [Upload to Udoo Neo board](../../Legacy/Section4/#upload-to-udoo-neo-board) -->

## User's libraries

The local libraries are part of the project and located on the same folder as the main sketch.

By default, no user's library is included.

They require to be

+ explicitly mentioned with the `#include` statement on the main sketch,

+ and listed on the main `Makefile` after the and listed on the main `Makefile` after the `USER_LIBS_LIST` variable.

The embedXcode+ edition lists all the user's libraries for the selected platform on the main `Makefile`.

>*Related entries*: [Libraries](#libraries)

## Visual Studio Code

Visual Studio Code is a light IDE developed by Microsoft. Extensions make it highly customisable.

Contrary to embedXcode, emCode relies on Visual Studio Code.

>*Related entries:* [IDE](#ide), [emCode](#emcode)
>
>*Install*: [Install Visual Studio Code](../Install/Code.md/#install-visual-studio-code), [Install the recommended extensions](../Install/Code.md/#install-the-recommended-extensions)

## Wiring

Wiring focuses on defining the framework.

Some boards are especially designed for Wiring, as the ATmega64-based Wiring S.

>*Related entries*: [Boards](#boards), [Framework](#framework), [IDE](#ide), [Particle](#particle), [Robotis OpenCM](#robotis-opencm)
<!-- >
>*Install*: [Install the Wiring platform](../../Legacy/Section4/Page23) -->

## Xcode

Xcode is the official IDE from Apple.

Xcode versions 9 and 10 are recommended for embedXcode.

For previous versions, consider the legacy releases of embedXcode.

emCode no longer runs on Xcode but on Visual Studio Code.

>*Related entries:* [embedXcode](#embedxcode), [embedXcode+](#embedxcode_1), [emCode](#emcode), [IDE](#ide), [Visual Studio Code](#visual-studio-code)

## XDS110 programmer-debugger

The XDS110 programmer-debugger is specific to Texas Instruments LaunchPad boards.

Most of the boards from the SimpleLink portfolio, including the MSP432, CC32xx, CC26xx and CC13xx LaunchPad boards, feature the XDS110 programmer-debugger.

Although the default programmer is **DSLite**, the XDS110 accepts the open-source **OpenOCD** or Open On-Chip Debugger utility. **OpenOCD** brings additional features, like selecting one board among multiple connected, as well as debugging, acting as a server for the GDB client, part of the GNU tool-chain.

>*Related entries:* [Debugger](#debugger), [LaunchPad](#launchpad), [GCC GNU Compiler Collection](#gnu-compiler-collection), [OpenOCD Open On-Chip Debugger](#open-on-chip-debugger)
>
>*Install*: [Install debug tools for the LaunchPad boards](../../Install/Section4/#install-debug-tools-for-the-launchpad-boards), [Install the OpenOCD driver](../../Install/Section4/#install-the-openocd-driver)
>
>*Upload*: [Select among multiple boards connected through XDS110](../../Chapter4/Section4/#select-among-multiple-boards-connected-through-xds110), [Upload to LaunchPad boards with XDS110](../../Advanced/Specific-1/#upload-to-launchpad-boards-with-xds110)
>
>*Debug*: [Debug the boards with GDB](../../Debug/Section3/#debug-the-boards-with-gdb)

## Visit the official websites

