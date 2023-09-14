---
tags:
    - Legacy
---

# Manage the Arduino AVR boards

## Install

To install the Arduino AVR boards,

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install arduino:avr
```

## Upload

![](img/Logo-064-Arduino-IDE.png) The Arduino Leonardo doesn't rely on an external circuit for the serial over USB connection.

There are two steps for upload the executable to the board. First, the main computer turns the serial connection to 1200 bps to trigger the boot-loader. Then, the main computer enumerates the available serial ports and starts uploading.

The delay between the two steps can be adjusted. The default value is set to one second.

```
DELAY_BEFORE_UPLOAD = 1
```

+ Open the `Arduino Leonardo.xcconfig` board configuration file.

+ Edit the line with `DELAY_BEFORE_UPLOAD` and change the value.

```
DELAY_BEFORE_UPLOAD = 2
```

The values reported as successful are between one and three seconds.

+ Select the target **All** or **Fast** or **Upload**.

+ Press the button **Run** or press ++cmd+b++.
