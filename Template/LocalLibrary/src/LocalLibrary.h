///
/// @file LocalLibrary.h
/// @brief Library header
///
/// @details <#details#>
/// @n
/// @n @b Project <#project#>
/// @n @a Developed with [emCode](https://emCode.weebly.com)
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


// SDK
#include "Arduino.h"

#ifndef LOCAL_LIBRARY_RELEASE
#define LOCAL_LIBRARY_RELEASE

///
/// @brief Blink a LED
/// @details LED attached to pin is turned on then off
/// @n Total cycle duration = ms
/// @param pin pin to which the LED is attached
/// @param times number of times
/// @param ms cycle duration in ms
/// @param level level for HIGH, default=true=positive logic, false=negative logic
///
void blink(uint8_t pin, uint8_t times, uint16_t ms, bool level = true);

#endif // LOCAL_LIBRARY_RELEASE
