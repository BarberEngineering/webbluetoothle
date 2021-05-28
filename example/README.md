# webbluetoothle_example

Demonstrates how to use the webbluetoothle plugin.

## General Architecture

Flutter has the capability (via js/js.dart) to run Javascript "natively" in it's underlying engine.

This plugin uses that capability to call the Web Bluetooth API's present in Chrome & Firefox then pass data back to Dart where it can be used with Flutter

The 'webbluetoothle_web.dart' (and BluetoothLEWeb class) contain the main Dart interface 
to the underlying javascript file (web/webbluetooth.js). 

The idea is to keep everything passing through webbluetoothle_web.dart rather than have higher level functions deal with transcoding JS to Dart and back.


### Links
Great resource for understanding the Web Bluetooth interactions
[Web.dev] (https://web.dev/bluetooth/)

Awesome detail from the Chrome team w/examples for JS
[Google Chrome Git Hub] (https://googlechrome.github.io/samples/web-bluetooth/index.html)
