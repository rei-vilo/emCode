---
tags:
    - Legacy
---

http://s3.amazonaws.com/energiaUS/packages/package_cc13x2_index.json
http://s3.amazonaws.com/energiaUS/packages/package_msp432p_index.json
http://s3.amazonaws.com/energiaUS/packages/package_msp430_elf_GCC_index.json

10-2020-q4-major

https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads/product-release

gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2

To be placed under /home/reivilo/Projets/emCode/_energia15/packages/energia/tools/arm-none-eabi-gcc

# Install the LaunchPad plaform

![](img/Logo-064-Launchpad.png) The official IDE for the MSP430, MSP432, CC13xx, CC32xx and Tiva C LaunchPad boards is Energia. Since release 18, Energia is based on the Arduino 1.6.5 IDE, and features the **Boards Manager** and the **Libraries Manager**.

## Install the Energia IDE

To install the LaunchPad boards,

+ Download and install Energia release 1.6.10E18 under the `/Applications` folder. Energia is the official IDE for the LaunchPad platform.

<center>![](img/073-01-400.png)</center>

+ Launch it.

+ Define the path of the sketchbook folder in the menu **Energia > Preferences > Sketchbook location**.

<center>![](img/074-01-420.png)</center>

+ Avoid spaces in the name and path of the sketchbook folder.

In this example, the sketchbook folder is `/User/ReiVilo/Documents/Projects/Energia`.

The Energia 1.6.10E18 IDE provides two procedures to manage additional boards and libraries.

+ To add a board, follow the procedure [Install additional boards on Arduino](../../Chapter1/Section4/#install-additional-boards-on-arduino) :octicons-link-16:.

+ To add a library, follow the procedure [Install additional libraries on Arduino](../../Chapter1/Section4/#install-additional-libraries-on-arduino) :octicons-link-16:.

For more information on installing Energia,

+ Please refer to the [Energia Quick Start Guide](http://energia.nu/guide/) :octicons-link-external-16:.

Some LaunchPad boards may require the installation of additional tools or the update of the firmware.

Energia manages two architectures: 16-bit MSP430 and 32-bit ARM for CC3200, MSP432 and Tiva C.

Energia comes with only one architecture installed, the 16-bit MSP430G2. All the 32-bit architectures for the MSP432, CC13xx, CC32xx and Tiva C require a specific procedure detailed at [Install the 32-bit LaunchPad boards](../../Chapter1/Section4/#install-the-32-bit-launchpad-boards) :octicons-link-16:.

## Install the LaunchPad MSP430G2 boards

To install the LaunchPad MSP430G2 boards, you need to install a driver.

+ Download the LaunchPad drivers for Mac OS X: [LaunchPad CDC Drivers](http://energia.nu/files/MSP430LPCDC-1.0.3b-Signed.zip) :octicons-link-external-16: file for from the [Setup Energia on Mac OS X](http://energia.nu/guide/guide_macosx/) :octicons-link-external-16: page on the Energia website.

+ Unzip and double-click `MSP430LPCDC 1.0.3b-Signed.pkg`.

<center>![](img/075-01-420.png)</center>

+ Proceed with the installation.

Once completed, the installation reboots the computer.

## Install the LaunchPad MSP430F5529 and MSP430FR5969 boards

To install the LaunchPad MSP430F5529 and MSP430FR5969 boards, you need to check that the firmware of the programmer is up-to-date.

+ Download Energia and install it.

+ Launch **Energia**.

+ Create a new sketch, for example the `blinky` sketch.

+ Perform an upload of the sketch with Energia.

+ If the firmware needs to be updated, a window pops-up.

<center>![](img/075-02-420.png)</center>

+ In that case, follow the instructions.

+ Call the menu **Tools > Update programmer**.

<center>![](img/076-01-200.png)</center>

+ Check that the upload of the sketch works correctly.

+ If necessary, repeat the update of the programmer.

+ Close **Energia**.

## Install previous MSP430 package for more compact code

:octicons-plus-circle-16: This section requires the embedXcode+ edition.

The code built with the MSP430 board package from Energia 0101E12 is more compact than the code obtained with Energia 1.6.10E18.

This is especially important for the MSP430G2553 MCU, which includes 512 bytes of RAM only. The special board LaunchPad MSP430G2553 (compact) calls the MSP430 board package from Energia 12.

To use it,

+ Follow the procedure [Migrate Previous MSP430 Board Package to Energia 18](../../Chapter1/Section4/#migrate-previous-msp430-board-package-to-energia-18) :octicons-link-16:.

+ Select the `LaunchPad MSP430G2553 (compact)` board instead of the `LaunchPad MSP430G2553` board.

## Install release 7.3.1 of the GCC tool-chain for MSP430

:octicons-plus-circle-16: This section requires the embedXcode+ edition.

Release 7.3.1 of the GCC tool-chain for MSP430 allows access to the full range of FRAM.

!!! Warning
    Support for MSP GCC 7.3.1 is experimental.

<center>![](img/076-03-540.png)</center>

Support for GCC 7.3.1 is turned off by default. To make it active,

+ Open the `About.mk` file as described in section [Check and update the boards reference list](../../Chapter4/Section2/#check-and-update-the-boards-reference-list) :octicons-link-16:.

+ Uncomment the line containing `ENERGIA_GCC_MSP_LARGE_RELEASE`.

```
ENERGIA_GCC_MSP_LARGE_RELEASE   = 7.3.1.24
```

The boards with large memory model are: MSP430FR5969 (64 kB), MSP430FR5994 (256 kB), MSP430FR6989 (128 kB), MSP430F5529 (128 kB).

For more information on the installation of release 7.3.1 of the GCC tool-chain for MSP430,

+ Please refer to the [Read Me](https://github.com/energia/msp430-lg-core/blob/new_compiler/extras/readme.txt) :octicons-link-external-16: file on the [New Compiler](https://github.com/energia/msp430-lg-core/tree/new_compiler) :octicons-link-external-16: branch of the MSP430 core repository.

The MSP430 GCC compiler is owned by Texas Instruments and maintained by Mitto Systems since 2018.

For a description of the GCC tool-chain for MSP430,

+ Please refer to the pages [GCC - Open Source Compiler for MSP Microcontrollers](http://www.ti.com/tool/MSP430-GCC-OPENSOURCE) :octicons-link-external-16: on the Texas Instruments website and [Texas Instruments MSP430-GCC](http://www.mittosystems.com/ti-msp430-gcc.html) :octicons-link-external-16: on the Mitto Systems website.

## Install the 32-bit LaunchPad boards

The standard installation doesn't include all the boards: the MSP432, CC3200 and Tiva C need to be installed manually.

+ Follow the procedure [Install additional boards on Arduino](../../Chapter1/Section4/#install-additional-boards-on-energia) :octicons-link-16:.

+ Call the **Boards Manager** and check the MSP432, CC1310, CC3200 and Tiva C boards are listed.

<center>![](img/077-01-420.png)</center>

+ Select the board and click on **Install**.

For more information on the installation of the additional boards on the Energia IDE,

+ Please refer to the [Installing additional Arduino Cores](https://www.arduino.cc/en/Guide/Cores) :octicons-link-external-16: page on the Arduino website.

## Install the CC3200 LaunchPad

To install the CC3200 LaunchPad,

+ Please follow the instructions provided at [Setup Energia on Mac OS X](http://energia.nu/guide/guide_macosx/) :octicons-link-external-16:.

!!! Warning
    On the LaunchPad CC3200, analog inputs are limited to 1,5 V. Higher voltages may damage the MCU.

The LaunchPad CC3200 supports two frameworks: Energia and Energia MT based on TI-RTOS.

## Install the CC3220 LaunchPad

To install the CC3220 LaunchPad,

+ Please follow the instructions provided at [Setup Energia on Mac OS X](http://energia.nu/guide/guide_macosx/) :octicons-link-external-16:.

!!! Warning
    On the LaunchPad CC3220, analog inputs are limited to 1,4 V. Higher voltages may damage the MCU.

The LaunchPad CC3220 supports the Energia MT framework based on TI-RTOS.

The LaunchPad CC3220 needs to be initialised in developer mode. Sketches are uploaded into RAM and are lost if the power is disconnected.

+ Please refer to [Upload to the CC3220 LaunchPad](../../Chapter4/Section5/#upload-to-launchpad-cc3220-wifi) :octicons-link-16:.

## Install the MSP432 LaunchPad

To install the MSP432 LaunchPad,

+ Please follow the instructions provided at [Setup Energia on Mac OS X](http://energia.nu/guide/guide_macosx/) :octicons-link-external-16:.

The MSP432P401R Red LaunchPad board replaces the pre-series in black.

However, the pre-series LaunchPad board in black and the corresponding boards package are obsolete and no longer supported by embedXcode.

The LaunchPad MSP432 only supports the Energia MT framework, based on TI-RTOS.

## Install debug tools for the LaunchPad boards

:octicons-plus-circle-16: This section requires the embedXcode+ edition.

Debugging has been tested successfully on the Experimenter Board MSP430FR5739 and most of the LaunchPad boards, including MSP430G2, MSP430F5529, LM4F120 Stellaris now TM4C123 Tiva C, CC3200 WiFi, CC3220 WiFi, MSP432, CC13x0, CC13x2.

The LaunchPad MSP430G2 and MSP430F5529 and the Experimenter Board MSP430FR5739 require no additional tool as the debugger, **mspdebug**, is already provided by the Energia IDE.

The LaunchPad LM4F120 Stellaris now TM4C123 Tiva C, the LaunchPad TM4C129 Ethernet require the installation of an additional tool, namely **OpenOCD**.

Most of the boards from the SimpleLink portfolio, including the MSP432, CC32xx, CC26xx and CC13xx LaunchPad boards, feature the XDS110 programmer-debugger. Although the default programmer is **DSLite**, the XDS110 accepts the open-source **OpenOCD** utility. **OpenOCD** brings additional features, like selecting one board among multiple connected, as well as debugging.

**OpenOCD** can be installed with **Homebrew** or built from source code.

## Install OpenOCD with Homebrew

The installation of **OpenOCD** can be done using **Homebrew** or by building it from the source code.

To install **OpenOCD** with **Homebrew**,

<center>![](img/080-01-260.png)</center>

+ Open a **Terminal** window.

+ Launch the following command to install **Homebrew**.

``` bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

+ Launch the following command to install **OpenOCD** and its dependencies.

``` bash
$ brew install openocd
```

Some LaunchPad boards require a specific installation of **OpenOCD**. This is done by specifying options during installation.

For example, the CC3200 LaunchPad requires the `--enable-ft2232_libftdi --enable-stlink` options with OpenOCD version 0.9.0, but no longer with OpenOCD version 0.10.0.

=== "Homebrew release prior to 2.0"

    With **Homebrew** release prior to 2.0, the options were listed on the installation command line, tested in this example on OpenOCD version 0.9.0:

    ``` bash
    $ brew install openocd --enable-ft2232_libftdi --enable-stlink
    ```

    Those options can be combined with those for other boards.

=== "Homebrew release 2.0 and later"

    Since release 2.0, **Homebrew** no longer accepts the options listed on the installation command line. The new procedure relies on the `--edit` option, tested on OpenOCD version 0.10.0.

    + On a **Terminal** window, launch to open the default editor.

    ``` bash
    % brew edit openocd
    ```

    + To use a specific editor, define the `HOMEBREW_EDITOR` variable before.

    ``` bash
    % export HOMEBREW_EDITOR=/usr/local/bin/nano
    % brew edit openocd
    ```

    + Add the options, then save and close the editor.

    <center>![](img/080-02-640.png)</center>

    + Now, launch the installation of **OpenOCD**:

    ``` bash
    % brew install openocd
    ```

## Build OpenOCD from source code

Alternatively, to build **OpenOCD** from source code,

+ Download [SimpleLink-OpenOCD](http://www.ti.com/tool/SIMPLELINK-OPENOCD) :octicons-link-external-16: from Texas Instruments website.

+ Follow the procedure included in the [Release notes](http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/simplelink-openocd/latest/exports/Texas_Instruments_SimpleLink_OpenOCD_Release_Notes_1_0.pdf) :octicons-link-external-16: to build and install it.

## Find more information

For more information on the use of **Homebrew**,

+ Please refer to the [Homebrew Documentation](https://docs.brew.sh) :octicons-link-external-16:.

For more information on the configuration of **OpenOCD**,

+ Please refer to the [OpenOCD documentation](http://openocd.sourceforge.net/documentation) :octicons-link-external-16: and to the websites of the respective manufacturers of the boards.

For more information on the installation of **OpenOCD** for the LaunchPad CC3200,

+ Please refer to [TI's SimpleLink CC3200-LaunchXL with Linux First Steps](http://azug.minpet.unibas.ch/~lukas/bricol/ti_simplelink/CC3200-LaunchXL.html#openOCD) :octicons-link-external-16:.

For more information on how to build and install **OpenOCD** from source code,

+ Please refer to [Texas Instruments Release Notes](http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/simplelink-openocd/latest/exports/Texas_Instruments_SimpleLink_OpenOCD_Release_Notes_1_0.pdf) :octicons-link-external-16:.

+ Please refer to the sections [Building OpenOCD](http://openocd.org/doc-release/README) :octicons-link-external-16: and [Building OpenOCD for OSX](http://openocd.org/doc-release/README.OSX) :octicons-link-external-16: on the OpenOCD website.

:octicons-plus-circle-16: All the LaunchPad boards feature a built-in hardware debugger.

+ Learn more on how to use the debugger at the chapter [Debug the project](../../Chapter5/Section1/) :octicons-link-16:.

:octicons-plus-circle-16: The embedXcode+ edition allows to locate the Energia IDE in another folder.

+ Please refer to the section [Set the folder for standard IDEs](../../Chapter1/Section3/#set-the-folder-for-standard-ides) :octicons-link-16:.

# Install additional boards on Energia

![](img/Logo-064-Energia-1.png) Starting release 1.6.10E18, the Energia IDE includes a **Boards Manager** for downloading and installing additional boards. It relies on a list of URLs set in the **Preferences** pane.

## Install additional boards

+ Call the menu **Tools > Board > Boards Manager...**

<center>![](img/083-01-420.png)</center>

A new window lists all the boards available, already installed or ready for installation, based on a set of URLs.

<center>![](img/083-02-420.png)</center>

+ Select the board and click on **Install**.

<center>![](img/084-01-420.png)</center>

+ Click **OK**.

If the board isn't listed, the URL needs to be added manually.

For more information on the installation of the additional boards on the Energia IDE,

+ Please refer to the [Installing additional Arduino Cores](https://www.arduino.cc/en/Guide/Cores) :octicons-link-external-16: page on the Arduino website.

## Add URLs for new boards

The **Boards Manager** lists the boards based on a set of URLs. To add a new board, the relevant URL should be added. The URL corresponds to a JSON file.

```
https://www.adafruit.com/package_adafruit_index.json
```

+ Call the menu **Energia > Preferences**.

This is the preference window, with a list of URLs at **Additional Boards Manager URLs**.

<center>![](img/084-02-420.png)</center>

+ Click on the button at the right of **Additional Boards Manager URLs**.

<center>![](img/085-01-420.png)</center>

+ Paste the URL with the JSON file. There should be one URL per line.

+ Click **OK**.

+ Call the menu **Tools > Board > Boards Manager...**

## Update the boards

Check and update the boards when new releases are available.

Before updating the board, make sure the new release is supported by embedXcode.

+ Call the menu **Tools > Board > Boards Manager...**

+ Set the **Type** to **Upgradable**.

<center>![](img/085-02-220.png)</center>

The window displays all the boards to be updated.

<center>![](img/085-03-420.png)</center>

+ Select the board and click on Update.

<center>![](img/085-04-420.png)</center>

+ Once all boards are updated, click on **Close**.

## Check supported boards

This procedure has been tested successfully with the following boards:

+ ![](img/Logo-064-Energia-1.png) Energia MSP432, CC13xx, CC32xx and Tiva C.

<center>![](img/086-01-420.png)</center>

# Install additional libraries on Energia

![](img/Logo-064-Energia-1.png) Starting release 1.6.10E18, the Energia IDE includes a **Libraries Manager** for downloading and installing additional libraries. It relies on a list of URLs managed centrally by Energia.

## Install additional libraries

+ Call the menu **Sketch > Include Library > Manage Libraries...**

<center>![](img/093-01-420.png)</center>

A new window lists all the libraries available, already installed or ready for installation.

<center>![](img/093-02-420.png)</center>

+ Select the library and click on **Install**.

<center>![](img/094-01-420.png)</center>

+ Click **OK**.

For more information on the installation of the additional boards on the Energia IDE,

+ Please refer to the [Installing Additional Arduino Libraries](https://www.arduino.cc/en/Guide/Libraries) :octicons-link-external-16: page on the Arduino website.

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Platform | IDE | Package | Date | Comment
---- | ---- | ---- | ---- | ---- | ----
![](img/Logo-064-Launchpad.png) | **LaunchPad** | Energia 1.8.10E23 | | 17 Dec 2019 | Actually released 02 Feb 2020
| | | | CC13x0 EMT 4.9.1 | | For CC1310- and CC1350-based boards
| | | | CC13x2 EMT 5.31.0-beta3 | | For CC1312- and CC1352-based boards
| | | | CC3200 1.0.3 | |
| | | | CC3220 EMT 5.6.2 | | For CC3220S and CC3220SF LaunchPad boards
| | | | MSP430 1.0.7 | | For MSP430G2, MPS430F and MSP430FR LaunchPad boards
| | | | MSP430 ELF 2.1.0 | | For MPS430FR LaunchPad boards
| | | | MSP432E EMT 5.19.0 | | For MSP432E401Y and TM4C1294XL LaunchPad boards
| | | | MSP432P EMT 5.29.0-beta1 | | For red MSP432P4111 LaunchPad board
| | | | MSP432R EMT 5.29.0 | | For red MSP432P401R LaunchPad board
| | | | Tiva C 1.0.4 | | For LM4F- and TM4C-based LaunchPad boards
![](img/Logo-064-eC.png) | emCode |  |  |

## Visit the official websites

![](img/Logo-064-Launchpad.png) | **LaunchPad**
:---- | ----
IDE | Energia and Energia MT
Website | <http://www.ti.com/ww/en/launchpad> :octicons-link-external-16:
Download | <http://energia.nu/download> :octicons-link-external-16:
Wiki | <http://energia.nu> :octicons-link-external-16:
Blog | <http://energia.nu/blog> :octicons-link-external-16:
Forum | <http://forum.43oh.com/forum/28-energia/> :octicons-link-external-16:
Multi-tasking | <http://energia.nu/guide/multitasking> :octicons-link-external-16:
Galaxia library | <https://github.com/rei-vilo/GalaxiaLibrary> :octicons-link-external-16:
Documentation | <http://embeddedcomputing.weebly.com/exploring-rtos-with-galaxia.html> :octicons-link-external-16:
Forum | <http://forum.43oh.com/topic/8620-energia-library-rtos-libraries-for-msp432-on-energia-mt> :octicons-link-external-16:

