# Run and debug the project

## Run

### Manage the serial console after upload

By default, the **Fast** target opens a serial console in a **Terminal** window once the sketch has been uploaded to the board.

In case you prefer not to open the serial console,

+ Open the main `Makefile`.

+ Set the variable `NO_SERIAL_CONSOLE` in the main `Makefile` to `true`.

``` CMake
# Serial console for Fast target
# ----------------------------------
# For Fast target, open serial console, false or true
#
NO_SERIAL_CONSOLE = true
```

+ Otherwise, comment the line with a leading `#`, set the value to `false` or leave it empty.

``` CMake
NO_SERIAL_CONSOLE = false
NO_SERIAL_CONSOLE =
```
### Use external serial console applications

As an alternative to the serial console on a Terminal window, I recommend [CoolTerm](http://freeware.the-meiers.org) :octicons-link-external-16: and [PuTTY](https://www.putty.org/) :octicons-link-external-16:.

The variable `NO_SERIAL_CONSOLE` option only affects the **Fast** target. The **All** and **Serial** targets are not concerned.

Some boards use the same serial port for upload and serial console.

+ Ensure the serial console is disconnected before proceeding with the upload.

## Debug

Debugging involves two phases:

+ First, define the breakpoints with the associated conditions and actions within the standard **Visual Studio Code** interface.

+ Then, launch the debugging session while the sketch is running on the board.

### Check the configuration

Debugging requires a board with a built-in debugger or a board connected to an external debugger.

Examples of boards with a built-in debugger include Arduino M0 Pro, LaunchPad, BBC micro:bit, Microsoft Azure IoT DevKit.

Examples of boards connected to an external debugger include ESP32 board with the external ESP-Prog programmer-debugger, Adafruit Feather nRF52840 with the Segger J-Link emulator.

Debugging relies on the [Cortex-Debug](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug) :octicons-link-external-16: extension.

### Define the breakpoints

+ Use the Visual Studio Code interface to define breakpoints with the associated conditions and actions.

For more information about debugging with Visual Studio Code,

+ Please refer to [Debug C++ in Visual Studio Code](https://code.visualstudio.com/docs/cpp/cpp-debug) :octicons-link-external-16: and [Configure C/C++ debugging](https://code.visualstudio.com/docs/cpp/launch-json-reference) :octicons-link-external-16:.

### Power the board with the Segger J-Link debug probe

Some Segger J-Link debug probes can power the board with +5 V (300mA maximum, pin 19), while the logic level is set through `VTref` (target reference voltage, pin 1).

+ On the main `Makefile`, set the variable `JLINK_POWER` to `1`.

``` CMake
JLINK_POWER = 1
```

+ Alternatively, enter the corresponding command on **JLinkExe**.

``` bash
$ JLinkExe

J-Link> power on

J-Link> exit
```

+ Or enter the corresponding command on **Ozone**.

``` bash
Edit.SysVar(VAR_TARGET_POWER_ON,1);
```

For more information,

+ Please refer to the section JTAG Interface Connection (20 pin) on the page [Interface Description](https://www.segger.com/products/debug-probes/j-link/technology/interface-description/) :octicons-link-external-16:.

### Re-route a serial console through the Segger J-Link debug probe

Additionally, some Segger J-Link debug probes feature VCOM and re-route a serial console through J-Link `TX` (pin 5) and J-Link `RX` (pin 17).

This feature is only valid with SWD and is disabled by default. To enable it,

+ Connect the Segger J-Link debug probe.

+ Launch **JLinkConfig**.

<center>![](img/408-03-100.png)</center>

+ Select the debug probe and call the contextual menu **Configure**.

<center>![](img/408-04-540.png)</center>

+ Click on **Enable** below **Virtual COM-Port**, then on **OK**.

+ Power-cycle the debug probe.

Alternatively,

+ Open a **Terminal** window,

+ Launch the following commands after the `J-Link>` prompt.

``` bash
$ JLinkExe

J-Link> vcom enable
The new configuration applies after power cycling the debug probe.

J-Link> exit
```

If the probe has the serial number `123456789`, the serial port is re-routed to `/dev/tty.usbmodem000123456789`.

+ Just open a **Terminal** window and launch the following command with the correct speed.

``` bash
$ screen /dev/tty.usbmodem000123456789 9600
```

To disable it,

+ Proceed as before, but select **Disable** below **Virtual COM-Port** instead.

Alternatively,

+ Open a **Terminal** window,

+ Launch the following commands after the `J-Link>` prompt.

``` bash
$ JLinkExe

J-Link> vcom disable
The new configuration applies after power cycling the debug probe.

J-Link> exit
```

For more information,

+ Please refer to the section VCOM Functionality on the page [J-Link Debug Probes](https://www.segger.com/products/debug-probes/j-link) :octicons-link-external-16:.

### Launch the debugging session

To launch the debugging session, the first time,

+ Press ++ctrl+shift+d++ to display the debug pane;

+ Select the configuration on the drop-down list;

+ Hit **Start Debugging** or press ++f5++.

After the first time,

+ Press the short-key ++ctrl+shift+d++.

### Manage specific boards

Some boards require a specific procedure.

+ Please refer to the **Debug** section for the board under [Manage the boards](../../Boards/) :octicons-link-16:.

## Debug the project with Ozone

![](img/Logo-064-Ozone.png) A great alternative for debugging is **Ozone** with a Segger J-Link debugger. **Ozone** provides a GUI to program and debug a board.

For more information about the platforms and MCUs supported,

+ Please refer to the page [Supported Devices - J-Link](https://www.segger.com/supported-devices/jlink/) :octicons-exernal-link-16:.

For some boards running on FreeRTOS, **Ozone** manages FreeRTOS better than the command-line J-Link utility and is thus strongly recommended.

For more information on how to use **Ozone**,

+ Please refer to the [Ozone User Manual (UM08025)](https://www.segger.com/downloads/jlink/UM08025_Ozone.pdf) :octicons-link-external-16: from Segger.

For more information about the debugging tools,

+ Please refer to the [Segger J-Link](https://www.segger.com/jlink-debug-probes.html) :octicons-link-external-16: and [Segger Ozone](https://www.segger.com/ozone.html) :octicons-link-external-16: documentations.
