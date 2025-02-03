import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'UI/qe_result_screen.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: BottomBarExample(),
    );
  }
}

class BottomBarExample extends StatefulWidget {
  @override
  _BottomBarExampleState createState() => _BottomBarExampleState();
}

class _BottomBarExampleState extends State<BottomBarExample> {
  int _selectedIndex = 0;

  // List of pages corresponding to the bottom navigation bar items
  static List<Widget> _pages = <Widget>[
    Explore_Page_Screen(),
    ProfilePage(setResult: '',

    ),
    Network_Page_Screen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.explore, 0),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.document_scanner, 1),
            label: 'Scan Code',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.balance_rounded, 2),
            label: 'Network',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, int index,) {
    bool isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: isSelected ? 40 : 24, // Increase size when selected
      height: isSelected ? 35 : 24, // Increase size when selected
      child: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey,
        size: isSelected ? 30 : 24, // Adjust icon size
      ),
    );
  }
}

// Home Page Widget
class Explore_Page_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Page', style: TextStyle(fontSize: 30)));
  }
}

// Search Page Widget
class Network_Page_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Network Page', style: TextStyle(fontSize: 30)));
  }
}

// Profile Page Widget

class ProfilePage extends StatefulWidget {
  final String setResult; // Change to a function type

  ProfilePage({
    required this.setResult,
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEventModeEnabled = true; // Rename for clarity

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 70),
              CircleAvatar(
                radius: 68,
                backgroundColor: Colors.amber,
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey,
                  child: Text('🙎', style: TextStyle(fontSize: 90)),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "NIKHIL PANWAR",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  // Implement showing QR code functionality if needed
                },
                child: Text(
                  "Show my QR code",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MobileScanner(
                controller: controller,
                onDetect: (BarcodeCapture capture) async {
                  final List<Barcode> barcodes = capture.barcodes;
                  final barcode = barcodes.first;

                  if (barcode.rawValue != null) {
                    widget.setResult; // Use the setResult function

                    // Navigate to the result page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QrResultScreen(result: barcode.rawValue!),
                      ),
                    );

                    await controller.stop().then((value) => controller.dispose());
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Event Mode',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              CupertinoSwitch(
                value: _isEventModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEventModeEnabled = value; // Update the state
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 35,
            width: 300,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Enter your event name",
                hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

// New Result Page to display the scanned result




