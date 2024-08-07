import 'package:flutter/material.dart';

void main() => runApp(AdminViewApp());

class AdminViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminViewScreen(),
    );
  }
}

class AdminViewScreen extends StatefulWidget {
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
    return Scaffold(
      body: Column(
        children: [
          HeaderLogoView(),
          Expanded(
            child: Row(
              children: [
                Sidebar(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
                Expanded(
                  flex: 2,
                  child: _selectedIndex == 2
                      ? PatientList(
                    onPatientSelected: _onPatientSelected,
                    selectedPatient: _selectedPatient,
                  )
                      : _selectedIndex == 0
                      ? DevicesView()
                      : EmptyView(),
                ),
                if (_selectedIndex == 2)
                  Expanded(
                    flex: 3,
                    child: _selectedPatient == null
                        ? const Center(child: Text('Select a patient to see details'))
                        : PatientDetails(patient: _selectedPatient!),
                  ),
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
          IconButton(
            icon: Icon(Icons.calendar_today, color: selectedIndex == 1 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(1),
          ),
          IconButton(
            icon: Icon(Icons.bar_chart, color: selectedIndex == 2 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(2),
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: selectedIndex == 3 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(3),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: selectedIndex == 4 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(4),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'), // Profile image
          ),
          IconButton(
            icon: Icon(Icons.share, color: selectedIndex == 5 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(5),
          ),
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
                prefixIcon: Icon(Icons.search),
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
                String patient = 'Patient Name $index';
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
                    subtitle: const Text('Manchester City, UK'),
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


// class PatientList extends StatelessWidget {
//   final Function(String) onPatientSelected;
//   final String? selectedPatient;
//
//   PatientList({required this.onPatientSelected, required this.selectedPatient});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(40), // Adjust the value as needed
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search for a patient',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               children: List.generate(7, (index) {
//                 String patient = 'Patient Name $index';
//                 bool isSelected = patient == selectedPatient;
//                 return ListTile(
//                   leading: const CircleAvatar(
//                     backgroundImage: AssetImage('assets/images/profile3.png'), // Patient image
//                   ),
//                   title: Text(patient),
//                   subtitle: const Text('Manchester City, UK'),
//                   selected: isSelected,
//                   selectedTileColor: Colors.pink[50],
//                   onTap: () => onPatientSelected(patient),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class PatientDetails extends StatelessWidget {
  final String patient;

  PatientDetails({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'), // Detail image
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Manchester City, UK', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Heart rate', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('72 bpm', style: TextStyle(fontSize: 24)),
                ],
              ),
              Column(
                children: [
                  Text('Weight', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('56 kg', style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Systolic pressure', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('132 mmHg', style: TextStyle(fontSize: 24)),
                ],
              ),
              Column(
                children: [
                  Text('Diastolic pressure', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('88 mmHg', style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: List.generate(8, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Medication time'),
                              Text('20 Jul 2024'),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('19:56'),
                          Text('1 x Prozac pill'),
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
    );
  }
}

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Content Available',
        style: TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DevicesView extends StatefulWidget {
  @override
  _DevicesViewState createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  final List<Device> devices = [
    Device(name: 'Alexa 1', status: 'Connected', imageUrl: 'assets/images/alexa.webp', chargeStatus: '75%'),
    Device(name: 'Ring', status: 'Connected', imageUrl: 'assets/images/ring.jpeg', chargeStatus: '11%'),
    Device(name: 'Fitbit', status: 'Connected', imageUrl: 'assets/images/fitbit.webp', chargeStatus: '15%'),
    Device(name: 'Navbar Device', status: 'Connected', imageUrl: 'assets/images/navbar.jpg', chargeStatus: '99%'),
  ];


  void toggleConnection(int index) {
    setState(() {
      devices[index].toggleConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    device.imageUrl, // Device image
                    height: 101,
                  ),
                  Text(
                    device.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    device.chargeStatus,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                  Text(
                    device.status,
                    style: TextStyle(fontSize: 15, color: device.status == 'Connected' ? Colors.green : Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleConnection(index);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: Text(device.status == 'Connected' ? 'Disconnect' : 'Connect'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Device {
  final String name;
  final String chargeStatus;
  final String imageUrl;
  String status;

  Device({required this.name, required this.chargeStatus, required this.status, required this.imageUrl});

  void toggleConnection() {
    status = (status == 'Connected') ? 'Disconnected' : 'Connected';
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
            'Patients list',
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


// Very good code before the DevicesView
// import 'package:flutter/material.dart';
//
// void main() => runApp(AdminViewApp());
//
// class AdminViewApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AdminViewScreen(),
//     );
//   }
// }
//
// class AdminViewScreen extends StatefulWidget {
//   @override
//   _AdminViewScreenState createState() => _AdminViewScreenState();
// }
//
// class _AdminViewScreenState extends State<AdminViewScreen> {
//   int _selectedIndex = 2;
//   String? _selectedPatient;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       _selectedPatient = null;  // Reset the selected patient when changing sidebar items
//     });
//   }
//
//   void _onPatientSelected(String patient) {
//     setState(() {
//       _selectedPatient = patient;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           Sidebar(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
//           Expanded(
//             flex: 2,
//             child: PatientList(
//               onPatientSelected: _onPatientSelected,
//               selectedPatient: _selectedPatient,
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: _selectedPatient == null
//                 ? Center(child: Text('Select a patient to see details'))
//                 : PatientDetails(patient: _selectedPatient!),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Sidebar extends StatelessWidget {
//   final Function(int) onItemTapped;
//   final int selectedIndex;
//
//   Sidebar({required this.onItemTapped, required this.selectedIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       color: Colors.black87,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           IconButton(
//             icon: Icon(Icons.grid_view, color: selectedIndex == 0 ? Colors.pink : Colors.white),
//             onPressed: () => onItemTapped(0),
//           ),
//           IconButton(
//             icon: Icon(Icons.calendar_today, color: selectedIndex == 1 ? Colors.pink : Colors.white),
//             onPressed: () => onItemTapped(1),
//           ),
//           IconButton(
//             icon: Icon(Icons.bar_chart, color: selectedIndex == 2 ? Colors.pink : Colors.white),
//             onPressed: () => onItemTapped(2),
//           ),
//           IconButton(
//             icon: Icon(Icons.notifications, color: selectedIndex == 3 ? Colors.pink : Colors.white),
//             onPressed: () => onItemTapped(3),
//           ),
//           CircleAvatar(
//             backgroundImage: AssetImage('assets/profile.jpg'), // Profile image
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class PatientList extends StatelessWidget {
//   final Function(String) onPatientSelected;
//   final String? selectedPatient;
//
//   PatientList({required this.onPatientSelected, required this.selectedPatient});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey[200],
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search for a patient',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               children: List.generate(7, (index) {
//                 String patient = 'Patient Name $index';
//                 bool isSelected = patient == selectedPatient;
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: AssetImage('assets/patient.jpg'), // Patient image
//                   ),
//                   title: Text(patient),
//                   subtitle: Text('Manchester City, UK'),
//                   selected: isSelected,
//                   selectedTileColor: Colors.pink[50],
//                   onTap: () => onPatientSelected(patient),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class PatientDetails extends StatelessWidget {
//   final String patient;
//
//   PatientDetails({required this.patient});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: AssetImage('assets/patient_detail.jpg'), // Detail image
//               ),
//               SizedBox(width: 20),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(patient, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   Text('Manchester City, UK', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Column(
//                 children: [
//                   Text('Heart rate', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   Text('72 bpm', style: TextStyle(fontSize: 24)),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text('Weight', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   Text('56 kg', style: TextStyle(fontSize: 24)),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Column(
//                 children: [
//                   Text('Systolic pressure', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   Text('132 mmHg', style: TextStyle(fontSize: 24)),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text('Diastolic pressure', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   Text('88 mmHg', style: TextStyle(fontSize: 24)),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Text('Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Expanded(
//             child: ListView(
//               children: List.generate(8, (index) {
//                 return Container(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_today),
//                           SizedBox(width: 10),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Medication time'),
//                               Text('20 Jul 2024'),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text('19:56'),
//                           Text('1 x Prozac pill'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
