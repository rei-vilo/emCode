# Build and upload the project

emCode includes ten targets, called tasks by Visual Studio Code.

+ **Build** cleans the files from a previous compilation, compiles and links.

+ **Fast** compiles only the main sketch and the local libraries, links, uploads and opens a serial window in Terminal.

+ **Upload** uploads the resulting HEX or BIN executable file to the board.

+ **Serial** open the serial console in a Terminal window.

+ **Clean** erases the files generated from a previous compilation.

+ **Make** compiles only the main sketch and the local libraries, and links.

+ **Archive** prepares archives for the local libraries.

+ **Unarchive** erases the archives for the local libraries.

+ **Core** generates the pre-compiled board core archive.

+ **Document** builds the documentation.

## Compare the targets

The following table shows the scope of each target:

Target... | Cleans | Compiles | Uploads | Opens Terminal | Debugs
---- | :----: | :----: | :----: | :----: | :----:
Build | :fontawesome-solid-check: | :fontawesome-solid-check: | | |
Upload | | | :fontawesome-solid-check: | |
Serial | | | | :fontawesome-solid-check: |
Clean | :fontawesome-solid-check: | | | |
Fast | | :fontawesome-solid-check: | :fontawesome-solid-check: | :fontawesome-solid-check: |
Make | | :fontawesome-solid-check: | | |
Debug | | :fontawesome-solid-check: | :fontawesome-solid-check: | | :fontawesome-solid-check:

The **Build** target is recommended for a clean compilation, for example when a user's library has been changed.

## Select a target

To select a target,

+ Press a short-key.

Key | Target
---- | ----
++ctrl+shift+b++ | Build
++ctrl+shift+u++ | Upload
++ctrl+shift+t++ | Fast
++ctrl+shift+d++ | Debug

+ Call the prompt with ++ctrl+shift+p++ and enter `Tasks: Run Task`;

+ Then select the target you want.

## Build

To build,

+ Press ++ctrl+shift+b++, or

+ Call the prompt with ++ctrl+shift+p++, enter `Tasks: Run Task` and select **Build**.

### Define parallel build

By default, emCode use parallel build to speed-up the process. The parallel build uses as many threads as cores available.

The impact of parallel build on speed depends on the number of cores of the microprocessor.

If parallel build is unstable, return to the standard build with one thread.

To reverse to standard build with one thread,

+ Open the `tasks.json` file under the `.vscode` folder of the project;

+ Remove the `"-j",` line from the task arguments.

``` json
    "tasks": [
        {
            "label": "Build",
            "type": "shell",
            "command": "make",
            "args": [
                "build",
                "-j",
                "SELECTED_BOARD=${command:cpptools.activeConfigName}"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "Build with makefile"
        },
    ]
```

### Define compiler options

Some project may require additional options.

+ Open the main `Makefile` and

+ Add the parameters to the variable `COMPILER_OPTIONS` in the main `Makefile`.

``` CMake
# Compiler options
# ----------------------------------
# If 0 or empty, no additional options
#
COMPILER_OPTIONS = -fpermissive
```

In this example, `-fpermissive` has been added.

``` CMake
# Compiler options
# ----------------------------------
# If 0 or empty, no additional options
#
COMPILER_OPTIONS = -Wl,-u,_printf_float,-u,-_scanf_float
```

In this example, formatting float numbers has been added.

``` CMake
COMPILER_OPTIONS = -flto
```

In this example, the `-flto` implements link time optimisation on GCC to optimise the executable size.

For more information on the authorised parameters,

+ Please refer to the compiler documentation.

### Define linker options

Some project may require additional options.

+ Open the main `Makefile` and

+ Add the parameters to the variable `LINKER_OPTIONS` in the main `Makefile`.

``` CMake
# Compiler and linker options
# ----------------------------------
# If 0 or empty, no additional options
#
COMPILER_OPTIONS =
LINKER_OPTIONS = -Wl,--check-sections
```

In this example, `-Wl,--check-sections` has been added.

For more information on the authorised parameters,

+ Please refer to the compiler documentation.

### Define warning messages

Contrary to errors, warnings don't stop compilation but they point at possible cause of errors.

The variable `WARNING_OPTIONS` on the main `Makefile` selects the scope of the warning messages.

By default, the variable `WARNING_OPTIONS` is set to 0: no warning messages are reported.

``` CMake
# Warning options
# ----------------------------------
# For example, unused variables with unused-variable.
#
# If 0, no warnings
# If empty, all warnings, same as WARNING_OPTIONS = all
# WARNING_OPTIONS = all no-missing-braces no-conversion-null no-pointer-arith
# WARNING_OPTIONS = unused-variable unused-function unused-label unused-value no-conversion-null no-pointer-arith
#
WARNING_OPTIONS = 0
```

If `WARNING_OPTIONS` is left empty, all warnings are displayed. This is the same as `WARNING_OPTIONS = all`.

``` CMake
# Warning options
#
WARNING_OPTIONS =
WARNING_OPTIONS = all
```

The `all` option corresponds to the `-Wall` parameter and usually generates a very long list of warning messages, making the analysis difficult if not impossible.

The solution consists on selecting a scope and targeting specific warnings.

Define the selected warnings by listing the options after the variable `WARNING_OPTIONS`.

Here are two examples:

+ To check all the unused elements and save precious SRAM and Flash memory, define the following warning options.

``` CMake
# Warning options
#
WARNING_OPTIONS = unused-variable unused-function unused-label unused-value
```

+ To check all the use of `NULL`, define the following warning options.

``` CMake
# Warning options
#
WARNING_OPTIONS = conversion-null pointer-arith
```

For more information on the many other warning messages options,

+ Please refer to the [Using the GNU Compiler Collection Manual](https://gcc.gnu.org/onlinedocs/gcc-10.5.0/gcc/Warning-Options.html) :octicons-link-external-16:.

### Define a binary specific name

Some project may setting a specific name for the binary. Default names of the binaries are based on `embeddedcomputing`: `embeddedcomputing.bin`, `embeddedcomputing.hex`, `embeddedcomputing.elf` and alike.

To define a specific binary name,

+ Open the main `Makefile`;

+ Add or edit the line `BINARY_SPECIFIC_NAME`; and

+ Define a binary specific name.

``` CMake
# C-compliant project name and extension
PROJECT_NAME_AS_IDENTIFIER = embed1

# Binary name, default=embeddedcomputing
BINARY_SPECIFIC_NAME = $(PROJECT_NAME_AS_IDENTIFIER)
```

In the example, the binary specific name is set to `embed1`, the C-compliant name of the project through the variable `$(PROJECT_NAME_AS_IDENTIFIER)`.

+ Just enter whatever value after `BINARY_SPECIFIC_NAME` to set another name,

``` CMake
# Binary name, default=embeddedcomputing
BINARY_SPECIFIC_NAME = myBinarySpecificName
```

### Define a final command

Some project may require to run a final command once compilation is successful.

To define a final command,

+ Open the main `Makefile`,

+ Add or edit the line `COMMAND_FINAL` and

+ Define the bash command.

``` CMake
# Final command after make,
COMMAND_FINAL = cp $(TARGET_HEX) $(CURRENT_DIR)/
```

In the example, the final command copies the binary `.hex` to the folder of the project.

The **Report Navigator** displays the final command.

``` CMake
---- Final ----
cp ./.builds/embeddedcomputing.hex .
==== Make done ====
```

## Upload

To upload,

+ Press ++ctrl+shift+u++, or

+ Call the prompt with ++ctrl+shift+p++, enter `Tasks: Run Task` and select **Upload**.

Some boards require specific procedures.

+ Please refer to [Manage boards](../Boards/).

### Customise the serial port

The serial port is used for the upload of the sketches and for the console.

Each platform has a different implementation of the USB port naming.

To change the serial port,

+ Open the main `Makefile`.

+ Uncomment the line `BOARD_PORT` by removing the leading `#` and define the serial port.

``` CMake
BOARD_PORT = /dev/tty.usbACM1
```

To know the USB port name of the active board, proceed as follow:

+ Launch a **Terminal** window

+ Plug the board on the USB port.

+ Run the following command and note the name of the port.

``` bash dollar lines="1"
ls /dev/ttyACM*
/dev/tty.usbACM1
```

To change the speed of the serial console,

+ Open the main `Makefile`.

+ Uncomment the line `SERIAL_BAUDRATE` and set the desired speed.

``` CMake
# SERIAL_BAUDRATE for the serial console, 115200 by default
# Uncomment and specify another speed
#
SERIAL_BAUDRATE = 230400
```

### Manage specific boards

Some boards require a specific procedure.

+ Please refer to the **Upload** section for the board under [Manage the boards](../../Boards/).
