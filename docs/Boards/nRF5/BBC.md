# Install the BBC micro:bit board

![](img/Logo-064-BBC-micro-bit.png) The nRF5 boards platform by Sandeep Mistry provides support for a wide range of nRF51 and nRF52 boards, including the BBC micro:bit board. The installation is performed with the **Boards Manager** on the Arduino 1.8 IDE.

+ Ensure **Arduino-CLI** is installed. 

+ Open a **Terminal** window.

+ Run

```bash
arduino-cli core install sandeepmistry:nRF5
```

## Install the platform

+ Follow the procedure [Install the nRF5 boards platform](../../Chapter1/Section4/#install-the-nrf5-boards-platform).

## Install the libraries

Before using Bluetooth, the stack called SoftDevice needs to be uploaded to the board.

For the BBC micro:bit board,

+ Follow the procedure [Install SoftDevice onto MicroBit](https://learn.adafruit.com/use-micro-bit-with-arduino/install-board-and-blink#install-softdevice-onto-microbit-2-5) :octicons-link-external-16: from the Adafruit Learning System.

The recommended Bluetooth library is [BLEPeripheral](https://github.com/sandeepmistry/arduino-BLEPeripheral) :octicons-link-external-16:, also developed by Sandeep Mistry.

+ Please refer to [Install additional libraries on Arduino](../Chapter1/Section4/#install-additional-libraries-on-arduino).

Adafruit provides a nice library to use the LED matrix and the Bluetooth connection.

+ Please refer to [Download Adafruit_Microbit library](https://learn.adafruit.com/use-micro-bit-with-arduino/adafruit-libraries#download-adafruit-microbit-library-6-6) :octicons-link-external-16: on the Adafruit Learning System.

## Install the Adafruit Bluefruit LE Connect application

+ Follow the procedure [Install the Adafruit Bluefruit LE Connect application](https://learn.adafruit.com/use-micro-bit-with-arduino/install-board-and-blink#install-softdevice-onto-microbit-2-5) :octicons-link-external-16: from the Adafruit Learning System.

