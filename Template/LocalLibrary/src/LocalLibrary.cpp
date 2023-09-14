//
// LocalLibrary.cpp
// Library C++ code
// ----------------------------------
// Developed with emCode
// https://emCode.weebly.com
//
// Project <#project#>
//
// Created by <#author#>, <#date#>
//
// Copyright <#copyright#>
// Licence <#licence#>
//
// See LocalLibrary.cpp.h and ReadMe.txt for references
//

#include "LocalLibrary.h"

// Code
void blink(uint8_t pin, uint8_t times, uint16_t ms, bool level)
{
    for (uint8_t i = 0; i < times; i++)
    {
        digitalWrite(pin, level ? HIGH : LOW);
        delay(ms >> 1);
        digitalWrite(pin, level ? LOW : HIGH);
        delay(ms >> 1);
    }
}
