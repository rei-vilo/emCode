---
tags:
    - Active
---

# Manage the Silicon Labs boards

## Install

To install the Silicon Labs board,

+ Ensure the Arduino tools, CLI or IDE, are installed.

+ Ensure the `arduino-cli.yaml` configuration file for Arduino-CLI or the **Additional boards manager URLs** for Arduino IDE includes

```
https://siliconlabs.github.io/arduino/package_arduinosilabs_index.json
```

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install SiliconLabs:silabs
```

For more information on the installation process,

+ Please refer to the [Installation](https://github.com/siliconlabs/arduino/#installation/) :octicons-link-external-16: section on the GitHub repository.

## Develop

### Use the libraries for Bluetooth

The GSDK already includes the Bluetooth features. 

+ Ensure the selected board features Bluetooth, like `SiliconLabs_BGM220_BLE`.

However, the ezBLE library provides an option.

+ Edit the main `Makefile` to list the required libraries.

``` CMake
APP_LIBS_LIST = ezBLE
```

### Use the libraries for Matter

+ Ensure the selected board features Matter, like `SiliconLabs_xG24_Matter`;

+ Edit the main `Makefile` to list the required libraries.

``` CMake
APP_LIBS_LIST = Matter
```

### Use the libraries for RGB LED

+ Edit the main `Makefile` to list the required libraries.

``` CMake
APP_LIBS_LIST = ezWS2812
```

## Upload

Upload uses the **Simplicity Commander** utility in command-line mode.

For more information, 

* Please refer to the user guide [UG162: Simplicity Commander Reference Guide](https://www.silabs.com/documents/public/user-guides/ug162-simplicity-commander-reference-guide.pdf) :octicons-link-external-16:.

## Debug

Debug is not yet fully operational, pending ticket [#4](https://github.com/SiliconLabs/arduino/issues/4) :octicons-link-external-16:. 

Debug requires the [J-Link Software and Documentation Pack](https://www.segger.com/downloads/jlink/) :octicons-link-external-16:.

Debug requires a board without the pre-compiled option, for example `SiliconLabs_BGM220` instead of `SiliconLabs_BGM220_precompiled`.

