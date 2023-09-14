
## Upload to ESP32-CAM board

![](img/Logo-064-Espressif-Systems.png) The ESP32-CAM board comes with no built-in programmer and features a unique ++reset++ button.

Flashing the board requires an external programmer and a specific procedure to put the board in programming mode.

<center>![](img/ESP32-FTDI.png)</center>
<center>*Example of connection with a FTDI programmer*</center>

Proceed as follow:

+ Connect the `+3.3V`, `Ground`, `U0R` and `U0T` pins of the board to the corresponding pins of the external programmer.
+ Disconnect the external programmer from the USB port.
+ Connect pin `IO0` to ground.
+ Connect the board to the USB port.
+ Press ++reset++.
+ Upload the sketch.
+ Disconnect pin `IO0` from ground.
+ Press ++reset++ to run the executable.

In case the following message is displayed on the serial console,

```
Brownout detector was triggered
```

+ Power the ESP32 board through the +5V pin instead of the +3.3V pin.

The ESP32 board requires up to 400 mA and may exceed what a standard USB port can deliver.

+ Power the ESP32 board with an external power supply.

## Upload to LaunchPad boards with XDS110

![](img/Logo-064-Launchpad.png) The following procedure is valid for boards featuring an XDS110 programmer-debugger, as long as each board has a unique serial number. The unique serial number is used for identification to upload the executable and debug.

Most of the LaunchPad boards of the SimpleLink range include an XDS110 programmer-debugger. The procedure has been tested successfully with the MSP432, CC26xx and CC13xx LaunchPad boards. It is especially handy for projects involving a server and one or many clients.

!!! note
    In order to ensure support for the external USB XDS110 debug probe, speed is limited to 1500 kHz.

In the example below, let's consider two projects for two CC1352 LaunchPad boards: one is a sensor node and the other the central hub.

+ Connect the first board, here the sensor node.

+ Open a **Terminal** window and launch `lsusb`, a utility that lists the connected USB devices.

``` bash
% ~/Library/embedXcode/Tools/Utilities/lsusb
Bus 020 Device 007: ID 0451:bef3 Texas Instruments XDS110 (02.03.00.18) Embed with CMSIS-DAP  Serial: L41009S9
```

+ Note the serial number for the first board, here `L41009S9` for the sensor.

+ Connect the second board, here the central hub.

+ Perform the same `lsusb`.

``` bash
% ~/Library/embedXcode/Tools/Utilities/lsusb
Bus 020 Device 007: ID 0451:bef3 Texas Instruments XDS110 (02.03.00.18) Embed with CMSIS-DAP  Serial: L41009S9
Bus 020 Device 006: ID 0451:bef3 Texas Instruments XDS110 (02.03.00.18) Embed with CMSIS-DAP  Serial: L41009PJ
```

+ Note the serial number for the second board, here `L41009PJ` for the central hub.

In the example, the sensor node is identified by serial `L41009S9` and the central hub by serial `L41009PJ`.

+ Create two projects, one for the sensor node and another for the central hub.

+ Edit the main `Makefile` or the board configuration file of each project, here `LaunchPad CC1312 EMT.xcconfig`, and set the uploader to `xds110`.

``` CMake
UPLOADER = xds110
```

On the project for the sensor node board,

+ Run the `All` or `Fast`  target.

+ Select `L41009S9` on the dialogue window.

<center>![](img/XDS110_L41009S9.png)</center>

+ Click **OK**.

To make the selection permanent,

+ Edit the main `Makefile` or the board configuration file of the project, here `LaunchPad CC1312 EMT.xcconfig`, for the sensor node board.

+ Set the serial number to `L41009S9`.

``` CMake
UPLOADER = xds110
XDS110_SERIAL = L41009S9
```

On the project for the central hub board,

+ Run the `All` or `Fast` target for each project.

+ Select `L41009PJ` on the dialogue window.

<center>![](img/XDS110_L41009PJ.png)</center>

+ Click **OK**.

To make the selection permanent,

+ Edit the main `Makefile` or the board configuration file of the project, here `LaunchPad CC1312 EMT.xcconfig`, for the sensor node board.

+ Set the serial number to `L41009PJ`.

``` CMake
UPLOADER = xds110
XDS110_SERIAL = L41009PJ
```

If no board corresponds to the serial number, an error message is displayed.

```
XDS110 L41009PJ not found among connected L41009S9 M4111016 E0071009
```

If two LaunchPad boards with an XDS110 programmer-debugger share the same serial number, the serial number of one board needs to be changed to make it unique.

To change the serial number of one board,

+ Disconnect all boards except the board with the serial number to change.

+ Open a **Terminal** window.

+ Run the commands

``` bash
xdsdfu -m
xdsdfu -s 12345678 -r
```
Here, `12345678` is the new serial number.

+ Check with

``` bash
xdsdfu -e
```

For more information on the XDS110 programmer-debugger and related software, and on how to change the serial number,

+ Please refer to the [XDS110 Debug Probe User's Guide](http://www.ti.com/lit/ug/sprui94/sprui94.pdf) :octicons-link-external-16:.

## Upload to LaunchPad C2000

![](img/Logo-064-Launchpad.png) The LaunchPad C2000 boards use a new upload procedure with Energia 17.

### Prepare LaunchPad C2000 F28027

Proceed as follow:

+ Unplug the LaunchPad C2000 F28027 board.

+ For the LaunchPad C2000 F28027, configure `S4 SERIAL` on.

<center>![](img/350-01-200.png)</center>

+ Configure `S1 BOOT` on-on-on or up-up-up.

<center>![](img/350-02-200.png)</center>

+ Plug the LaunchPad C2000 board in.

+ Launch any of the targets **All**, **Upload** or **Fast**.

The project is uploaded into flash.

### Prepare LaunchPad C2000 F28069

Proceed as follow:

+ Unplug the LaunchPad C2000 F28069 board.

+ Remove jumper `J6` and place jumper `J7`.

<center>![](img/351-01-200.png)</center>

Configure `S1 BOOT` on-on-on or up-up-up.

<center>![](img/351-02-200.png)</center>

+ Plug the LaunchPad C2000 board in.

+ Launch any of the targets **All**, **Upload** or **Fast**.

The project is uploaded into flash.

### Prepare LaunchPad C2000 F28069

Proceed as follow:

+ Unplug the LaunchPad C2000 F28069 board.

+ Configure `S1 BOOT` on-on-on or up-up-up.

<center>![](img/351-03-200.png)</center>

+ Plug the LaunchPad C2000 board in.

+ Launch any of the targets **All**, **Upload** or **Fast**.

The project is uploaded into flash.

## Upload to LaunchPad CC3200 WiFi

![](img/Logo-064-Launchpad.png) The LaunchPad CC3200 WiFi board requires a specific hardware configuration.

For a normal upload, proceed as follow:

+ Unplug the LaunchPad CC3200 WiFi board..

+ Remove the `JTAG J8` jumper and the `SPO2` jumper.

+ Place a wire from `JTAG J8` (emulator side) to `SOP 2` (CC3200) side.

<center>![](img/352-01-420.png)</center>
<center>*Uploading requires `TCK` connected to `SOP 2`* </center>

+ Plug the LaunchPad CC3200 WiFi board.

+ Launch any of the targets **All**, **Upload** or **Fast**.

The project is uploaded into flash and is kept even if the power is disconnected.

For a debugging session, proceed as follow:

+ Unplug the LaunchPad CC3200 WiFi board..

+ Remove the wire from `JTAG J8` (emulator side) to `SOP 2` (CC3200) side.

+ Place the `JTAG J8` jumper.

+ Place the `SOP 2` jumper.

<center>![](img/352-02-420.png)</center>
<center>*Debugging requires `TCK` and `SOP 2` jumpers placed on*</center>

+ Plug the LaunchPad CC3200 WiFi board.

+ Launch the target **Debug**.

The project is uploaded into SRAM and is lost in case the power is disconnected.

## Upload to LaunchPad CC3220 WiFi

![](img/Logo-064-Launchpad.png) The LaunchPad CC3220S and CC3220SF WiFi boards require a specific hardware and software configuration.

For a normal upload, proceed as follow:

+ Unplug the LaunchPad CC3220 WiFi board..

+ Ensure only the `SOP1` jumper is shorted.

+ Download and install the [Uniflash Standalone Flash Tool for TI Micro-Controllers (MCU), Sitara Processors and SimpleLink Devices](http://www.ti.com/tool/UNIFLASH) :octicons-link-external-16: from Texas Instruments .

+ Make sure to select release 4, as previous releases do not support the CC3220.

+ Connect the LaunchPad to the computer.

<center>![](img/Logo-128-Uniflash.png)</center>

+ Open **Uniflash** and select the `CC3220SF-LAUNCHXL` from the list of devices.

<center>![](img/352-03-640.png)</center>

+ Click **Start Image Creator**.

<center>![](img/352-04-640.png)</center>

+ Click **New Project**

+ Give the project a name, for example `CC3220 Development`.

+ Select `CC3220SF` from the **Device Type** drop-down list.

+ Set **Device Mode** to **Develop**.

<center>![](img/352-07-640.png)</center>

+ Click **Create Project**.

+ Click the **Connect** button.

+ Under **General > Settings**, make sure **Image mode** is set to `Development`.

<center>![](img/352-05-640.png)</center>

+ Click the **Generate Image** button, pictured with a flame. Sometimes, this button is not active. In that case, select the **Create Image** button instead.

<center>![](img/352-06-640.png)</center>

+ Click **Program Image (Create & Program)**.

The LaunchPad CC3220 should be ready for uploading a sketch to. Keep in mind the sketch resides in RAM and is lost if the power is disconnected.

+ Once done, launch **Energia** and program the CC3220SF with the *blinky* sketch.

If upload fails, perform the same operation with **Uniflash** but on Windows.

For more information,

+ Please refer to [UniFlash v4 Quick Guide](http://processors.wiki.ti.com/index.php/UniFlash_v4_Quick_Guide) :octicons-link-external-16:.

## Upload to LaunchPad MSP430F5529 and MSP430FR5969

![](img/Logo-064-Launchpad.png) The LaunchPad MSP430F5529 requires Energia release 10 and the LaunchPad MSP430FR5969 the release 12.

Some versions of the LaunchPad MSP430F5529 and MSP430FR5969 may require an update of the firmware.

To do so,

+ Download [Energia release 14](http://energia.nu) :octicons-link-external-16: or later.

+ Launch **Energia**.

+ Create a new basic sketch, for example the `blinky` sketch.

+ Select the board LaunchPad with MSP430F5529 or LaunchPad with MSP430FR5969

+ Upload the sketch to the LaunchPad.

If the firmware needs to be updated, a window pops-up.

<center>![](img/353-01-360.png)</center>

In that case, follow the instructions.

+ Call the menu **Tools > Update programmer**.

<center>![](img/353-02-200.png)</center>

+ Check that the upload of the sketch works correctly.

+ If necessary, repeat the update of the programmer.

+ Close **Energia**.

## Upload to Microsoft Azure IoT DevKit

![](img/Logo-064-Microsoft.png) The Microsoft Azure IoT DevKit offers different options for uploading the sketch to the board.

### Upload to Microsoft Azure IoT DevKit Through USB Port

Proceed as follow:

+ Connect the Microsoft Azure IoT DevKit board to the computer.

+ Select the `Microsoft IoT DevKit (USB)` board.

+ Launch any of the targets **All**, **Upload** or **Fast**.

### Upload to Microsoft Azure IoT DevKit Through Mass Storage Device

Proceed as follow:

+ Connect the Microsoft Azure IoT DevKit module to the computer.

A new volume called `AZ3166` appears.

<center>![](img/356-01-200.png)</center>

+ Select the `Microsoft IoT DevKit (MSD)` board.

+ Launch any of the targets **All**, **Upload** or **Fast**.

During the upload process, a warning notification may appear.
   <center>![](img/356-02-360.png)</center>

+ Click on **Close** to close the notification.

## Upload to NodeMCU 1.0 board

![](img/Logo-064-NodeMCU.png) The NodeMCU 1.0 board requires a specific procedure.

Proceed as follow:

Plug the NodeMCU 1.0 board in.

+ Launch any of the targets **All**, **Upload** or **Fast**.

+ Wait for the message window:

<center>![](img/357-01-360.png)</center>

+ Press the ++reset++ and `FLASH` buttons on the board.

+ Release the ++reset++ button first.

+ Release then the `FLASH` button.

<center>![](img/357-02-420.png)</center>

+ Click on **OK**.

<center>![](img/357-03-360.png)</center>

For more information,

+ Please refer to the [ESP8266 Community Forum](http://www.esp8266.com) :octicons-link-external-16:.

## Upload to ESP8266 NodeMCU boards using WiFi

![](img/Logo-064-NodeMCU.png) Although the ESP8266 and NodeMCU boards require no specific procedure for an over-the-air upload, the WiFi network needs to be installed and configured successfully before any upload.

Over-the-air upload requires that a sketch based on the ArduinoOTA library has been installed previously and is currently running. Otherwise,

+ Build and upload the `BasicOTA` example using the **Arduino IDE**.

Before uploading, please

+ Check that the router has discovered the NoteMCU board and note the IP address.

+ It is recommended to proceed with a test of the WiFi connection. Either try pinging the board on the **Terminal**, or uploading a sketch from the Arduino IDE.

### Check the running sketch

The over-the-air process is managed by the sketch itself, based on the `ArduinoOTA` library.

If the `ArduinoOTA` object isn't running,

+ Build the `BasicOTA` example.

+ Upload using an USB connection as per section [Upload to NodeMCU 1.0 board](../Advanced/Specific-1/#upload-to-nodemcu-10-board) :octicons-link-16:.

!!! note
    The sketch requires twice its size.

### Check the WiFi connection

To identify the IP addresses of the ESP8266 or NodeMCU board,

+ Open a **Terminal** window.

+ Run the following command.

``` bash
$ arp -a
esp_a1b2c3 (192.168.1.209) at 12:ef:34:a1:b2:c3 on en0 ifscope [ethernet]
```

The address `192.168.1.209` gives access to the board.

+ Test the board is connected with ping.

``` bash
$ ping 192.168.1.209
```

### Enter IP address

During the first compilation, embedXcode looks for the ESP8266 or NodeMCU board.

If the ESP8266 or NodeMCU board isn't found on the network, a window asks for the IP address.

<center>![](img/359-01-360.png)</center>

+ Enter the IP address of the ESP8266 or NodeMCU board.

+ Click on **OK** to validate or **Cancel** to cancel.

When validated, the IP address is saved on the board configuration file `NodeMCU 0.9 ESP-12 (WiFi)` or `NodeMCU 1.0 ESP-12E (WiFi)` in the project.

<center>![](img/359-02-360.png)</center>

The IP address is only asked once.

+ To erase the IP address, just delete the whole line.

+ To edit the IP address, just change the left part after `SSH_ADDRESS =` on the corresponding line.

Password isn't implemented.

### Upload Wiring / Arduino sketch

![](img/Logo-064-NodeMCU.png) Once the checks have been performed successfully, proceed as follow:

Connect the ESP8266 or NodeMCU board to the network through WiFi.

+ Launch any of the targets **All**, **Upload** or **Fast**.

A window may ask for allowing incoming network connections.

<center>![](img/360-01-360.png)</center>

+ Click on **Allow** to proceed.

!!! note
    The sketch requires twice its size.

For more information about the installation and use of the over-the-air upload,

+ Please refer to the procedure [ESP8266 OTA Updates](https://github.com/esp8266/Arduino/blob/4897e0006b5b0123a2fa31f67b14a3fff65ce561/doc/ota_updates/readme.md) :octicons-link-external-16:.

## Upload to Raspberry Pi

![](img/Logo-064-Raspberry-Pi.png) The Raspberry Pi board provides over-the-air connection through Ethernet or WiFi for upload, console and debugging. The connection is protected by a password defined during the installation of the board.

+ Please refer to the procedure [Install the RasPiArduino platform](../../Install/Section4/Page13) :octicons-link-16: for installation and [Enter Raspberry Pi IP address and password](../../Develop/Section2/#enter-raspberry-pi-ip-address-and-password) :octicons-link-16: for configuration.
