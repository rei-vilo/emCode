---
tags:
    - Legacy
---

# Manage the Adafruit AVR Trinket and Trinket Pro boards

## Install

To use the Adafruit AVR Trinket and Trinket Pro boards,

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install adafruit:avr
```

For both the Trinket and Trinket Pro, Adafruit acknowledges stability issues with the direct USB upload.

For the Trinket Pro, Adafruit recommends to use a standard FTDI programmer for a better reliability.

For the Adafruit M0 and M4 boards, Adafruit offers a drag-and-drop feature to flash the board. Called UF2 for USB Flashing Format, this option turns the boards into a mass storage device. However, the executable needs to be converted into a  `.uf2` file. The utility for the conversion is provided with the Adafruit nRF52 boards package.

For more information,

+ Please refer to the section [Install the FTDI driver](../../Install/Section4/#install-the-ftdi-driver) :octicons-link-16: and to the page [Using FTDI Cables](https://learn.adafruit.com/introducing-pro-trinket/using-ftdi) :octicons-link-external-16: on the Adafruit website.

+ Please refer to the page [UF2 Bootloader Details](https://learn.adafruit.com/adafruit-feather-m0-express-designed-for-circuit-python-circuitpython/uf2-bootloader-details) :octicons-link-external-16: and [Updating the bootloader](https://learn.adafruit.com/adafruit-feather-m0-express-designed-for-circuit-python-circuitpython/uf2-bootloader-details#updating-the-bootloader-46-33) :octicons-link-external-16:.

## Upload

![](img/Logo-064-Adafruit.png) The Trinket and Pro Trinket boards from Adafruit require a specific procedure.

For the Pro Trinket, Adafruit recommends to use a standard FTDI programmer for a better reliability. For more information,

+ Please refer to the [Using FTDI Cables](https://learn.adafruit.com/introducing-pro-trinket/using-ftdi) :octicons-link-external-16: page on the Adafruit website.

Proceed as follow:

+ Plug the Adafruit board in.

+ Launch any of the targets **All**, **Upload** or **Fast**.

+ Wait for the message window:

<center>![](img/330-01-360.png)</center>

+ Press the ++reset++ button on the board.

<center>![](img/330-02-420.png)</center>

+ The red LED starts flashing.

+ Click on **OK**.

<center>![](img/330-03-360.png)</center>

By default, those boards don't feature a serial-to-USB communication.

For more information,

+ Please refer to the pages [Programming with AVRdude](https://learn.adafruit.com/introducing-trinket/programming-with-avrdude) :octicons-link-external-16: for the Trinket boards and [Setting-Up the Arduino IDE](https://learn.adafruit.com/introducing-pro-trinket/setting-up-arduino-ide) :octicons-link-external-16: for the Pro Trinket boards.
