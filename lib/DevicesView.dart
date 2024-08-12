import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DevicesView extends StatefulWidget {
  @override
  _DevicesViewState createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    fetchBluetoothDevices();
  }

  void fetchBluetoothDevices() async {
    // Start scanning for Bluetooth devices
    flutterBlue.startScan(timeout: Duration(seconds: 5));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      setState(() {
        devices = results.map((result) => result.device).toList();
      });
    });

    // Stop scanning after timeout
    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(devices[index].name.isEmpty ? 'Unknown Device' : devices[index].name),
          subtitle: Text(devices[index].id.toString()),
          onTap: () {
            // Handle device selection
          },
        );
      },
    );
  }
}
