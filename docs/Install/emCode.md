
# Install emCode

![](img/Logo-064-eC.png) The **emcode** package includes the tools and a template for the Visual Studio Code projects.

To install emCode,

+ Download and unzip the [emCode package]() :octicons-link-external-16:.

!!! note
    If case emCode is used on Windows Sub-system for Linux, install emCode on the Linux environment.

+ Create the symbolic link `~/.emCode` to the actual location of emCode.

For example, if emCode is located at `~/Projects/emCode`, create the symbolic link with

``` bash
$
ln -s ~/Projects/emCode ~/.emCode
```

The emCode folder contains two sub-folders.

```
emCode
├── Template
└── Tools
    ├── Configurations
    ├── Cores
    └── Makefiles
```

The `Template` sub-folder contains a minimal Visual Studio Code project.

The `Tools` sub-folder contains the configuration files of the boards, the pre-compiled core archives, and the makefiles.

The pre-compiled core archives are generated during the first successful build against a board.

For example, the first successful build and link against the Raspberry Pi Pico RP2040 board with core `3.3.0` generates `Raspberry_Pi_Pico_W_RP2040_MSD_3.3.0.a`.

The following builds go faster as they use the archive.
