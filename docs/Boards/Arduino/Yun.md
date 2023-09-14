---
tags:
    - Legacy
---

# Manage the Arduino Y&uacute; boards

## Upload to Arduino Y&uacute;n using Ethernet or WiFi

![](img/Logo-064-Arduino-IDE.png) Although the Arduino Y&uacute;n requires no specific procedure, the Ethernet or WiFi network needs to be installed and configured successfully before any upload, and the RSA key fingerprint of the Arduino Y&uacute;n needs to be known by the Mac.

+ Check that the router has discovered the Arduino Y&uacute;n and note the IP address.

+ Check the Mac knows the RSA key fingerprint of the Arduino Y&uacute;n.

+ Also, keep the password of the Arduino Y&uacute;n at hand.

+ Disconnect all the SPI devices from the ICSP connector as the WiFi module uses SPI to communicate with the Arduino.

It is recommended to proceed with a test of the over-the-air upload with the Arduino IDE, through Ethernet or WiFi, to be sure that the Mac recognises the board and knows the RSA key fingerprint of the Arduino Y&uacute;n.

### Check the SSH connection

To check the router has discovered the Arduino Y&uacute;n,

+ Open a **Terminal** window.

+ Type the command `arp -a` to list all know hosts.

The Arduino Y&uacute;n board should appear as `arduino.local` but often has a different name, as `host-001`.

The default address should be `192.168.240.1` but may differ according to the settings of the network.

To check the Mac knows the RSA key fingerprint of the board,

+ Open a **Terminal** window and type the command `ssh root@` followed by the IP address of the board, `192.168.240.1` in the example.

``` bash
$ ssh root@192.168.240.1
```

If the board is unknown, a message asks for confirmation of the RSA key fingerprint.

```
The authenticity of host '192.168.240.1 (192.168.240.1)' can't be established.
RSA key fingerprint is 00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff.
Are you sure you want to continue connecting (yes/no)? yes
```

+ Enter `yes` and validate.

A message confirms the RSA key fingerprint has been added to the list of know hosts.

```
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.240.1' (RSA) to the list of known hosts.

root@192.168.240.1's password:
```

+ Finally, type in the password to make the connection.

``` bash
BusyBox v1.19.4 (2013-08-07 16:16:02 CEST) built-in shell (ash)
Enter 'help' for a list of built-in commands.

root@Arduino:~#
```

The **Terminal** window s displays the splash screen of the Arduino Y&uacute;n.

```
BusyBox v1.19.4 (2014-04-10 11:08:41 CEST) built-in shell (ash)
Enter 'help' for a list of built-in commands.

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 ----------------------------------------------------
```

### Enter IP address and Password

During the first compilation, embedXcode looks for the Arduino Y&uacute;n board and checks the password.

If the Arduino board isn't found on the network, a window asks for the IP address.

<center>![](img/334-01-360.png)</center>

+ Enter the IP address of the Arduino Y&uacute;n board.

+ Click on **OK** to validate or **Cancel** to cancel.

A message box asks for the password.

<center>![](img/334-02-360.png)</center>

+ Enter the password of the Arduino Y&uacute;n board.

+ Click on **OK** to validate or **Cancel** to cancel.

When validated, the IP address and the password are saved on the board configuration file `Arduino Y&uacute;n (WiFi Ethernet)` in the project.

<center>![](img/334-03-360.png)</center>

The IP address and the password are only asked once.

+ To erase the IP address, just delete the whole line.

+ To edit the IP address, just change the left part after `SSH_ADDRESS =` on the corresponding line.

!!! warning
    The password is not encrypted.

+ To erase the password, just delete the whole line.

+ To edit the password, just change the left part after `SSH_PASSWORD =` on the corresponding line.

For more information about the Arduino Y&uacute;n installation and over-the-air upload,

+ Please refer to the [Guide to the Arduino Y&uacute;n](http://arduino.cc/en/Guide/ArduinoYun) :octicons-link-external-16: on the Arduino website.

### Upload the sketch

Once the checks have been successfully performed, proceed as follow:

+ Connect the Arduino Y&uacute;n board to the network through WiFi or Ethernet.

+ Launch any of the targets **All**, **Upload** or **Fast**.

### Upload a website to the Arduino Y&uacute;n

embedXcode can upload a website automatically to the Arduino Y&uacute;n.

There are three requirements. First, upload is done through Ethernet or WiFi connection. Second, the project has a folder named `www` with at least a file named `index.html`. Third, the Arduino Y&uacute;n has a microSD-card inserted on the slot.

During upload, the content of the www folder is copied to the microSD-card automatically and made available with a browser at the address `/sd/TemperatureWebPanel`.

Once upload is completed, embedXcode open the browser at the website main page.

The `TemperatureWebPanel` project contains a `www` folder.

<center>![](img/336-02-300.png)</center>

For more information,

+ Please refer to the [Temperature Web Panel](http://arduino.cc/en/Tutorial/TemperatureWebPanel) :octicons-link-external-16: at the Arduino main website, and to the page [Introduction to Web Server](http://scuola.arduino.cc/lesson/b4EoRkV/Arduino_Yn_Intro_to_web_server) :octicons-link-external-16: and the project [Sensor Values to HTML Page](http://scuola.arduino.cc/lesson/zzdeJ3m/YunServer_Sensor_values_to_HTML_page) :octicons-link-external-16: at the Arduino Scuola website.
