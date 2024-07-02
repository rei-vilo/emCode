# Manage compatibility with Arduino

Projects developed by emCode are highly compatible with the standard Arduino-CLI or Arduino IDE.

The standard Arduino IDE will open and compile most emCode projects successfully.

+ Double-click on the main sketch of the emCode project, `embed1.ino` on the example.

+ Compile with the standard Arduino IDE.

However, unlike the standard Arduino IDE, code with emCode is true C++. The main difference is, emCode buils and links the code directly, while standard Arduino IDE processes the code before building and linking it.

The table below lists the points to ensure compatibility betwen emCode and the standard Arduino IDE.

Category | Point | emCode | Arduino
--- | --- | --- | ---
**Main sketch** | Functions prototypes | If needed | Optional
 | Core library `#include` | Required | Optional
 | All used libraries `#include`  | Optional | Required
**Main `Makefile`** | All used libraries listed | Required | Not available
**Libraries** | Local libraries | Optional | Not available
 | Pre-compiled libraries | Optional | Not available
  | `.hpp` header files | Optional | Not available
**Energia MT**  | `rtosGlobals.h` file | Optional | Dedicated `.ino`
 | `setupRtos()` function | Optional | Dedicated `.ino `
**Portability** | Code for multiple MCUs | Optional | Optional
**Projects names and paths** |Spaces and special characters | Not recommended | Not recommended
**emCode** | Pre-processing variable | Available | Optional

## Ensure compatibility for the main sketch

### Declare functions prototypes on main sketch

The main consequence of true C++ is the need for declaring prototypes of the functions in the main sketch.

In the example provided below, the prototype for `functionB()` is required, as `functionB()` is called by `functionA()` but defined after.

``` cpp
// Prototypes
void functionA();
void functionB();

// Functions
void functionA()
{
    Serial.println("functionA");
    functionB();
}

void functionB()
{
    Serial.println("functionB");
}
```

Without prototyping `functionB()`, compilation would raise an error. The Arduino IDE adds the prototypes on the main sketch.

Prototypes aren't required for libraries as they are already included in the header file.

Prototypes are fully compatible with the standard Arduino IDE.

### Include core library on main sketch

The same `#include` statement to the core library is required on each header file of each library, as it is recommended for the standard Arduino IDE.

``` cpp
// SDK
#include "Arduino.h"
```

For more information on library development,

+ Please refer to [Writing a Library for Arduino](http://arduino.cc/en/Hacking/LibraryTutorial) :octicons-link-external-16:.

### Include all used libraries in main sketch

The standard Arduino IDE requires including all the libraries in the main sketch, even those not used by the main sketch but used in libraries, while emCode allows naming only the libraries which are directly called by the main sketch.

In order to ensure compatibility with the standard Arduino IDE, including all the libraries in the main sketch is thus highly recommended, as the standard Arduino IDE requires it. It doesn't affect emCode.

+ Please refer to [Use the libraries](../Develop/Libraries.md).

### List all the used libraries in main Makefile

The standard Arduino IDE includes an automatic procedure to list the libraries used by a project, while emCode requires a list of those libraries in the main `Makefile`.

Three variable are provided: the `APP_LIBS_LIST` variable lists the application libraries, the `USER_LIBS_LIST` variable the user's libraries, and the `LOCAL_LIBS_LIST` variable selects the local libraries, if they are located inside sub-folders on the project folder.

+ Please refer to [Use the libraries](../Develop/Libraries.md).

## Ensure compatibility for libraries

### Manage local libraries

The standard Arduino IDE does not manage sub-folders for libraries. The content of the sub-folders should be moved to the main folder of the project.

For more information on using local libraries,

+ Please refer to [Use the local libraries](.Develop/Libraries/#use-the-local-libraries).

### Manage pre-compiled libraries

emCode allows to include pre-compiled libraries with extension `.a` along with their header files for both user's and local libraries.

The standard Arduino IDE now manages pre-compiled user's libraries but not pre-compiled local library. The pre-compiled local library should be unarchived by running the **Unarchive** target to obtain the source code files.

For more information on pre-compiled libraries,

+ Please refer to [Manage pre-compiled libraries](../../Develop/Libraries/#manage-pre-compiled-libraries).

### Manage `.hpp` extension for header files

emCode supports the `.hpp` extension for header files.

The standard Arduino IDE now manages the `.hpp` extension for header files.

+ Change the `.hpp` extension of all the header files for `.h`.

+ Update the `#include` statements accordingly.

## Ensure compatibility for Energia MT

emCode includes some exclusive features for the Energia MT framework.

### Check the name of the functions of the tasks

Each task includes its own `setup()` and `loop()` functions with the name of the task.

When emCode allows any combinations of `setup` and `loop` in the names of the functions,

``` cpp
void TaskCode_setup()
void setup_TaskCode()
void setupTaskCode()
```

The latest release of Energia requires `loop` and `setup` to be mentioned as prefixes.

``` cpp
void setup_TaskCode()
void setupTaskCode()
```

+ Rename the `setup()` and `loop()` functions of the tasks with `loop` and `setup` mentioned as prefixes.

### Delete the setupRtos() function

The `setupRtos()` function isn't supported by Energia MT yet.

To make the project compatible,

+ Create a new sketch `rtosGlobals.ino`.

+ Copy-paste the `setupRtos()` function.

+ Add an empty `LoopRtos()` function.

``` cpp
void LoopRtos()
{
    ;
}
```

### Delete the rtosGlobals.h file

Similarly, global variables and constants are defined on the main sketch in Energia, while emCode relies on the `rtosGlobals.h` header file.

If global variables and constants are defined,

+ Move the global variables and constants from the `rtosGlobals.h` header file into the main sketch. The main sketch has the same name as the project.

+ Delete the `rtosGlobals.h` file.

Finally, emCode uses the specific variable `ENERGIA_MT`, which is not available on the standard IDE.

If the specific variable `ENERGIA_MT` is used,

+ Add the pre-processing statement on the impacted header files.

``` cpp
#define ENERGIA_MT
```

Because an Energia MT project has `ARDUINO` and `ENERGIA` already defined, those variables need to be tested in a given order.

``` cpp
#if defined(ENERGIA_MT)
// Energia MT specific
#elif defined(ENERGIA)
// Energia specific
#elif defined(ARDUINO)
// Arduino specific
#endif
```

For more information about Energia MT,

+ Please refer to the [Multi-tasking page](http://energia.nu/guide/multitasking/) :octicons-link-external-16: at the Energia website.

## Manage code for multiple platforms and MCUs

emCode allows great flexibility on customising the code, especially when developing for different platforms and MCUs.

The different platforms share most of the framework in common, except limited but annoying differences. Most of the code is the same, except a small number of lines. So we use pre-processing statements to write code for different platforms.

The most pre-processing used statements are `#if #elif #endif` and `#defined()`.

One example is the number of the pin for the LED,

``` c
// myLED pin number
#if defined(ENERGIA) // All LaunchPad boards supported by Energia
    myLED = RED_LED;
#elif defined(DIGISPARK) // Digispark specific
    myLED = 1; // assuming model A
#elif defined(MAPLE_IDE) // Maple specific
    myLED = BOARD_LED_PIN;
#elif defined(MPIDE) // MPIDE specific
    myLED = PIN_LED1;
#elif defined(WIRING) // Wiring specific
    myLED = 15;
#elif defined(ROBOTIS) // Robotis specific
    myLED = BOARD_LED_PIN;
#elif defined(RFDUINO) // RFduino specific
    myLED = 3;
#elif defined(LITTLEROBOTFRIENDS) // LittleRobotFriends specific
    myLED = 10;
#elif defined(SPARK) || defined(PARTICLE) // Particle / Spark specific
    myLED = D7;
#elif defined(PANSTAMP_AVR) // panStamp AVR specific
    myLED = 7;
#elif defined(PANSTAMP_NRG) // panStamp NRG specific
    myLED = ONBOARD_LED;
#elif defined(ESP8266) // ESP8266 specific
    myLED = 16;
#else // Arduino, chipKIT, Teensy specific
    myLED = LED_BUILTIN;
#endif
```

The name of the board is queried to select the right pin number. This example uses the MCU-based approach.

### Use the MCU-based approach

The first approach is MCU-based and relies solely on the micro-controller type.

This approach is compatible with the respective IDEs, as no new environment variable is created or required.

In the Arduino case, two frameworks exist so the IDE variable `ARDUINO` is required for disambiguation.

``` c
// Core library for code-sense - MCU-based
#if defined(__AVR_ATmega328P__) || defined(__AVR_ATmega2560__) || defined(__AVR_ATmega32U4__) || defined(__SAM3X8E__) || defined(__AVR_ATmega168__) // Arduino specific
#include "Arduino.h"
#elif defined(i586) // Galileo specific
#include "Arduino.h"
#elif defined(__32MX320F128H__) || defined(__32MX795F512L__) || defined(__32MX340F512H__) // chipKIT specific
#include "WProgram.h"
#elif defined(__AVR_ATtinyX5__) // Digispark specific
#include "Arduino.h"
#elif defined(__AVR_ATmega644P__) // Wiring specific
#include "Wiring.h"
#elif defined(__MSP430G2452__) || defined(__MSP430G2553__) || defined(__MSP430G2231__) || defined(__MSP430F5529__) || defined(__MSP430FR5739__) || defined(__MSP430F5969__) // LaunchPad MSP430 specific
#include "Energia.h"
#elif defined(__LM4F120H5QR__) || defined(__TM4C123GH6PM__) || defined(__TM4C129XNCZAD__) || defined(__CC3200R1M1RGC__) // LaunchPad LM4F TM4C CC3200 specific
#include "Energia.h"
#elif defined(__MK20DX128__) || defined(__MK20DX256__) // Teensy 3.0 3.1 specific
#include "WProgram.h"
#elif defined(__RFduino__) // RFduino specific
#include "Arduino.h"
#elif defined(MCU_STM32F103RB) || defined(MCU_STM32F103ZE) || defined(MCU_STM32F103CB) || defined(MCU_STM32F103RE) // Maple specific
#include "WProgram.h"
#else // error
#error Platform not defined or not supported
#endif
```

### Use the IDE-based approach

The second approach is IDE-based.

Each IDE defines a specific environment variable which includes the boards type it supports, and optionally the framework version.

For example, the Arduino IDE defines `ARDUINO=23`, `ARDUINO=101` or `ARDUINO=150`, depending on the version installed.

The variable is then passed on to the tool-chain with `-D`, as `-DARDUINO=101` or `-DARDUINO=150`.

``` c
// Core library for code-sense - IDE-based
#if defined(WIRING) // Wiring specific
#include "Wiring.h"
#elif defined(MAPLE_IDE) // Maple specific
#include "WProgram.h"
#elif defined(ROBOTIS) // Robotis specific
#include "libpandora_types.h"
#include "pandora.h"
#elif defined(MPIDE) // chipKIT specific
#include "WProgram.h"
#elif defined(DIGISPARK) // Digispark specific
#include "Arduino.h"
#elif defined(ENERGIA) // LaunchPad specific
#include "Energia.h"
#elif defined(LITTLEROBOTFRIENDS) // LittleRobotFriends specific
#include "LRF.h"
#elif defined(MICRODUINO) // Microduino specific
#include "Arduino.h"
#elif defined(TEENSYDUINO) // Teensy specific
#include "Arduino.h"
#elif defined(REDBEARLAB) // RedBearLab specific
#include "Arduino.h"
#elif defined(RFDUINO) // RFduino specific
#include "Arduino.h"
#elif defined(SPARK) // Spark specific
#include "application.h"
#elif defined(ARDUINO) // Arduino 1.0 and 1.5 specific
#include "Arduino.h"
#else // error
#error Platform not defined
#endif // end IDE
```

The Arduino IDE sets one single environment variable, `ARDUINO=101`.

The standard Arduino IDE often require to close one IDE and open another.

## Avoid spaces and special characters in projects names and paths

The standard Arduino IDE now, as well as the tool-chains and utilities they use, do not support spaces and special characters in the name and path of the project, although emCode manages them.

A good idea is to replace spaces by underscores. For example, rename `embed 1` to `embed_1`.

In order to ensure compatibility, it is highly recommended to avoid spaces and special characters in the name and path of the projects.

Similarly, avoid spaces in the name and path of the sketchbook folder.

## Use the `EMCODE` pre-processing variable

emCode exposes the pre-processing variable `EMCODE` with the release number as value.

``` CMake
EMCODE = 140104
```

The variable and the value are passed on to the compiler and the linker as a `-D` parameter.

``` CMake
-DEMCODE=140104
```

This allows to manage conditional pre-processing statements as `#define` and `#include` based on the IDE used, either Visual Studio Code with emCode or the standard Arduino IDE.

This also allows to open an emCode project with the standard Arduino IDE and compile it.

The `main.cpp` code file already includes the `EMCODE` variable so `main.cpp` is only considered when compiled with emCode, and ignored by the standard Arduino IDE.
