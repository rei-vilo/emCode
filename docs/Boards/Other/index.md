# Add a board

If a board is not listed, adding it requires two steps plus one optional.

+ [Create a board configuration file](#create-a-configuration-file-for-a-new-board);

+ [Edit the C/C++ properties file of the project](#edit-the-cc-properties-file-of-the-project); and optionally

+ [Edit the tasks file for debug](#edit-the-tasks-file-for-debug).

## Create a configuration file for a new board

To add a configuration file for a new board,

+ Go to the `Configurations` sub-folder of the `Tools` folder of emCode.

+ Create a new file, for example `Raspberry_Pi_Pico_W_RP2040_DebugProbe_CMSIS_DAP.mk`.

!!! warning
    The file name should not contain spaces and the extension is `.mk`.

``` CMake title="Raspberry_Pi_Pico_W_RP2040_DebugProbe_CMSIS_DAP.mk"
#
# Raspberry Pi Pico W RP2040 (DebugProbe CMSIS-DAP).mk
# Board configuration file
# ----------------------------------

# Board identifier
BOARD_TAG = rpipicow

# More options
BOARD_TAG1 = rpipicow.menu.flash.2097152_0
BOARD_TAG2 = rpipicow.menu.freq.125
BOARD_TAG3 = rpipicow.menu.dbgport.Serial
BOARD_TAG4 = rpipicow.menu.dbglvl.None
BOARD_TAG5 = rpipicow.menu.usbstack.picosdk
BOARD_TAG6 = rpipicow.menu.stackprotect.Disabled
BOARD_TAG7 = rpipicow.menu.exceptions.Disabled
BOARD_TAG8 = rpipicow.menu.uploadmethod.picoprobe_cmsis_dap

# Port (optional)
BOARD_PORT = /dev/ttyACM*

# Define macros for build
GCC_PREPROCESSOR_DEFINITIONS = ARDUINO

# Specific programmer options, no port
UPLOADER = debugprobe
DELAY_BEFORE_UPLOAD = 5

# Linux
# BOARD_VOLUME = /media/$(USER)/RPI-RP2

DELAY_BEFORE_SERIAL = 5

CONFIG_NAME = Raspberry Pi Pico W RP2040 (DebugProbe CMSIS-DAP)
```

### Set the board tag

Specify the following variables:

+ `BOARD_TAG` is the unique identifier of the board, found in the `boards.txt` file.

``` CMake
# Board identifier
BOARD_TAG = rpipicow
```

+ Indexed `BOARD_TAG`, like `BOARD_TAG1` `BOARD_TAG2` ..., are sometimes required to ensure compatibility between old and new identifiers, or to complement the initial `BOARD_TAG`.

``` CMake
# More options
BOARD_TAG1 = rpipicow.menu.flash.2097152_0
BOARD_TAG2 = rpipicow.menu.freq.125
BOARD_TAG3 = rpipicow.menu.dbgport.Serial
BOARD_TAG4 = rpipicow.menu.dbglvl.None
BOARD_TAG5 = rpipicow.menu.usbstack.picosdk
BOARD_TAG6 = rpipicow.menu.stackprotect.Disabled
BOARD_TAG7 = rpipicow.menu.exceptions.Disabled
BOARD_TAG8 = rpipicow.menu.uploadmethod.picoprobe_cmsis_dap
```

### Set the serial port

+ `BOARD_PORT` defines the USB port to be used.

``` CMake
BOARD_PORT = /dev/ttyACM*
```

This parameter is optional. To know the name of the USB port, proceed as follow:

+ Open the **Terminal** window,

+ Plug the board,

+ Launch the command `ls /dev/ttyUSB*`

``` bash dollar lines="1"
ls /dev/ttyUSB*
/dev/ttyUSB0
```

+ or `ls /dev/ttyACM*`.

``` bash dollar lines="1"
ls /dev/ttyACM*
/dev/ttyACM0
```

+ Read the answer, here `/dev/ttyUSB0` or `/dev/ttyACM0`.

+ Change the value of `BOARD_PORT` accordingly.

``` CMake
BOARD_PORT = /dev/ttyACM*
```

The generic character `*` allows other values for the port, for example `/dev/ttyUSB1`.

+ `DELAY_BEFORE_SERIAL` defines a delay in seconds before opening the Console.

``` CMake
DELAY_BEFORE_SERIAL = 5
```

If previous versions, `DELAY_PRE_SERIAL` may appear instead. Change it for `DELAY_BEFORE_SERIAL`.

### Set the platform references

+ `GCC_PREPROCESSOR_DEFINITIONS` is the name of the micro-controller of the board, found in the `boards.txt` file.

``` CMake
GCC_PREPROCESSOR_DEFINITIONS = ARDUINO
```

### Set memory sizes

Normally, the Arduino configuration file of the platform provides the memory sizes for Falsh and RAM.

However, some boards are missing those critical sizes.

+ `MAX_FLASH_SIZE` gives the number of bytes of Flash. Read the specification sheet of the MCU to find the correct value.

``` CMake
MAX_FLASH_SIZE = 262144
```

+ `MAX_RAM_SIZE` gives the number of bytes of SRAM. Read the specification sheet of the MCU to find the correct value.

``` CMake
MAX_RAM_SIZE = 2048
```

Additional parameters for the programmer can be set according to the procedure [Define a specific programmer for a new board](#define-a-specific-programmer-for-a-new-board).

### Define a specific programmer for a new board

The Arduino IDE includes the central file `boards.txt` contains all the parameters of the boards.

### Set programmer options

Only specify the parameters when the values are different from the default ones.

+ `AVRDUDE_SPECIAL` states that a specific configuration is set for the programmer. Otherwise, comment the line.

``` CMake
AVRDUDE_SPECIAL = 1
```

+ `AVRDUDE_PROGRAMMER` provides the name of the specific programmer. Otherwise, the variable isn't required: just comment the line.

``` CMake
AVRDUDE_PROGRAMMER = usbtiny
```

+ `AVRDUDE_BAUDRATE` provides the speed for upload. If the speed differs from the default setting, specify it. Otherwise, the variable isn't required: just comment the line.

``` CMake
AVRDUDE_BAUDRATE = 9600
```

+ `AVRDUDE_OTHER_OPTIONS` provides a free variable, for example for selecting verbose output or erasing flash.

``` CMake
AVRDUDE_OTHER_OPTIONS = -v
```

+ If the programmer doesn't feature a serial port, set `AVRDUDE_NO_SERIAL_PORT` to 1.

``` CMake
AVRDUDE_NO_SERIAL_PORT = 1
```

+ Otherwise, set `AVRDUDE_NO_SERIAL_PORT` to O or comment the line. The port to be used is defined by `BOARD_PORT`.

### Define boot-loader options

Only specify the parameters when the values are different from the default ones.

+ If the specific boot-loader is already supported like `MiniCore` for AVR MCUs, set `BOOTLOADER` to its name.

``` CMake
BOOTLOADER = minicore
```

+ Otherwise, set the `AVRDUDE_CONF` variable to the specific avrdude.conf.

``` CMake
AVRDUDE_CONF = $(HOME)/Library/Arduino15/packages/MiniCore/hardware/avr/1.0.3/avrdude.conf
```

For more information on how to install the MiniCore boot-loader,

+ Please refer to [Change Boot-Loader for AVR-Based Arduino Boards](../../Advanced/Specific-2/#change-boot-loader-for-avr-based-arduino-boards).

### Define compatible MCU

Some boards are not listed but are compatible with another listed board.

For example, the ATmega328 is compatible with the ATmega328P. However, Arduino doesn't support the ATmega328 but supports the ATmega328P.

+ If the speed is different, just define `F_CPU`, otherwise comment the line to use the default value provided by the IDE.

``` CMake
F_CPU = 20000000L
```

However, each MCU has a unique signature required by the programmer. For example, the signature of the ATmega328 is `0x1e 0x95 0x14` while the compatible ATmega328P has `0x1e 0x95 0x0f`.

The programmer checks the signature of the MCU, so the exact reference of the MCU needs to be specified to **AVRDUDE**.

In that case,

+ Specify `AVRDUDE_MCU` as the MCU for the programmer only:

``` CMake
AVRDUDE_MCU = atmega328
```

### Set fuses options

+ Optionally, fuses can be set, including `ISP_LOCK_FUSE_PRE`, `ISP_LOCK_FUSE_POST`, `ISP_HIGH_FUSE`, `ISP_LOW_FUSE` and `ISP_EXT_FUSE`.

``` CMake
ISP_LOCK_FUSE_PRE = 0x3f
ISP_LOCK_FUSE_POST = 0x0f
ISP_HIGH_FUSE = 0xde
ISP_LOW_FUSE = 0xff
ISP_EXT_FUSE = 0x05
```

If those variables aren't defined on the board configuration file, default values are provided by the IDE.

+ To by-pass the fuses, set `AVR_IGNORE_FUSES` to `1`, otherwise set the value to `0` or comment the line.

``` CMake
AVR_IGNORE_FUSES = 1
```

+ Please refer to the documentation of the MCUs for the correct values. Incorrect values may damage the MCU.

You may also need to update the FTDI drivers to use a programmer.

+ Please refer to the documentation of the programmer for the available options, for example the [AVRDUDE - AVR Downloader Uploader](http://ftp://gnu.mirrors.pair.com/savannah/avrdude/avrdude-doc-5.5.pdf) :octicons-link-external-16: manual.

Some options, as the values for the fuses, are critical and may freeze the MCU.

+ Please refer to the documentation provided by the manufacturers for the correct values, for example the [Atmel](http://www.atmel.com/products/microcontrollers/avr/default.aspx) :octicons-link-external-16: website.

These options have been tested with the [5V FTDI basic programmer](https://www.sparkfun.com/products/9716) :octicons-link-external-16: from Sparkfun, the [USB tinyISP AVR programmer kit](http://www.adafruit.com/products/46) :octicons-link-external-16: from Adafruit and the [USB ASP programmer](http://www.protostack.com/accessories/usbasp-avr-programmer) :octicons-link-external-16: from Protostack.

## Edit the C/C++ properties file of the project

Back to the project,

+ Open the `c_cpp_properties.json` under the `.vscode` folder;

+ Add the following lines

``` CMake title="c_cpp_properties.json"
{
    "configurations": [
        {
            "name": "Raspberry_Pi_Pico_RP2040_DebugProbe_CMSIS_DAP",
            "includePath": [
                "${env:HOME}/.arduino15/packages/rp2040/hardware/rp2040/3.3.0/**",
                "${env:HOME}/Projets/Arduino/libraries/**",
                "${workspaceFolder}/**"
            ],
            "browse": {
                "limitSymbolsToIncludedHeaders": true,
                "databaseFilename": "",
                "path": [
                    "${env:HOME}/.arduino15/packages/rp2040/hardware/rp2040/3.3.0/**",
                    "${env:HOME}/Projets/Arduino/libraries/**",
                    "${workspaceFolder}/**"
                ]
            },
            "intelliSenseMode": "${default}",
            "compilerPath": "${env:HOME}/.arduino15/packages/rp2040/tools/pqt-gcc/1.5.0-b-c7bab52/bin/arm-none-eabi-g++",
            "cStandard": "c17",
            "cppStandard": "c++17",
            "defines": [
                "EMCODE=11011",
                "ARDUINO=10813"
            ],
            "forcedInclude": [
                "${env:HOME}/.arduino15/packages/rp2040/hardware/rp2040/3.3.0/cores/rp2040/Arduino.h",
                "${env:HOME}/.arduino15/packages/rp2040/hardware/rp2040/3.3.0/variants/rpipico/pins_arduino.h"
            ]
        },
    ]
}
```

### Set the path to the board package

The `includePath` section includes the aboslute path where the board package is installed by the Arduino CLI or IDE.

The `browse` section duplicates the information.

### Set the path to the compiler

The following variables are required by Visual Studio Code for

The `compilerPath` variable points to the absolute path of the compiler.

The `cStandard` and `cppStandard` variables set the version for C and C++.

The `defines` variables provide the versions of Arduino and emCode.

### Set the path to the board files

The `forcedIncludeforcedInclude` section lists two files: `Arduino.h` and `pins_arduino.h`.

`Arduino.h` provides the entry to the Arduino SDK and `pins_arduino.h` defines the pins and ports.

### Add the new boards to the template

To add a board to the template,

+ Update the `c_cpp_properties.json` file of the emCode template with the `c_cpp_properties.json` of the project.

## Edit the tasks file for debug

Below is an example of the configuration of the tasks file `tasks.json` for debugging against the Raspberry Pi Pico with the external Raspberry Pi Debug Probe CMSIS-DAP.

``` CMake title="tasks.json"
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "cortex-debug",
            "request": "launch",
            "name": "DebugProbe CMSIS-DAP",
            "servertype": "openocd",
            "serverpath": "${env:HOME}/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/bin/openocd",
            "cwd": "${workspaceRoot}",
            "executable": "${workspaceRoot}/.builds/embeddedcomputing.elf",
            "interface": "swd",
            "gdbPath": "/usr/bin/gdb-multiarch",
            "device": "RP2040",
            "serverArgs": [
                "-c", "adapter speed 5000",
                "-f", "target/rp2040.cfg",
                "-s", "${env:HOME}/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/share/openocd/scripts",
            ],
            "configFiles": [
                "interface/cmsis-dap.cfg"
            ],
            "svdFile": "${env:HOME}/Projets/emCode/Tools/SVD/rp2040.svd",
        }
    ]
}
```

Most of the parameters are related to the Cortex Debug extension. For more information,

+ Please refer to the [Cortex-Debug](https://github.com/Marus/cortex-debug/wiki) :octicons-link-external-16: wiki.

The `serverpath` variable defines the path to the GDB server, provided by the the Raspberry Pi Pico boards package.

The `gdbPath` variable defines the path to the GDB client. The recommended GDB client is `gdb-multiarch`, as the GDB client of the tools-chain of the Raspberry Pi Pico boards package does not meet the minimum version required by Visual Studio Code.

To install `gdb-multiarch`,

+ Please refer to the section [Install the extensions for debugging](../../Install/Code/#install-the-extensions-for-debugging).

The optional `svdFile` variable allows to attach a CMSIS System View Description profile.

For more infirmation on the CMSIS System View Description,

+ Please refer to the [CMSIS System View Description](https://www.keil.com/pack/doc/CMSIS/SVD/html/index.html) :octicons-link-external-16: documentation.
