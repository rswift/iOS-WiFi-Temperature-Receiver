# iOS WiFi Temperature Receiver

This is a mindnumbingly simple application, linked directly to my version of the project inspired by Roasthacker to capture and broadcast the bean mass temperature from my 
Gene Café CBR-101 coffee roaster. The ultimate goal is to feed these temperatures into the Roastmaster Data Logger for hands-free temperature capture directly on the iPad...

The payload bring broadcast by the Adafruit board is formatted as JSON, the code here is not well structured, but proves a point, so I've not abstracted anything away...

It relies on SwiftSocket, which isn't the most fully featured or robut socket framework, but it was quick to integrate, is simple, and worked without fuss... I'm not distributing SwiftSocket but I just copied down the files from the ysocket directory

This code is issued under the "Bill and Ted - be excellent to each other" licence (which has no content, just, well, be excellent to each other), however, I have included the licence files from my original starting file (serialthermocouple.ino) at the bottom of this sketch...

I'm not a very experienced Xcode developer so I am quite sure I've made dozens of mistooks with this, but it is a proof-of-concept, nothing more, so whilst I fully expect to be judged, I won't take it personally :)

This was built on iOS 9 in Xcode 7.3, works a treat.

The JSON payload is simple, I posted to the Roastmaster Forum with my thoughts, I fully expect far more development of the payload before it is actually useful. It is kept simple:
- the probe name
- the temperature in celsius
- the temperature in farhenheit
- optionally an array of debug data which isn't worth describing here so check the WiFiTemperatureBroadcast.ino file for details

# ToDo
- nothing really, this was a proof of concept, although there is a tremendous amount that could be improved

# Some links
Broadcast app for ESP8266: https://github.com/rswift/wifi-temperature-broadcast/blob/master/WiFiTemperatureBroadcast.ino
Roasthacker: http://roasthacker.com/?p=529 & http://roasthacker.com/?p=552
SwiftSocket: https://github.com/swiftsocket/SwiftSocket
ysocket files I copied into Xcode: https://github.com/swiftsocket/SwiftSocket/tree/master/SwiftSocket/ysocket
Roastmaster forum: https://rainfroginc.com/frogpad/index.php?topic=154.0

The icon is a hack of two icons downloaded from www.flaticon.com, the WiFi symbol was made by SimpleIcon and can be found here http://www.flaticon.com/free-icon/wifi-medium-signal-symbol_34143 and the thermometer icon was made by Freepik and can be found here http://www.flaticon.com/free-icon/thermometer-2svg_124971 both icons are used under the Creative Commons BY 3.0 licence which can be found here https://creativecommons.org/licenses/by/3.0/ and obviously if anyone wants to develop this work further, please ensure the original creators are linked, otherwise, not cool...

Robert Swift - June 2016
