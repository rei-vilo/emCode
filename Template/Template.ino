///
/// @mainpage Template for emCode
///
/// @file
/// @details Template for emCode
///
/// @author <#author#>
///
/// @date <#date#>
/// @version <#version#>
///
/// @copyright <#copyright#>
/// @copyright <#licence#>
///
/// @see ReadMe.md for references
///

///
/// @file template.ino
/// @brief Main sketch
///
//

// SDK
#include "Arduino.h"

// Other libraries
#include "LocalLibrary.h"

///
/// @brief LED pin
///
// #define LED_BUILTIN 2
#define myLED LED_BUILTIN

///
/// @brief Setup
///
void setup(void)
{
    pinMode(myLED, OUTPUT);
    Serial.begin(115200);
    delay(100);
}

/// @brief Loop
///
void loop(void)
{
    Serial.println(millis());
    blink(myLED, 3, 333, false);
    delay(1000);
}
