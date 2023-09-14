---
tags:
    - Active
---

# Manage the STM32duino boards

**STM32duino** supports a wide range of STM32-based boards.

For an exact list of the supproted boards,

+ Please refer to the list of [Supported boards](https://github.com/stm32duino/Arduino_Core_STM32#supported-boards) :octicons-link-external-16:.

## Install

To install the STM32 boards,

+ Ensure the Arduino tools, CLI or IDE, are installed.

+ Ensure the `arduino-cli.yaml` configuration file for Arduino-CLI or the **Additional boards manager URLs** for Arduino IDE includes

``` json
https://github.com/stm32duino/BoardManagerFiles/raw/main/package_stmicroelectronics_index.json
```

+ Open a **Terminal** window.

+ Run

``` bash dollar
arduino-cli core install STMicroelectronics:stm32
```

For more information,

+ Please refer to the [Getting Started](https://github.com/stm32duino/wiki/wiki/Getting-Started) :octicons-link-external-16: page and the [Add STM32 boards support to Arduino](https://github.com/stm32duino/wiki/wiki/Getting-Started#add-stm32-boards-support-to-arduino) :octicons-link-external-16: section on the GitHub repository.

### Install the uploader and debugger utilities

STMicroelectronics recommends **ST-Link**, part of the  [STM32CubeProgrammer software for all STM32](https://www.st.com/en/development-tools/stm32cubeprog.html) :octicons-link-external-16: package. However, it requires Java.

+ Download and install **STM32CubeProgrammer**.

To update the PATH environmnent variable,

+ Open `.bashrc`.


``` bash dollar
nano ~/.bashrc
```

+ Add

``` bash
export PATH=$PATH:~/Applications/STM32CubeProgrammer/bin
```

+ Save and close with ++ctrl+o++ ++ctrl+x++.

Two open-source alternatives include **OpenOCD** for Open On-Chip Debugger, the **Arduino Tools** from STM3232duino, and **Texane ST-Link**, a native version of the STMicroelectronics ST-Link tools.

Please refer to

+ [Install the OpenOCD driver](../../Install/Section4/#install-the-openocd-driver);

+ [STM3232duino Arduino Tools](https://github.com/stm32duino/Arduino_Tools) :octicons-link-external-16: with the upload tools for the STM32-based boards and some other usefull scripts;

+ [Install the Texane ST-Link driver](../../Install/Section4/#install-the-texane-st-link-driver).

### Update the firmware of the boards

The application **STLinkUpgrade** updates the firmware of the ST-Link, ST-Link/V2 and ST-Link/V2-1 boards through the USB port. It requires the Java Runtime Environment.

+ Download the [STSW-LINK007 package](https://www.st.com/content/st_com/en/products/development-tools/software-development-tools/stm32-software-development-tools/stm32-programmers/stsw-link007.html) :octicons-link-external-16:.

+ Install the **STLinkUpgrade** application.

+ Connect the board and launch the application.

<center>![](img/135-01-640.png)</center>

For more information on the firmware upgrade for ST-Link, ST-Link/V2, ST-Link/V2-1 and ST-Link-V3 boards,

+ Please refer to the [RN0093 Release note](https://www.st.com/content/ccc/resource/technical/document/release_note/98/de/c7/1b/08/82/44/38/DM00107009.pdf/files/DM00107009.pdf/jcr:content/translations/en.DM00107009.pdf) :octicons-link-external-16:.

## Develop

### Manage old versions of boards

STM32duino release 2.6.0 manages correctly the system clock, even for old versions of the boards.

Prior releases of STM32duino may need adding a specific clock function for old versions of the boards.

+ Just add on the main sketch the `SystemClock_Config()`.

``` cpp
extern "C" void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {};

  /* Configure the main internal regulator output voltage */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE2);
  /* Initializes the CPU, AHB and APB busses clocks */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 8;
  RCC_OscInitStruct.PLL.PLLN = 336;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
  RCC_OscInitStruct.PLL.PLLQ = 7;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK) {
    Error_Handler();
  }
  /* Initializes the CPU, AHB and APB busses clocks */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
                                | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK) {
    Error_Handler();
  }
}
```

For more information,

+ Please refer to [Arduino_Core_STM32 version 1.9.0 regression? #1315](https://github.com/stm32duino/Arduino_Core_STM32/issues/1315) :octicons-link-external-16: on the STM32duino repository.

## Debug

+ Edit the `launch.json` file to add the configuration for the board.

??? example

    The example below targets the Nucleo-64 STM32F401R board.

    ``` JSON
    {
        "version": "0.2.0",
        "configurations": [
            {
                "type": "cortex-debug",
                "request": "launch",
                "name": "STM32F401 OpenOCD",
                "servertype": "openocd",
                "cwd": "${workspaceRoot}",
                "executable": "${workspaceRoot}/.builds/embeddedcomputing.elf",
                "gdbPath": "/usr/bin/gdb-multiarch",
                "configFiles": [
                    "board/st_nucleo_f4.cfg"
                ],
                "preLaunchTask": "Fast"
            }
        ]
    }
    ```
   
