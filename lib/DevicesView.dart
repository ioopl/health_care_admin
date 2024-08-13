import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
    fetchBluetoothDevices();
  }

  void fetchBluetoothDevices() async {
    flutterBlue.startScan(timeout: Duration(seconds: 5));

    flutterBlue.scanResults.listen((results) {
      setState(() {
        devices = results.map((result) => result.device).toList();
      });
    });

    flutterBlue.stopScan();
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

// class DeviceDetailsView extends StatelessWidget {
//   final BluetoothDevice device;
//
//   DeviceDetailsView({required this.device});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Device ID: ${device.id}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement connection logic here
//               },
//               child: Text('Connect to Device'),
//             ),
//             // Add more buttons or information as needed
//           ],
//         ),
//       ),
//     );
//   }
// }
