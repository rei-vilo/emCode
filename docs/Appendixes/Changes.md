# Changes by emCode

This section lists all the changes introduced by emCode compared to embedXcode.

## Main `Makefile` parameters

### Default values for parameters

Default values are now set to the parameters.

If the main `Makefile` doesn't define or doesn't set a value to a parameter, the following default values are used.

All those parameters and default values are listed on the `Tools/Makefiles/Step0.mk` file.

Parameter | Default value | Comment
---- | ---- | ----
`SKETCH_EXTENSION` | `ino` | Official extension
`HIDE_NUMBER` | `false` | Display the summary
`HIDE_COMMAND` | `true` | Hide the command line
`KEEP_MAIN` | `false` | Update `main.cpp`
`KEEP_TASKS` | `false` | Update the list of tasks
`USE_ARCHIVES` | `true` | Use available pre-compile archives for local libraries
`BINARY_SPECIFIC_NAME` | `embeddedcomputing` | Name of the generated executable
`USER_LIB_PATH` | Sketchbook | Full path to the user's libraries
`APPLICATIONS_PATH` | `$(HOME)/Applications` | Location of the Arduino IDE
`SEGGER_PATH` | `/opt/SEGGER` | Location of the Segger tools
`SERIAL_BAUDRATE` | `115200` | Serial speed
`NO_SERIAL_CONSOLE` | `true` | Do not launch the serial console

### New parameters

For building, the new `USE_ARCHIVES` parameter sets whether existing pre-compiled archives are used first for local libraries.

+ Empty and default value are `true` to use pre-compiled archives;

+ Uncomment and set to `false` otherwise to build the libraries.

A serial port can be imposed by `SERIAL_PORT` over the default from board configuration file.

``` cmake
SERIAL_PORT = /dev/ttyACM1
```

### Deprecated parameters

The parameter `KEEP_BOARDS_CONFIGURATIONS` is deprecated.

The parameter `KEEP_MAIN_CPP` for distributing the project is deprecated.

The parameter `SELECTED_RESOURCES` for preparing the project is deprecated.

The paramter `EMCODE_EDITION` is deprecated as set to `emCode`.

## Targets

### Deprecated targets

The target **Debug** is deprecated and replaced by the built-in debugging features of Visual Studio Code.

The target **Document** is deprecated and replaced by the Doxygen and Doxywizard utilities.

The target **Distribution** is deprecated.
