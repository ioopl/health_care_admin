import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

import 'DeviceDetailsView.dart';

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
    requestPermissions().then((_) {
      fetchBluetoothDevices();
    });
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.location]!.isGranted) {
      fetchBluetoothDevices();
    } else {
      // Handle the case where permissions are not granted
      showError();
    }
  }

  void showError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bluetooth Permissions required"),
        content: const Text("Bluetooth and location permissions are needed to scan for devices.\n Bluetooth services might be turned Off or A scan is already in progress.."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // void requestLocationPermission() async {
  //   PermissionStatus status = await Permission.location.request();
  //   if (status.isGranted) {
  //     // Proceed with Bluetooth scanning
  //     fetchBluetoothDevices();
  //   } else if (status.isDenied) {
  //     // Permission denied, handle accordingly
  //   } else if (status.isPermanentlyDenied) {
  //     // Open app settings to allow user to enable the permission
  //     openAppSettings();
  //   }
  // }

  void fetchBluetoothDevices() async {
    bool isScanning = await flutterBlue.isScanning.first;

    if (!isScanning) {
      flutterBlue.startScan(timeout: const Duration(seconds: 5));

      flutterBlue.scanResults.listen((results) {
        setState(() {
          devices = results.map((result) => result.device).toList();
        });
      });

      flutterBlue.stopScan();
    } else {
      showError();
    }
  }

  void _showDeviceDetails(BluetoothDevice device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsView(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(devices[index].name.isEmpty ? 'Unknown Device' : devices[index].name),
          subtitle: Text(devices[index].id.toString()),
          onTap: () => _showDeviceDetails(devices[index]),
        );
      },
    );
  }
}

