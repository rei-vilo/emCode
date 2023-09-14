---
tags:
    - On hold
---

# Manage the Seeed AVR Grove Beginner Kit for Arduino

## Install

The Seeed platform includes two main lines of boards: the Grove Beginner Kit for Arduino.

+ Ensure **Arduino-CLI** is installed.

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install Seeeduino:avr
```

The Grove Beginner Kit for Arduino includes different sensors, which require the installation of the corresponding libraries.

To install the library for the display, the temperature sensor, the barometer and the accelerometer,

+ Run

``` bash dollar
arduino-cli lib install U8g2
arduino-cli lib install "Grove Temperature And Humidity Sensor"
arduino-cli lib install "Grove - Barometer Sensor BMP280"
arduino-cli lin install "Grove-3-Axis-Digital-Accelerometer-2g-to-16g-LIS3DHTR"
```

For more information on the installation process,

+ Please refer to the [How to Add Seeed Boards to Arduino IDE](http://wiki.seeed.cc/Seeed_Arduino_Boards/) :octicons-link-external-16: page on the Seeed Studio website.

## Develop

### Use the libraries for accelerometer

+ Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = Grove-3-Axis-Digital-Accelerometer-2g-to-16g-LIS3DHTR
```

### Use the libraries for barometer

+ Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = Grove_-_Barometer_Sensor_BMP280
```

### Use the libraries for display

+ Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = U8g2
```

### Use the libraries for temperature and humidity sensor

+ Edit the main `Makefile` to list the required libraries.

``` CMake
USER_LIBS_LIST = Grove_Temperature_And_Humidity_Sensor
```

## Debug