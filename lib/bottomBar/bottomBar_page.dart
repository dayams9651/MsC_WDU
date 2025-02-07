import 'package:farmicon1/screens/qr_scan_list.dart';
import 'package:flutter/material.dart';
import '../screens/scanQR_screen_page.dart';

import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = [
    QrScanList(),
    const ScanqrScreenPage(setResult: '',),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // Show the confirmation dialog
    bool shouldExit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'),
          content: Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Don't exit
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Exit
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    return shouldExit; // If true, exit the app, if false, stay on the current page
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Call the exit confirmation when back button is pressed
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.explore, 0),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.document_scanner, 1),
              label: 'Scan Code',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, int index,) {
    bool isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: isSelected ? 40 : 24,
      height: isSelected ? 35 : 24,
      child: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey,
        size: isSelected ? 30 : 24, // Adjust icon size
      ),
    );
  }
}
