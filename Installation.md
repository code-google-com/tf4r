**Download [tf4r.zip](http://tf4r.googlecode.com/files/tf4r.zip),
  * Unzip,
  * Run the .exe (windows) or go.sh (Linux) or go.command (MAC OS X) (thanks BPzeBanshee)**

### Notes ###

  * You'll need to install _once_ a **JRE** 1.6 (at least the 1.6.0\_21), you can download it [here](http://java.sun.com/javase/downloads/index.jsp)
  * For all the OS, ensure that the _java_ executable is accessible (edit PATH environment variable if not)
  * For MAC users, prefer MAC OS X version 10.6
  * Your system _must_ support [OpenGL 2.0](http://www.realtech-vr.com/glview/download.html), if this not the case, often upgrading your video drivers can solve the issue
  * The game will download _itself_ required game packages _when required_, if you play behind a proxy then you can setup proxy configuration as following:
    * create a file named game.properties in the directory where you extracted go.bat or go.sh
    * add the following lines in this file:
```
http.proxyPort=8080               # proxy port
http.proxyHost=my.proxy.com       # proxy address
http.proxyUsername=proxy_username # proxy username if authentication is needed
http.proxyPassword=proxy_password # proxy password if authentication is needed
```
  * The default setting is full screen for Windows and Linux but windowed for MAC OS X. If you want to change this behaviour just create a file named game.properties in the directory where you extracted go.bat or go.sh or go.command
    * add the following line in this file:
```
fullscreen=true

or

fullscreen=false
```

### Controls ###

#### Keyboard ####
  * arrows to move the ship
  * C to shoot
  * V to change ship speed (_not for the escape capsule_)
  * X to change ship weapon (_not for the escape capsule_)
  * P to pause the game
  * ESC to quit
  * _ENTER to skip some scenes_