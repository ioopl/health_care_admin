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
          title: Text('Service: ${getServiceName(_services[index].uuid.toString())} (${_services[index].uuid})'),
          children: _services[index].characteristics.map((characteristic) {
            return ListTile(
              title: Text('Characteristic: ${characteristic.uuid}'),
              subtitle: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _buildPropertyBubbles(characteristic.properties),
              ),
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

  List<Widget> _buildPropertyBubbles(CharacteristicProperties properties) {
    List<Widget> bubbles = [];

    if (properties.read != null) {
      bubbles.add(_buildPropertyBubble('Read', properties.read));
    }
    if (properties.write != null) {
      bubbles.add(_buildPropertyBubble('Write', properties.write));
    }
    if (properties.notify != null) {
      bubbles.add(_buildPropertyBubble('Notify', properties.notify));
    }
    if (properties.indicate != null) {
      bubbles.add(_buildPropertyBubble('Indicate', properties.indicate));
    }
    // Add more properties as needed

    return bubbles;
  }

  Widget _buildPropertyBubble(String label, bool value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: value ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Map<String, String> serviceNames = {
    "00001800-0000-1000-8000-00805f9b34fb": "Generic Access",
    "00001801-0000-1000-8000-00805f9b34fb": "Generic Attribute",
    "0000180d-0000-1000-8000-00805f9b34fb": "Heart Rate",
    "0000180f-0000-1000-8000-00805f9b34fb": "Battery Service",
  };

  String getServiceName(String uuid) {
    return serviceNames[uuid] ?? "Unknown Service";
  }

  // With Rounded small circle bubbles
  // List<Widget> _buildPropertyWidgets(CharacteristicProperties properties) {
  // print('properties : $properties');
  // debugPrint(properties.toString());
  //
  //   List<Widget> widgets = [];
  //
  //   if (properties.read == true) {
  //     widgets.add(_buildPropertyCircle('Read', Colors.blue));
  //   }
  //   if (properties.write) {
  //     widgets.add(_buildPropertyCircle('Write', Colors.green));
  //   }
  //   if (properties.notify) {
  //     widgets.add(_buildPropertyCircle('Notify', Colors.red));
  //   }
  //   if (properties.indicate) {
  //     widgets.add(_buildPropertyCircle('Indicate', Colors.orange));
  //   }
  //   if (properties.broadcast) {
  //     widgets.add(_buildPropertyCircle('Broadcast', Colors.yellow));
  //   }
  //   if (properties.writeWithoutResponse) {
  //     widgets.add(_buildPropertyCircle('Write Without Response', Colors.black));
  //   }
  //   if (properties.extendedProperties) {
  //     widgets.add(_buildPropertyCircle('Extended Properties', Colors.purple));
  //   }
  //   if (properties.authenticatedSignedWrites) {
  //     widgets.add(_buildPropertyCircle('Authenticated Signed Writes', Colors.grey));
  //   }
  //
  //   return widgets;
  // }
  //
  // Widget _buildPropertyCircle(String label, Color color) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 5),
  //     padding: EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: color,
  //       shape: BoxShape.circle,
  //     ),
  //     child: Center(
  //       child: Text(
  //         label,
  //         style: TextStyle(color: Colors.white, fontSize: 12),
  //       ),
  //     ),
  //   );
  // }

}
