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
      body: Row(
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
      color: Colors.black87,
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
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'), // Profile image
          ),
          IconButton(
            icon: Icon(Icons.share, color: selectedIndex == 5 ? Colors.pink : Colors.white),
            onPressed: () => onItemTapped(4),
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
      color: Colors.grey[200],
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
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/patient.jpg'), // Patient image
                  ),
                  title: Text(patient),
                  subtitle: Text('Manchester City, UK'),
                  selected: isSelected,
                  selectedTileColor: Colors.pink[50],
                  onTap: () => onPatientSelected(patient),
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
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/patient_detail.jpg'), // Detail image
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

class DevicesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: List.generate(4, (index) {
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
                    'assets/device.jpg', // Device image
                    height: 80,
                  ),
                  Text(
                    'Device ${index + 1}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Connected',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                    ),
                    child: Text('Disconnect'),
                  ),
                ],
              ),
            ),
          );
        }),
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
