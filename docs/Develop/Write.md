
# Write the project

## Identify the folders and files

The newly created project contains the following folders and files:

``` bash
Template/
├── .builds
├── .vscode
├── LocalLibrary
├── .gitignore
├── Doxyfile.dox
├── main.cpp
├── Makefile
├── ReadMe.md
└── Template.ino
```

+ The folder `.builds` contains the build and link files, and the executables.

+ The folder `.vscode` contains the parameters for Visual Studio Code.

+ The folder `LocalLibrary` contains the `LocalLibrary.h` header and `LocalLibrary.cpp` code for the `LocalLibrary` library. They are provided as example.

+ The file `.gitignore` lists the files and folders to omit for the source control manager Git.

+ The file `Doxyfile.dox` lists the parameters for the documentation generator Doxygen.

+ The file `main.cpp` calls the appropriate core libraries, initialises the board, includes the sketch. The `main()` function calls the `setup()` and `loop()` functions from the sketch. Do not alter this file.

+ The file `Makefile` is the entry for the compilation processes.

+ The file `ReadMe.md` is a notepad in Markdown.

+ The `Template.ino` file is where you write the sketch, with the `setup()` and `loop()` functions and all the additional ones.

The files to edit are the `Template.ino` file for the sketch, the `LocalLibrary.h` header and `LocalLibrary.cpp` code for the `LocalLibrary` library.

A project can only have one `.ino` file, except for multi-threaded platforms.

## Activate version management

To activate the version management,

+ Call the prompt ++ctrl+shift+p++ and then enter **Git: Initialise Repository**.

+ Press ++enter++ to accept the default folder.

The additional folder `.git` is added to the project.

``` bash
Template/
├── .builds
├── .vscode
├── LocalLibrary
├── .git
├── .gitignore
├── Doxyfile.dox
├── main.cpp
├── Makefile
├── ReadMe.md
└── Template.ino
```

## Include Arduino on the main sketch

The main sketch requires to include the Arduino library.

``` cpp
#include "Arduino.h"
```
