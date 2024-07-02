# Use the other targets

This section presents the `core` and `document` targets.

## Generate the board core archive

During the first successful build and link against a board, a pre-compiled board core archive is generated and saved under the `emCode/Tools/Cores` sub-folder.

!!! example

    The first successful build and link against the Raspberry Pi Pico RP2040 board with core `3.3.0` generates the board core archive `Raspberry_Pi_Pico_W_RP2040_MSD_3.3.0.a`. This allows the following builds to go faster as they use the archive.

    When the core is updated, for example to `3.4.0`, the procedure is called again to generate the board core archive `Raspberry_Pi_Pico_W_RP2040_MSD_3.4.0.a`. 

    ``` bash
        emCode
        ├── Template
        └── Tools
            ├── Configurations
            ├── Cores
            │   ├── Raspberry_Pi_Pico_W_RP2040_MSD_3.3.0.a
            │   └── Raspberry_Pi_Pico_W_RP2040_MSD_3.4.0.a
            └── Makefiles
    ```

The `core` target generates the board core archive.

+ Open the **Template** project.

Either 

+ Call the menu **Terminal > New Terminal** to display the built-in terminal.

+ Launch the command

``` bash dollar
make core -j SELECTED_BOARD=Raspberry_Pi_Pico_W_RP2040_MSD
```

Or 

+ Call the prompt with ++ctrl+shift+p++, enter or select `Tasks: Run Task`, then select **Core**.

## Document the project

Provided the project header files have been documented using the Doxygen keywords and fields, a website and a PDF document could be generated automatically using the `document` target. 

For more information about how to document the code, 

+ Please refer to [Documenting the code](https://www.doxygen.nl/manual/docblocks.html) :octicons-link-external-16: on the Doxygen website.

To generate the website and the PDF document

+ Open the project.

Either 

+ Call the menu **Terminal > New Terminal** to display the built-in terminal.

+ Launch the command

``` bash dollar
make document
```
Or

+ Call the prompt with ++ctrl+shift+p++, enter or select `Tasks: Run Task`, then select **Document**.

The website and the PDF document are generated and displayed.

