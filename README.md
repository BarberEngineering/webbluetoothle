# webbluetoothle

This is NOT a fully fleshed out solution. Don't use this in production. This is a very early proof of concept and is not nearly complete.

I wanted to release it because I've seen others wanting to use bluetooth with Flutter Web and since there are a lot better coders out there than me I hope they add PR's and help flesh out the solution further.

See /example/ folder (run with Chrome, aka Flutter Web) for demo that will let you see battery level via BT

# What works?
- Detects if a PC has a bluetooth chipset (true/false)
- Clicking 'Select Device' (in /example) will show a list of devices (scan) and if the device conforms to the Bluetooth spec for battery_level, it will return it's battery level. (Works with iPhone/iPad)

# What doesn't work?
- Everything else.. I haven't added in functions to add filters or made the code reusable. It's a proof of concept.
- Accepting PR's for anything not working or GitHub sponsor funds for further work :)

## Architecture Overview
Flutter has the capability (via js/js.dart) to run Javascript "natively" in it's underlying engine.

This plugin uses that capability to call the Web Bluetooth API's present in Chrome & Firefox then pass data back to Dart where it can be used with Flutter

The 'webbluetoothle_web.dart' (and BluetoothLEWeb class) contain the main Dart interface
to the underlying javascript file (web/webbluetooth.js).

The idea is to keep everything passing through webbluetoothle_web.dart rather than have higher level functions deal with transcoding JS to Dart and back.

## Pieces & Parts
- webbluetoothle.js -> contains javascript functions that call the Web Bluetooth API present in Chrome/FF
- webbluetoothle_web.dart -> contains Dart functions that call the JS functions in webbluetoothle.js

## But X doesn't work!

I know - this is a proof of concept

### Links
Great resource for understanding the Web Bluetooth interactions
[Web.dev] (https://web.dev/bluetooth/)

Awesome detail from the Chrome team w/examples for JS
[Google Chrome Git Hub] (https://googlechrome.github.io/samples/web-bluetooth/index.html)