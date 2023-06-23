import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arduino Pin Tester',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Arduino Pin Tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UsbPort? _port;
  bool _isConnected = false;
  final Map<int, bool> _pins = {
    for (var item in List.generate(14, (index) => index)) item: false
  };

  @override
  void initState() {
    super.initState();
    _connectToArduino();
  }

  Future<void> _connectToArduino() async {
    if (_isConnected) return;

    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      print('No USB devices found');
      return;
    }

    _port = (await devices[0].create())!;
    bool openResult = await _port!.open();
    if (!openResult) {
      print("Failed to open");
      return;
    }

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    _port!.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
    _isConnected = true;
    print("Connected to Arduino");
  }

  Future<void> _togglePin(int pinNumber) async {
    setState(() {
      _pins[pinNumber] = !_pins[pinNumber]!;
    });

    if (!_isConnected) {
      print("Not connected to Arduino");
      return;
    }

    Uint8List dataToSend =
        Uint8List.fromList(_pins.values.map((e) => e ? 1 : 0).toList());

    await _port!.write(dataToSend);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: GridView.count(
        crossAxisCount: 4, // adjust this number as per your requirements
        children: _pins.keys.map((pin) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () => _togglePin(pin),
              child: Text('Pin $pin\n${_pins[pin]! ? "ON" : "OFF"}'),
            ),
          );
        }).toList(),
      ),
    );
  }
}
