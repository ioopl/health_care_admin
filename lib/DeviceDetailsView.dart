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
  void initState() {
    super.initState();
    _connectToDevice();
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

  Future<void> _discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    setState(() {
      _services = services;
    });
  }

  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name.isEmpty ? 'Unknown Device' : widget.device.name),
      ),
      body: _isConnected ? _buildServiceList() : Center(child: CircularProgressIndicator()),
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
