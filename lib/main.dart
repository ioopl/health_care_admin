import 'package:flutter/material.dart';

import 'DevicesView.dart';

void main() => runApp(const AdminViewApp());

class AdminViewApp extends StatelessWidget {
  const AdminViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AdminViewScreen(),
    );
  }
}

class AdminViewScreen extends StatefulWidget {
  const AdminViewScreen({super.key});

  @override
  _AdminViewScreenState createState() => _AdminViewScreenState();
}

class _AdminViewScreenState extends State<AdminViewScreen> {
  int _selectedIndex = 2;
  String? _selectedPatient;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedPatient = null;  // Reset the selected patient when changing sidebar items
    });
  }

  void _onPatientSelected(String patient) {
    setState(() {
      _selectedPatient = patient;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = DevicesView();
        break;
      case 2:
        content = Row(
          children: [
            Expanded(
              flex: 2,
              child: PatientList(
                onPatientSelected: _onPatientSelected,
                selectedPatient: _selectedPatient,
              ),
            ),
            Expanded(
              flex: 3,
              child: _selectedPatient == null
                  ? const Center(child: Text('Select a Device to see details'))
                  : PatientDetails(patient: _selectedPatient!),
            ),
          ],
        );
        break;
      default:
        content = const EmptyView();
    }

    return Scaffold(
      body: Column(
        children: [
          const HeaderLogoView(),
          Expanded(
            child: Row(
              children: [
                Sidebar(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
                Expanded(flex: 2, child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  Sidebar({required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(40), // Adjust the value as needed
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.grid_view, color: selectedIndex == 0 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(0),
          ),
          // IconButton(
          //   icon: Icon(Icons.calendar_today, color: selectedIndex == 1 ? Colors.pink : Colors.white),
          //   onPressed: () => onItemTapped(1),
          // ),
          IconButton(
            icon: Icon(Icons.bar_chart, color: selectedIndex == 2 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(2),
          ),
          // IconButton(
          //   icon: Icon(Icons.notifications, color: selectedIndex == 3 ? Colors.pink : Colors.white),
          //   onPressed: () => onItemTapped(3),
          // ),
          // IconButton(
          //   icon: Icon(Icons.settings, color: selectedIndex == 4 ? Colors.pink : Colors.white),
          //   onPressed: () => onItemTapped(4),
          // ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'), // Profile image
          ),
          // IconButton(
          //   icon: Icon(Icons.share, color: selectedIndex == 5 ? Colors.pink : Colors.white),
          //   onPressed: () => onItemTapped(5),
          // ),
        ],
      ),
    );
  }
}

class PatientList extends StatelessWidget {
  final Function(String) onPatientSelected;
  final String? selectedPatient;

  PatientList({required this.onPatientSelected, required this.selectedPatient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(40), // Adjust the value as needed
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a patient',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: List.generate(7, (index) {
                String patient = 'Device Name $index';
                bool isSelected = patient == selectedPatient;
                return Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(1), // Adjust if needed
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile3.png'), // Patient image
                    ),
                    title: Text(
                      patient,
                      style: TextStyle(color: isSelected ? Colors.black : Colors.black87),
                    ),
                    subtitle: const Text('Apple'),
                    onTap: () => onPatientSelected(patient),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class PatientDetails extends StatelessWidget {

  final String patient;

  const PatientDetails({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Added SingleChildScrollView here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'), // Patient image
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patient, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),// Patient Name
                      const Text('Google', style: TextStyle(fontSize: 15, color: Colors.grey)), // Patient Location
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('A', style: TextStyle(fontSize: 15, color: Colors.grey)), // Heart rate info
                      Text('72', style: TextStyle(fontSize: 21)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('B', style: TextStyle(fontSize: 15, color: Colors.grey)), // Weight Info
                      Text('56', style: TextStyle(fontSize: 21)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(), // Added a divider
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('S', style: TextStyle(fontSize: 15, color: Colors.grey)), // Systolic pressure info
                      Text('132', style: TextStyle(fontSize: 21)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('D', style: TextStyle(fontSize: 15, color: Colors.grey)), // Diastolic pressure info
                      Text('88', style: TextStyle(fontSize: 21)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Events info
              SizedBox(
                height: 200, // Provide a fixed height to the ListView
                child: ListView(
                  shrinkWrap: true, // Added to ensure ListView does not take infinite height
                  children: List.generate(8, (index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date'),
                                  Text('20 Jul 2024'),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('19:56'),
                              Text('1 x Session'),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Content Available',
        style: TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HeaderLogoView extends StatelessWidget {
  const HeaderLogoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png', // Update with your logo image path
            height: 40,
          ),
          const SizedBox(width: 16),
          const Text(
            'IoT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}