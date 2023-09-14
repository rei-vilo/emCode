---
tags:
    - Active
---

# Manage the Seeed AVR Grove Beginner Kit for Arduino

## Install

The Seeed platform includes two main lines of boards: the Grove Beginner Kit for Arduino.

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash
$
arduino-cli core install Seeeduino:avr
```

The Grove Beginner Kit for Arduino includes different sensors, which require the installation of the corresponding libraries.

To install the library for the display, the temperature sensor, the barometer and the accelerometer,

+ Run

``` bash
$
arduino-cli lib install U8g2
arduino-cli lib install "Grove Temperature And Humidity Sensor"
arduino-cli lib install "Grove - Barometer Sensor BMP280"
arduino-cli lin install "Grove-3-Axis-Digital-Accelerometer-2g-to-16g-LIS3DHTR"
```

For more information on the installation process,

+ Please refer to the [How to Add Seeed Boards to Arduino IDE](http://wiki.seeed.cc/Seeed_Arduino_Boards/) :octicons-link-external-16: page on the Seeed Studio website.

## Develop

### Use the libraries for accelerometer

Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = Grove-3-Axis-Digital-Accelerometer-2g-to-16g-LIS3DHTR
```

### Use the libraries for barometer

Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = Grove_-_Barometer_Sensor_BMP280
```

### Use the libraries for display

Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = U8g2
```

### Use the libraries for temperature and humidity sensor

Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = Grove_Temperature_And_Humidity_Sensor
```

## Check the tests

The test protocol includes building and linking, uploading and running a sketch on the boards using those versions of the IDEs and plug-ins. Boards packages are versioned but not dated.

| | Platform | IDE | Package | Date | Comment
---- | ---- | ---- | ---- | ---- | ----
![](img/Logo-064-Seeeduino.png) | **Seeeduino** | Arduino 1.8 | AVR 1.3.0 | | For Seeed and Seeed Grove Beginner Kit
| | | | SAMD 1.8.0 | | For Xiao SAMD and Wio Terminal boards
| | | | Realtek 3.0.7 | | For RTL8720DN on Wio Terminal board

## Visit the official websites

![](img/Logo-064-Seeed.png) | **Seeeduino**
:---- | ----
IDE | Arduino CLI or 2.0 IDE
Website | <https://www.seeedstudio.com> :octicons-link-external-16:
Download | <http://wiki.seeed.cc/Seeed_Arduino_Boards> :octicons-link-external-16:
Wiki | <http://wiki.seeed.cc/Seeeduino_v4.2/> :octicons-link-external-16:
Grove Beginner Kit For Arduino | <https://wiki.seeedstudio.com/Grove-Beginner-Kit-For-Arduino/> :octicons-link-external-16:
Forum | <https://forum.seeedstudio.com/> :octicons-link-external-16:
