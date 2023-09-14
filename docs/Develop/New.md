
# Create a new project

## Create a new project

To create a new project,

+ Copy the folder `~/.emCode/Template` to a new location.

+ Rename the folder.

+ Open it with **Visual Studio Code**.

If you want to change the name of the main sketch `Template`, for example `MyProject`:

+ Rename the `Template.ino` file with the new name `MyProject.ino`;

+ Edit the main `Makefile` and change the value of the `PROJECT_NAME_AS_IDENTIFIER` variable accordingly.

``` CMake
# C-compliant project name
PROJECT_NAME_AS_IDENTIFIER = MyProject
```

!!! warning
    As for the standard Arduino IDE, avoid spaces and special characters in the path and name of the project.

## Select the board

+ Select the main sketch on the left pane.

+ Select the board on the drop-down list on the bottom line.

The names of the boards always starts with the platform and then the MCU, and ends with an option.

As examples, `Adafruit_Feather_M0_USB`, `Raspberry_Pi_Pico_W_RP2040_PicoProbe` or `Teensy_4.1`.

The board can be changed afterwards with the same procedure.

!!! warning
    Visual Studio Code shows the list of the boards only when a sketch `.ino`, a header `.h` or a code file `.cpp` is selected.

If your board is not listed, you can create a configuration file.

+ Please refer to the section [Add a board](../../Boards/Other) :octicons-link-16:.

## Customise the project

On the differnt files `ReadMe.md`, main sketch `Template.ino`, local library `LocalLibrary.cpp` and `LocalLibrary.h`:

+ Adapt the fields `<#project#>` and `<#details#>`, `<#author#>`, `<#date#>` and `<#version#>`, `<#copyright#>` and `<#licence#>`.

Alternatively, press ++ctrl+shift+h++ to use the find-and-replace function of Visual Studio Code.
