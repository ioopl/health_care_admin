import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceDetailsView extends StatelessWidget {
  final BluetoothDevice device;

  DeviceDetailsView({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Device ID: ${device.id}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await device.connect();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Connected to ${device.name}')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to connect: $e')),
                  );
                }
              },
              child: Text('Connect to Device'),
            ),
            // You can add more functionality here, like discovering services or characteristics.
          ],
        ),
      ),
    );
  }
}
