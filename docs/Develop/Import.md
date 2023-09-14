
# Import an existing project

The manual procedure for importing an existing project into an emCode project consists on four steps:

+ [Create an New Project](#create-a-new-project) :octicons-link-16:,
+ [Drag-and-drop headers and code files](#drag-and-drop-headers-and-code-files) :octicons-link-16:,
+ [Copy-paste the main sketch](#copy-paste-the-main-sketch) :octicons-link-16:, and
+ [Check additional parameters](#check-additional-parameters) :octicons-link-16:.

For more information,

+ Please refer to [Manage compatibility with Arduino](../../Issues/Compatibility/) :octicons-link-16:.

## Create a new project

To create a new project,

+ Follow the procedure [Create a new project](../../Develop/New/#create-a-new-project_1) :octicons-link-16:.

## Copy the headers and code files

+ Open the folder with the existing project and the folder with the new emCode project.

+ Select all the files from the exisiting project and copy them into the folder of the new emCode project.

## Update the emCode project

On the new emCode project,

+ Open the main `.ino` sketch;

+ Ensure it includes the pre-processing statements `#include "Arduino.h"`, as it is required by emCode.

For more information,

+ Please refer to [Include core library on main sketch](../../Issues/Compatibility/#include-core-library-on-main-sketch) :octicons-link-16:.

Then,

+ Open the main `Makefile` of the new emCode project;

+ Change the value of the `PROJECT_NAME_AS_IDENTIFIER` variable with the name of the main `.ino` sketch.

``` CMake
# C-compliant project name
PROJECT_NAME_AS_IDENTIFIER = MyProject
```

+ Add all the required libraries, `APP_LIBS_LIST`, `USER_LIBS_LIST` and `LOCAL_LIBS_LIST`.

For more information on libraries,

+ Please refer to [List all the used libraries in main `Makefile`](../../Issues/Compatibility/#list-all-the-used-libraries-in-main-makefile) :octicons-link-16:.

## Check additional parameters

Depending on the project, some additional steps might be required.

+ If functions are called before they are defined, declare prototypes for them.

For more information on prototypes,

+ Please refer to [Declare functions prototypes on main sketch](../../Issues/Compatibility/#declare-functions-prototypes-on-main-sketch) :octicons-link-16:.

For more information about the compatibility between the standard Arduino IDE and emCode,

+ Please refer to section [Manage compatibility with standard IDEs](../../Issues/Compatibility) :octicons-link-16:.
