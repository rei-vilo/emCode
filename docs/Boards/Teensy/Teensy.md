---
tags:
    - Active
---

# Manage the Teensy ARM boards

The Teensy ARM platform includes the Teensy 3.0, 3.1, 3.2, LC, 3.5, 3.6, 4.0 and 4.1 boards.

## Install

To install the Teensy ARM boards,

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install teensy:avr
```

Although labelled `avr`, the `teensy:avr` core package manages the Teensy boards running on ARM Cortex-M.

## Utilities

The [TyTools collection of tools](https://github.com/Koromix/tytools) :octicons-link-external-16: includes GUI utilities to upload, reset and manage the serial console of the Teensy boards. The command line tool appears to be more stable than the default Teensy utility.

``` bash
$
git clone https://github.com/Koromix/tytools
cd tytools
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make
sudo make install
```

For more information on the TyTools, 

+ Please refer to the [TyTools](https://koromix.dev/tytools/) :octicons-link-external-16: page.

To use the TyTools instead of the default Teensy utilities, 

+ Edit and add to the main `Makefile`.

``` CMake
UPLOADER = tytools
```

## Develop

The Teensy board package includes all the libraries.

### Use the libraries for SD

Edit the main `Makefile` to list the required libraries.

``` Cmake
APP_LIBS_LIST = SPI SD SdFat
```

The board package includes the SD libraries : they use the SDIO protocol and are called with `APP_LIBS_LIST`.

The user's libraries folder called with `USER_LIBS_LIST` may contain other SD libraries, which are not compatible with the Teensy boards as they rely on the SPI protocol.

## Upload to Teensy boards

![](img/Logo-064-Teensy-2.png) The Teensy boards based on an ARM MCU require a specific procedure. The procedure applies to the Teensy 3.0, 3.1, 3.2, 3.5 and 3.6 boards.

Proceed as follow:

+ Disconnect all the SPI devices as programming is done through the SPI pins.

+ Plug the Teensy board.

+ Launch any of the targets **All**, **Upload** or **Fast**.

During the first upload, a new window asks you to press on the button on the board to start the process.

<center>![](img/368-01-360.png)</center>

+ Press the button on the Teensy board.

A final message confirms the end of the operation.

<center>![](img/368-02-360.png)</center>

The following uploads no longer require this manual operation.

### Manage error messages

In case the wrong board has been selected, the uploader displays an error message.

<center>![](img/369-02-420.png)</center>

+ Click **OK**, select the correct board following the procedure [Change the board](../../Chapter3/Section6) :octicons-link-16: and start again.

The uploader may display another error message.

<center>![](img/369-01-420.png)</center>

+ Check and edit the code accordingly.

+ Click **OK** and start again.

### Use raw HID

The Teensy boards offer a raw HID mode, with a specific driver for Serial over HID.

To configure the project for raw HID,

+ Open the main `Makefile`.

+ Set the variable `TEENSY_USB` to the desired `USB_RAWHID` type.

``` CMake
# Teensy USB options (default)
# ----------------------------------
TEENSY_USB = USB_RAWHID
```

+ Ensure `NO_SERIAL_CONSOLE` is set to `true` to prevent the serial console from starting automatically.

``` CMake
# Serial console for Fast target
# ----------------------------------
# For Fast target, open serial console, false or true
NO_SERIAL_CONSOLE = true
```

+ Download and unzip the [RawHid Test for Mac OS X](https://www.pjrc.com/teensy/rawhid_test.dmg) :octicons-link-external-16: utility from the [USB: Raw HID](https://www.pjrc.com/teensy/rawhid.html) :octicons-link-external-16: page.

+ Optionally, install telnet with Homebrew, as per the procedure [Install the telnet utility]  :octicons-link-16:.

Once the program has been uploaded to the Teensy board,

+ Open a first **Terminal** window.

+ Launch the **teensy_gateway** utility with `/Applications/Teensyduino.app/Contents/Java/hardware/tools/teensy_gateway`, assuming the **Teensyduino** application in under the  `/Applications` folder.

<center>![](img/369-03-640.png)</center>

+ Open a second **Terminal** window.

+ Launch `telnet 127.0.0.1 28541`, or `nc 127.0.0.1 28541` if **telnet** isn't available,

<center>![](img/369-04-640.png)</center>

+ Open a third **Terminal** window.

+ Launch the **rawhid_test** utility with `/Users/ReiVilo/Downloads/rawhid_test`, assuming the **rawhid_test** application in under the  `/Users/ReiVilo/Downloads/` folder.

<center>![](img/369-05-640.png)</center>

To stop,

+ Press ++ctrl+c++ on the **Terminal** window where **teensy_gateway** is running.

For more information on raw HID,

+ Please refer to [USB: Raw HID](https://www.pjrc.com/teensy/rawhid.html) :octicons-link-external-16:, [How to receive serial data from Teensy when it is configured as Disk+Keyboard?](https://forum.pjrc.com/threads/23472-How-to-receive-serial-data-from-Teensy-when-it-is-configured-as-Disk-Keyboard?p=30298&viewfull=1#post30298) :octicons-link-external-16: and [HID device to COM-Port](https://forum.pjrc.com/threads/32862-HID-device-to-COM-Port?p=95224&viewfull=1#post95224) :octicons-link-external-16:.
