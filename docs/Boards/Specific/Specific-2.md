# Restore initial mode on specific boards

Some sections in this chapter require embedXcode+.

This section provides the procedures for restoring the initial mode on specific boards.

+ Burn the boot-loader on the [Adafruit Feather M0 boards](../../Advanced/Specific-2/#burn-the-boot-loader-for-adafruit-feather-m0-boards) to use the standard USB uploader after the programmer,

+ Upload Python to the [Adafruit Feather M4 boards](../../Advanced/Specific-2/#upload-python-to-the-adafruit-feather-m4-boards) to use the standard USB uploader after the programmer,

+ Burn the boot-loader on the [Arduino boards](../../Advanced/Specific-2/#burn-the-boot-loader-after-using-a-programmer-for-arduino-boards) to use the standard USB uploader after the programmer,

+ Reset the [BBC micro:bit board](../../Advanced/Specific-2/#reset-the-bbc-microbit-board-to-factory-default) to factory defaults.

+ Burn the boot-loader on the [chipKIT boards](../../Advanced/Specific-2/#burn-the-boot-loader-after-using-a-programmer-on-chipkit-boards) to use the standard USB uploader after the programmer,

+ Change the jumpers for the [LaunchPad CC3200 WiFi](../../Advanced/Specific-1/#upload-to-launchpad-cc3200-wifi) board.

+ Restore the initial WiFi mode with AT commands after using the [ESP8266 board](../../Advanced/Specific-2/#restore-initial-wifi-mode-on-esp8266-boards) with the Wiring / Arduino framework, and

+ [Reflash the RTL8720DN MCU as a network-processor for the Wio Terminal board](../../Advanced/Specific-2/#reflash-the-rtl8720dn-mcu-as-a-network-processor-for-the-wio-terminal-board)

## Burn the boot-loader for Adafruit Feather M0 boards

  ![](img/Logo-064-Adafruit.png) The programmer may erase all the flash of the Adafruit Feather M0 boards, including the boot-loader. In such a case, you need to burn the boot-loader again to upload a sketch through the standard USB connection.

To burn the boot-loader again,

+ Download the boot-loader file from the [Restoring Boot-Loader &ndash; Feather M0 or Others](https://learn.adafruit.com/proper-step-debugging-atsamd21-arduino-zero-m0/restoring-bootloader#feather-m0-or-others) :octicons-link-external-16: page at the Adafruit website.

+ Unzip `featherm0bootloader_160305.hex from featherm0bootloader_160305.zip`.

+ Download and install the [J-Link Software and Documentation Pack for Linux](https://www.segger.com/downloads/jlink) :octicons-link-external-16: version 6.00g or later from the Segger website.

+ Follow the procedure detailed at section [Install utilities for Segger debugger](../../Install/Section4/#install-utilities-for-segger-debugger).

+ Open a **Terminal** window and launch **JLinkExe**.

``` bash dollar
JLinkExe
```

+ Connect and define the interface, device and speed.

``` bash prefix="J-Link>"
connect
selectinterface swd
device ATSAMD21G18
speed 400080
```

Upload the boot-loader and quit.

``` bash prefix="J-Link>"
loadfile ~/Downloads/featherm0bootloader_160305.hex
exit
```

You can now upload the sketch to the Adafruit Feather M0 board using the standard USB connection again.

For more information,

+ Please refer to the [Restoring Boot-Loader &ndash; Feather M0 or Others](https://learn.adafruit.com/proper-step-debugging-atsamd21-arduino-zero-m0/restoring-bootloader#feather-m0-or-others) :octicons-link-external-16: page at the Adafruit website.

## Upload Python to the Adafruit Feather M4 boards

![](img/Logo-064-Adafruit.png) To upload Python to the Adafruit Feather M4 boards,

+ Follow the procedure [Set up CircuitPython Quick Start!](https://learn.adafruit.com/adafruit-feather-m4-express-atsamd51/circuitpython#set-up-circuitpython-quick-start-10-1) :octicons-link-external-16:  at the Adafruit website.

For more information,

+ Please refer to [Download the latest version of CircuitPython for this board via CircuitPython.org](https://circuitpython.org/board/feather_m4_express/) :octicons-link-external-16:.

## Burn the boot-loader after using a programmer for Arduino boards

![](img/Logo-064-Arduino-IDE.png) The programmer erases all the flash, including the boot-loader.

After having used a programmer with the Arduino boards, you need to burn the boot-loader again to upload a sketch through the standard USB connection.

###Restore Boot-Loader for AVR-Based Arduino Boards

To burn the boot-loader on AVR-based Arduino boards again,

+ Launch the Arduino IDE.

+ Select the board, here the `Arduino Uno` board.

<center>![](img/375-01-360.png)</center>

+ Select the programmer, here the `USBtinyASP` programmer.

<center>![](img/376-01-360.png)</center>

+ Click on **Burn Boot-Loader**.

<center>![](img/376-02-360.png)</center>

You can now upload the sketch to the board using the standard USB connection again.

For more information,

+ Please refer to the [Boot-Loader Development](http://arduino.cc/en/Hacking/Bootloader) :octicons-link-external-16: page at the Arduino website.

### Change boot-loader for AVR-based Arduino boards

The same procedure applies for changing the boot-loader. For example, for using the MiniCore boot-loader on the Arduino Uno board:

+ Launch the standard **Arduino IDE**.

+ Add the reference to Arduino, as per the procedure [Add URLs for new boards](../../Install/Section4/#add-urls-for-new-boards).

```
https://mcudude.github.io/MiniCore/package_MCUdude_MiniCore_index.json
```

+ Download and install the MiniCore package, as per the procedure [Install additional boards on Arduino](../../Install/Section4/#install-additional-boards-on-arduino).

+ Flash the MiniCore boot-loader on the Arduino Uno with USBtinyISP or similar.

On embedXcode,

+ Edit the Arduino Uno board or the My Board configuration file, and add

``` CMake
BOOTLOADER = minicore
```

+ Select it.

For more information on the MiniCore boot-loader,

+ Please refer to the [MiniCore](https://github.com/MCUdude/MiniCore) :octicons-link-external-16: page.

### Restore Boot-Loader for Arduino Zero

The two boards, Arduino Zero and Arduino M0 Pro, are very similar but require different procedures.

For the Arduino M0 Pro board,

+ Please refer to the [Restore boot-loader for Arduino M0 Pro](../../Advanced/Specific-2/#restore-boot-loader-for-arduino-m0-pro) procedure.

To burn the boot-loader on the Arduino Zero board again,

+ Launch the Arduino IDE.

+ Connect the board using the USB programming port.

+ Call the from the menu **Tools > Board** menu and select the board, here Arduino Zero (programming port).

<center>![](img/378-01-420.png)</center>

+ Call the **Tools > Programmer** menu and select the programmer, here Atmel EDBG.

<center>![](img/378-02-420.png)</center>

+ Click on **Burn Boot-Loader**.

<center>![](img/378-03-420.png)</center>

For more information,

+ Please refer to the [Restoring Boot-Loader &ndash; Arduino Zero](https://learn.adafruit.com/proper-step-debugging-atsamd21-arduino-zero-m0/restoring-bootloader#arduino-zero) :octicons-link-external-16: page at the Adafruit website.

You can now upload the sketch to the board using the standard USB connection again.

### Restore boot-loader for Arduino M0 Pro

To burn the boot-loader on the M0 Pro board again, a first option relies on the Arduino IDE, very similar to the Restore Boot-Loader for Arduino Zero procedure.

+ Launch the Arduino IDE.

+ Connect the board using the USB programming port.

+ Call the from the menu **Tools > Board** menu and select the board, here **Arduino M0 Pro (programming port)**.

+ Call the **Tools > Programmer** menu and select the programmer, here **Atmel EDBG Programming Port**.

+ Click on **Burn Boot-Loader**.

For more information,

+ Please refer to the [Burning the Boot-Loader with Arduino IDE](http://www.arduino.org/learning/tutorials/advanced-guides/how-to-write-the-bootloader-on-arduino-m0-pro-using-arduino-ide) :octicons-link-external-16: page at the Arduino website.

In case this first option fails. try and use the Atmel Studio, available on Windows only.

+ Launch the **Atmel Studio IDE**.

+ Follow the procedure available at [Burning the Boot-Loader with Atmel Studio](http://www.arduino.org/learning/tutorials/advanced-guides/arduino-m0-pro-for-advanced-user) :octicons-link-external-16: page.

For more information,

+ Please refer to the [Burn the Boot-Loader Using Atmel Studio](http://www.arduino.org/learning/tutorials/advanced-guides/how-to-burn-the-bootloader-on-an-arduino-m0-using-atmel-studio) :octicons-link-external-16: page at the Arduino website.

Depending on the version of **OpenOCD**, a bug may prevent from restoring the boot-loader. The bug is referenced under [issue 137](https://github.com/arduino/ArduinoCore-samd/issues/137) :octicons-link-external-16: on the Arduino Git repository. In that case,

+ Follow this [procedure](https://github.com/adafruit/Adafruit_ILI9341/issues/13#issuecomment-270789877) :octicons-link-external-16:, also mentioned in this [thread](http://www.arduino.org/forums/zero/solved-uploading-to-m0-pro-fails-1220?p=4600#p4599) :octicons-link-external-16: on the Arduino forum.

You can now upload the sketch to the board using the standard USB connection again.

## Reset the BBC micro:bit board to factory default

![](img/Logo-064-BBC-micro-bit.png) To reset the BBC micro:bit board to the factory default with the out-of-the-box demonstration program,

+ Download the `OutOfBoxExperience-v2.hex` file from the [Reset the micro:bit to factory defaults](https://support.microbit.org/support/solutions/articles/19000021613-reset-the-micro-bit-to-factory-defaults) :octicons-link-external-16: page on the BBC micro:bit website.

+ Follow the procedure [How do I transfer my code onto the micro:bit via USB](https://support.microbit.org/support/solutions/articles/19000013986-how-do-i-transfer-my-code-onto-the-micro-bit-via-usb) :octicons-link-external-16: on the BBC micro:bit website.

## Burn the boot-loader after using a programmer on chipKIT boards

![](img/Logo-064-chipKIT.png) On the chipKIT boards, the programmer erases all the flash, including the boot-loader.

After having used the chipKIT programmer, you need to burn to boot-loader again in order to upload a sketch through the standard USB connection.

To burn the boot-loader again,

+ Download and unzip the boot-loaders from the GitHub repository [PIC32 AVRdude Boot-Loaders](http://github.com/chipKIT32/PIC32-avrdude-bootloader) :octicons-link-external-16:.

+ Connect the programmer to the main computer and the chipKIT board.

+ Launch **mplab_ipe**.

<center>![](img/Logo-064-mplab.png)</center>

+ Select the MCU corresponding to the board.

Board | MCU
---- | ----
Uno32 | PIC32MX320F128H
Max32 | PIC32MX795F512L
uC32 | PIC32MX340F512H

+ Select the `.hex` file for the boot-loader. Make sure you've selected the relevant boot-loader, here the `PIC32-avrdude-bootloader-master/bootloaders/chipKIT-Bootloaders/dist/Uno32/production/chipKIT-Bootloaders.production.hex` for the chipKIT Uno32 board.

<center>![](img/380-01-420.png)</center>

+ Press **Program**.

+ If you wish to verify, press **Verify**.

+ Remove the programmer and connect the board to the main computer.

You can upload the sketch to the board using the standard USB connection again.

For more information,

+ Please refer to the document [Debugging chipKIT(tm) Sketches with MPLAB(r) X IDE](http://ftp://ftp.sqsol.co.uk/pub/docs/mplab/17007.pdf) :octicons-link-external-16:.

This procedure also applies for updating the boot-loader.

## Restore initial WiFi mode on ESP8266 boards

![](img/Logo-064-Espressif-Systems.png) The ESP8266 boards act as WiFi peripheral with AT commands as well as fully programmable boards with the Arduino framework.

However, once the boards have been used with the Wiring / Arduino framework, the WiFi peripheral initial mode is no longer available. It needs to be restored.

To do so,

+ Connect **GPIO0** to ground to enter program mode.

+ Plug the board in.

+ Download the [ESP8266 SDK](http://bbs.espressif.com/viewforum.php?f=5) :octicons-link-external-16: from the Download section of the Espressif forum

+ Open the `.zip` file.

+ Check the ReadMe file: it provides the list of the binary files to upload and the addresses to target.

```
download:
boot_v1.2+.bin     0x00000
user1.512.new.bin  0x01000
blank.bin          0x3e000 & 0x7e000
```

+ Locate on the sub-folders the different binaries mentioned on the `ReadMe` file.

<center>![](img/382-01-260.png)</center>

+ Open a **Terminal** window and launch the upload command.

``` bash dollar
esptool.py --port /dev/tty.usbserial-12345678 --baud 115200 write_flash 0x00000 esp_iot_sdk_v1.0.0/bin/boot_v1.2.bin 0x01000 esp_iot_sdk_v1.0.0/bin/at/user1.512.new.bin 0x3e000 esp_iot_sdk_v1.0.0/bin/blank.bin 0x7e000 esp_iot_sdk_v1.0.0/bin/blank.bin
```

+ In case the binary files and target addresses are different, adapt the upload command accordingly.

+ Power-cycle the ESP8266 board.

The ESP8266 can now be used again as a WiFi peripheral with AT commands.

For more information,

Please refer to the procedure described on the [Espressif](http://bbs.espressif.com/) :octicons-link-external-16: support forum.

## Reflash the RTL8720DN MCU as a network-processor for the Wio Terminal board

To reflash the RTL8720DN MCU back as a network-processor on the Wio Terminal board,

+ Please refer to the [Update the Wireless Core Firmware - CLI Methods](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/) :octicons-link-external-16: page on the Seeed Studio website.

+ Get the [RTL8720 firmware](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/#step-3-download-the-latest-firmware) :octicons-link-external-16: [command line utilities](https://wiki.seeedstudio.com/Wio-Terminal-Network-Overview/#cli-methods) :octicons-link-external-16: on the Seeed Studio website.
