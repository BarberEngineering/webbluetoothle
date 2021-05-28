@JS()
library webble;

import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:js_util';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

// In webbluetoothle.js
@JS()
external Future checkBleHardware();

// In webbluetoothle.js
@JS()
external connectBleDevice();

// in webbluetoothle.js
@JS()
external getBatteryLevel();

// Debugging, can remove
@JS('JSON.stringify')
external String stringify(Object obj);

// Allows function to be callable from JS like `window.bytesReceived("DATA");`
@JS('bytesReceived')
external set _bytesReceived(void Function(ByteData) f);

// Allows function to be callable by Dart as well
@JS()
external void bytesReceived();

void _bytesReceivedHandler(ByteData s) {
  Uint8List bytesFromJS = s.buffer.asUint8List(0, s.lengthInBytes);

  print("input from JS: ${bytesFromJS.toString()}");
}

/// A web implementation of the Webbluetoothle plugin.
class BluetoothLEWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'webbluetoothle',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = BluetoothLEWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Function _bytesReceived = allowInterop(_bytesReceivedHandler);

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
      // case 'getPayloadBytes':
      //   return getPayloadBytes();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'webbluetoothle for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }

  // Returns true/ false
  Future<bool> isHardwareEnabled() async {
    var t = await checkBleHardware();
    final Future<bool> res = promiseToFuture(t);
    final bs = await res;

    print("BT Hardware is: $bs");
    return bs;
  }

  Future<int> getBattLevel() async {
    var t = await getBatteryLevel();
    final Future<int> res = promiseToFuture(t);
    return res;
  }

  // void stopListening() {
  //   // Stop JS
  //   stopListener();
  // }

  Future<dynamic> connectDevice() async {
    var t = await connectBleDevice();
    final res = promiseToFuture(t);
    final out = await res;

    return out;
  }
}
