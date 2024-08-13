import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceDetailsView extends StatefulWidget {
  final BluetoothDevice device;

  DeviceDetailsView({required this.device});

  @override
  _DeviceDetailsViewState createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<DeviceDetailsView> {
  List<BluetoothService> _services = [];
  bool _isConnected = false;

  @override
  void dispose() {
    widget.device.disconnect();
    print('Device disconnected');
    super.dispose();
  }

  Future<void> _connectToDevice() async {
    try {
      await widget.device.connect();
      setState(() {
        _isConnected = true;
      });
      _discoverServices();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: $e')),
      );
    }
  }

  // StreamSubscription? _scanSubscription;
  // StreamSubscription? _deviceConnection;
  // StreamSubscription? _characteristicSubscription;
  // BluetoothDevice? _connectedDevice;
  //
  // Future<void> _connectToDevice2() async {
  //   try {
  //     await widget.device.connect();
  //     _connectedDevice = widget.device;
  //     _deviceConnection = widget.device.state.listen((state) {
  //       print('Connection state: $state');
  //       if (state == BluetoothDeviceState.connected) {
  //         _discoverServices();
  //       } else if (state == BluetoothDeviceState.disconnected) {
  //         print('Device disconnected');
  //       }
  //     });
  //     await _scanSubscription?.cancel();
  //     _scanSubscription = null;
  //   } catch (e) {
  //     print('Error connecting: $e');
  //     rethrow;
  //   }
  // }

  Future<void> _discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    setState(() {
      _services = services;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name.isEmpty ? 'Unknown Device' : widget.device.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _connectToDevice,
              child: Text(_isConnected ? 'Connected' : 'Connect to Device'),
            ),
          ),
          Expanded(
            child: _isConnected ? _buildServiceList() : const Center(child: Text('Press the button to connect')),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text('Service: ${_services[index].uuid}'),
          children: _services[index].characteristics.map((characteristic) {
            return ListTile(
              title: Text('Characteristic: ${characteristic.uuid}'),
              subtitle: Text('Properties: ${characteristic.properties}'),
              onTap: () async {
                var value = await characteristic.read();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Value: $value')),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
