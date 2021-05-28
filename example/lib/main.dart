import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webbluetoothle/webbluetoothle.dart';
import 'package:webbluetoothle/webbluetoothle_web.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String hardwareStatusText = 'Unknown';
  String batteryPercentText = '0%';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await WebBluetoothLE.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Web Bluetooth'),
            ),
            body: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 350,
                    child: Card(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.hardware),
                          title: Text('Bluetooth Hardware Status'),
                          subtitle: Text(hardwareStatusText),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.youtube_searched_for),
                                onPressed: () async {
                                  var g = await BluetoothLEWeb()
                                      .isHardwareEnabled();
                                  if (g) {
                                    setState(() {
                                      hardwareStatusText = 'Hardware Found';
                                    });
                                  } else {
                                    setState(() {
                                      hardwareStatusText = 'Hardware Not Found';
                                    });
                                  }
                                  // debug print to Chrome Devtools (F12 in Browser)
                                  print('ble: $g');
                                },
                                label: Text('Check Hardware'),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  width: 350,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.bluetooth),
                          title: Text('Device Battery Level'),
                          subtitle: Text(batteryPercentText),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.assistant_direction),
                                onPressed: () async {
                                  setState(() {
                                    batteryPercentText = 'Analyzing...';
                                  });

                                  var device =
                                      await BluetoothLEWeb().connectDevice();
                                  if (device.toString().contains('Error')) {
                                    setState(() {
                                      batteryPercentText = 'Device says no';
                                    });
                                    return;
                                  }
                                  var msg =
                                      await BluetoothLEWeb().getBattLevel();
                                  setState(() {
                                    batteryPercentText = msg.toString() + '%';
                                  });
                                },
                                label: Text('Select Device'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
