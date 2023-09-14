---
tags:
    - Active
---

# Manage the Arduino SAMD boards

The arduino SAMD platform includes the Arduino Nano 33 IoT, Arduino Zero, Arduino M0 and Arduino Tian boards.

## Install

To install the Arduino SAMD boards,

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install arduino:samd
```

## Develop

## Upload to Arduino M0 Pro

![](img/Logo-064-Arduino-IDE.png) The Arduino M0 Pro has two USB connectors: one called native and another called programmer. Both can be used to upload a sketch.

However, the programming port offers a better stability and is required for debugging.

<center>![](img/337-01-420.png)</center>
<center>*Programming port left, native USB port right*</center>

+ Click on **Allow** to proceed.

## Upload to Arduino Zero

![](img/Logo-064-Arduino-IDE.png) The Arduino Zero has two USB connectors: one called native and another called programmer. Both can be used to upload a sketch.

However, the programming port offers a better stability and is required for debugging.

<center>![](img/338-01-420.png)</center>
<center>Programming port left, native USB port right</center>

## Debug

### Select the USB Port for the Arduino M0 Pro

+ Connect the USB cable to the Programmer USB Port is order to perform debugging. The native USB port doesn't feature debugging.

<center>![](img/410-01-420.png)</center>

+ Use the USB Programming port
