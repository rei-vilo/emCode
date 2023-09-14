
# Add libraries to the project

## Identify the libraries

There are four kinds of libraries:

+ The **core libraries** correspond to the Arduino SDK and include all the basic functions required for development. Each platform provides its own set compatible with the Wiring and Arduino framework. One single `#include` statement in the main sketch and in the header files includes all of them.

+ The **application libraries** are optional libraries to provide additional features, like managing the specific I&sup2;C and SPI ports. They require to be explicitly mentioned with the `#include` statement on the main sketch and listed on the main `Makefile` after the `APP_LIBS_LIST` variable.

+ The **user's libraries** are developed, or downloaded and installed, by the user, and stored under the `Library` sub-folder on the sketchbook folder. They require to be explicitly mentioned with the `#include` statement on the main sketch and listed on the main `Makefile` after the `USER_LIBS_LIST` variable.

+ The **local libraries** are part of the project and located on the same folder as the main sketch. They require to be explicitly mentioned by the `#include` statement on the main sketch. By default, all the local libraries are included.

emCode also manages a variant for the local and user's libraries, the pre-compiled libraries.

+ Instead of using the source code, the **pre-compiled libraries** are already built and ready to use. Just like the local libraries, they are part of the project and located on the same folder as the main sketch, they require to be explicitly mentioned by the `#include` statement on the main sketch and they are all included by default.

## Locate the libraries

### Locate the core libraries

The core and application libraries are located under the hidden Arduino folder, generally `~/.arduino15`, and under the `libraries` sub-folders of the boards package folders, for example `~/.arduino15/packages/arduino/hardware/avr/1.8.6/libraries`.

### Locate the application libraries

The core and application libraries are located under the hidden Arduino folder, generally `~/.arduino15`, and under the `libraries` sub-folders of the boards package folders, for example `~/.arduino15/packages/arduino/hardware/avr/1.8.6/libraries`.

### Locate the user's libraries

The user's libraries are located in the `libraries` sub-folder under the sketchbook folder, generally `~/Arduino`. The `~/Arduino/libraries` folder contains one sub-folder per library.

The users' libraries should comply with the [Arduino IDE 1.5: Library specification](https://arduino.github.io/arduino-cli/0.33/library-specification/) :octicons-link-external-16:.

### Locate the local libraries

The local libraries are located under the folder of the project, with one sub-folder per library.

The local libraries should comply with the [Arduino IDE 1.5: Library specification](https://arduino.github.io/arduino-cli/0.33/library-specification/) :octicons-link-external-16:.

## Use the libraries

Just like any other IDE, using a library in a project requires  specifying an `#include` statement on the main sketch.

Additionally, the library needs to be mentioned on the main `Makefile` to be compiled.

By default, the main `Makefile` lists...

``` CMake
# Application libraries
#
APP_LIBS_LIST = 0

# User's libraries
#
USER_LIBS_LIST = 0

# Local libraries
#
LOCAL_LIBS_LIST =
```

...with the following options:

+ All the core libraries are included.

+ No application library is included.

+ No user's library is included.

+ All the local libraries are included.

If a library has been included in the main sketch or in a header file, it needs to be listed on the main `Makefile` to be compiled. This is a standard procedure

### Use the core libraries

All the core libraries part of the Arduino SDK are included for compilation using one single `#include` statement on the main sketch. The same `#include` statement is also required on the header files.

To use the core library,

+ Add the `#include "Arduino.h"` statement on the main sketch or the header file.

``` c++
// SDK
#include "Arduino.h"
```

!!! warning
    This `#include "Arduino.h"` statement is compulsory for emCode.

### Use the application libraries

The application libraries require to be explicitly mentioned with the `#include` statement on the main sketch and listed on the main `Makefile`.

To use an application library,

+ Add the corresponding `#include` statement with the name of the header file on the main sketch or the header file.

``` c++
// Include application, user and local libraries
#include "Wire.h"
```

+ Mention the name of the folder of the library to the variable `APP_LIBS_LIST` in the main `Makefile`.

``` CMake
# Application libraries
# default = 0 = none
#
APP_LIBS_LIST = Wire
```

+ Set `APP_LIBS_LIST` to `0` to include no application library.

In case of multiple libraries,

+ Mention one include with the name of the header file per line.

``` c++
// Include application, user and local libraries
#include "Wire.h"
#include "SPI.h"
```

+ Separate the names of the folders of the libraries with a space.

``` CMake
# Application libraries
#
APP_LIBS_LIST = Wire SPI
```

### Use the user's libraries

The user’s libraries require to be explicitly mentioned with the `#include` statement on the main sketch and listed on the main `Makefile`.

To use a user's library,

+ Add the corresponding `#include` statement with the name of the header file on the main sketch or the header file.

``` c++
// Include application, user and local libraries
#include "Ethernet.h"
```

+ Mention the name of the folder of the library to the variable `USER_LIBS_LIST` in the main `Makefile`.

``` CMake
# User's libraries
# default = empty = all
#
USER_LIBS_LIST = Ethernet
```

In case of multiple user's libraries,

+ Mention one include with the name of the header file per line.

``` c++
// Include application, user and local libraries
#include "Ethernet.h"
#include "JSON.h"
```

+ Separate the names of the folders of the libraries with a space.

``` CMake
# User's libraries
# default = empty = all
#
USER_LIBS_LIST = Ethernet JSON
```

Remember, only the specified libraries are compiled.

+ Set `USER_LIBS_LIST` to `0` to include no local library.

+ Keep `USER_LIBS_LIST` empty to include all the include no local libraries.

+ Use the same procedure for pre-compiled libraries.

emCode uses the pre-compiled archives for the local libraries first when they are available.

To force the compilation of the local libraries over the use of the pre-compiled archives,

+ Edit the main `Makefile`;

+ Set `USE_ARCHIVES` to `false`.

``` CMake
# For building, use available archives, false or true, default = true
USE_ARCHIVES = false
```

### Use the local libraries

The local libraries require to be explicitly mentioned with the `#include` statement on the main sketch and listed on the main `Makefile`.

To use a local library,

+ Add the corresponding `#include` statement with the name of the header file on the main sketch or the header file.

``` c++
// Include application, user and local libraries
#include "LocalLibrary.h"
```

+ Mention the name of the folder of the library to the variable `LOCAL_LIBS_LIST` in the main `Makefile`.

``` CMake
# Local libraries
# default = empty = all
#
LOCAL_LIBS_LIST = LocalLibrary
```

In case of multiple local libraries,

+ Mention one include with the name of the header file per line.

``` c++
// Include application, user and local libraries
#include "LocalLibrary.h"
#include "AnotherLibrary.h"
```

+ Separate the names of the folders of the libraries with a space.

``` CMake
# Local libraries
# default = empty = all
#
LOCAL_LIBS_LIST = LocalLibrary AnotherLibrary
```

Remember, only the specified libraries are compiled.

+ Set `LOCAL_LIBS_LIST` to `0` to include no local library.

+ Keep `LOCAL_LIBS_LIST` empty to include all the include no local libraries.

+ Use the same procedure for pre-compiled libraries.

!!! warning
    A pre-compiled library can't be debugged, as the code source isn't provided.

For more information on how to generate a pre-compiled library,

+ Please refer to [Generate a pre-compiled library](#generate-a-pre-compiled-library) :octicons-link-16:.

## Manage non-standard libraries

The libraries should comply with the [Arduino IDE 1.5: Library specification](https://arduino.github.io/arduino-cli/0.33/library-specification/) :octicons-link-external-16:.

### Include non-standard folders

However, some libraries do not follow the [Layout of folders and files](https://arduino.github.io/arduino-cli/0.33/library-specification/#layout-of-folders-and-files) :octicons-link-external-16: from the official Arduino library specification.

This may raise issues during compilation.

!!! example

    The [TFT_eSPI library](https://github.com/Bodmer/TFT_eSPI) :octicons-link-external-16: includes header and code files in all those sub-folders.

    ```
    TFT_eSPI/
    ├── docs
    │   ├── ESP32 UNO board mod
    │   ├── ESP-IDF
    │   ├── PlatformIO
    │   └── RPi_TFT_connections
    ├── examples
    │   ├── 160 x 128
    │   ├── 320 x 240
    │   ├── 480 x 320
    │   ├── DMA test
    │   ├── ePaper
    │   ├── Generic
    │   ├── GUI Widgets
    │   ├── PNG Images
    │   ├── Smooth Fonts
    │   ├── Smooth Graphics
    │   ├── Sprite
    │   └── Test and diagnostics
    ├── Extensions
    ├── Fonts
    │   ├── Custom
    │   ├── GFXFF
    │   └── TrueType
    ├── Processors
    ├── TFT_Drivers
    ├── Tools
    │   ├── bmp2array4bit
    │   ├── Create_Smooth_Font
    │   └── Screenshot_client
    └── User_Setups
    ```

+ List all the sub-folders after `USER_LIBS_LIST`.

!!! example

    ``` CMake
    USER_LIBS_LIST = ​TFT_eSPI TFT_eSPI/Extensions TFT_eSPI/Fonts TFT_eSPI/Fonts/Custom TFT_eSPI/Fonts/GFXFF TFT_eSPI/Fonts/TrueType TFT_eSPI/TFT_Drivers
    ```

### Exclude non-standard folders

Some libraries include additional folders and files which are not related with the Wiring / Arduino project and may interfere with the compilation.

!!! example

    The [ArduinoJSON library](https://github.com/bblanchon/ArduinoJson) :octicons-link-external-16: contains the usual folders `src` and `examples`, which are consistent with the [Arduino IDE 1.5 Library Specification](https://arduino.github.io/arduino-cli/0.33/library-specification/) :octicons-link-external-16:.

    ```
    ArduinoJson/
    ├── examples
    │   ├── JsonConfigFile
    │   ├── JsonFilterExample
    │   ├── JsonGeneratorExample
    │   ├── JsonHttpClient
    │   ├── JsonParserExample
    │   ├── JsonServer
    │   ├── JsonUdpBeacon
    │   ├── MsgPackParser
    │   ├── ProgmemExample
    │   └── StringExample
    ├── fuzzing
    ├── scripts
    ├── third-party
    ├── tests
    └── src
        └── ArduinoJson
    ```

    However, the same library also contains the additional folders `fuzzing`, `scripts`, `third-party` and `test`, which may interfere with the normal compilation.

    On a more recent version of this library, the non-standard folders have migrated under the `extras` folder.

As a solution,

+ Zip the non-standard folders.

+ Remove them.

+ Create a new sub-folder `extras` and move the non-standard folders inside.

### Exclude libraries

Some libraries are specific to a platform but are included in a folder shared with other platforms, and some libraries may conflict with other ones.

+ Edit the main `Makefile` and edit the variable `EXCLUDE_LIBS` with the libraries to be excluded.

!!! example

    The `WiFi` library included among the core libraries is solely designed for the `Arduino WiFi Shield`.

    With the Arduino 1.0 and 1.5 IDE, the `WiFi` is included by default in the compilation process, and raises error and warning messages even with the official IDE.

    To exclude the `WiFi` library and avoid any unnecessary error,

    + Mention its name `WiFi` after the variable `EXCLUDE_LIBS`.

    ``` CMake
    # List the libraries to be excluded
    # For example, WiFi may crash on Arduino 1.0.2
    #
    EXCLUDE_LIBS = WiFi
    ```

To use all the libraries,

+ Leave the line empty after the `EXCLUDE_LIBS` variable.

``` CMake
EXCLUDE_LIBS =
```

By default, the `EXCLUDE_LIBS` is empty and the line has a leading `#` to comment it.

The parameter impacts all libraries, core, application, user and local.

## Manage pre-compiled libraries

### Generate a pre-compiled library

Before generating a pre-compiled library from a local library,

+ Check the header and code files are inside a sub-folder.

``` bash
LocalLibrary/
├── library.properties
└── src
    ├── LocalLibrary.cpp
    └── LocalLibrary.h
```

In the example above, `LocalLibrary.h` and `LocalLibrary.cpp` are inside the sub-folder `LocalLibrary`.

To generate a pre-compiled library,

+ Presss ++ctrl+shift+p++ and type `Tasks: Run Task`.

+ Select the **Archive** target and launch it.

``` bash
==== Archive ====
---- Generate ----
7.1-ARCHIVE       LocalLibrary/src/cortex-m0plus
---- Update ----
7.3-ARCHIVE       LocalLibrary/library.properties
==== Archive done ====
```

In the library sub-folder, the new folder `cortex-m0plus` has been created cortex-m0plus to include the new file `LocalLibrary.a`. This is the pre-compiled library.

``` bash
LocalLibrary/
├── library.properties
└── src
    ├── cortex-m0plus
    │   └── libLocalLibrary.a
    ├── LocalLibrary.cpp
    └── LocalLibrary.h
```

The `library.properties` file has been updated with

``` cmake
precompiled=true
ldflags=-lLocalLibrary
```

The folder `cortex-m0plus` is specific for the Cortex-M0+: the pre-compiled library is valid for the board or MCU it has been compiled against. However, it may not work properly on other Cortex-M0+-based MCUs.

For more information,

+ Please refer to the Arduino specifications for [Precompiled binaries](https://arduino.github.io/arduino-cli/0.33/library-specification/#precompiled-binaries) :octicons-link-external-16:.

### Use a pre-compiled library

The pre-compiled user's and local libraries are used the same way as user's and local libraries.

### Share a pre-compiled library

To share the pre-compiled library,

+ Just take the folder with the header files and the pre-compiled library, here `LocalLibrary.h` and `LocalLibrary.a`, along with `library.properties`.

Remember this pre-compiled library is only valid for the board or MCU it has been compiled against. Do not use it with another board or MCU as it may not work properly.

### Remove a pre-compiled library

To remove the pre-compiled libraries,

+ Check the header and code files are inside a sub-folder.

``` bash
LocalLibrary/
├── library.properties
└── src
    ├── cortex-m0plus
    │   └── libLocalLibrary.a
    ├── LocalLibrary.cpp
    └── LocalLibrary.h
```

In the example above, the sub-folder `LocalLibrary` should contain `LocalLibrary.h` and `LocalLibrary.cpp`.

+ Presss ++ctrl+shift+p++ and type `Tasks: Run Task`.

``` bash
==== Unarchive ====
---- Remove ----
7.4-UNARCHIVE     LocalLibrary/src/cortex-m0plus
---- Update ----
7.5-UNARCHIVE     LocalLibrary/library.properties
==== Unarchive done ====
```

+ Select the **Unarchive** target and launch it.

``` bash
LocalLibrary/
├── library.properties
└── src
    ├── LocalLibrary.cpp
    └── LocalLibrary.h
```

The archive `LocalLibrary.a` has been removed and the `library.properties` file has been updated back to its initial content.
