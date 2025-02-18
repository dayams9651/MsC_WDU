import 'package:farmicon1/screens/qr_scan_list.dart';
import 'package:farmicon1/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/routes.dart';
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
    const QrScanList(),
    const ScanQrScreenPage(setResult: '',),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    bool shouldExit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit'),
          content: const Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                final box = GetStorage();
                box.erase();
                String? token = box.read('token');
                if (token == null) {
                  Get.toNamed(ApplicationPages.splashScreen);
                  debugPrint('Token has been deleted');
                } else {
                  debugPrint('Token still exists: $token');
                }
                Navigator.of(context).pop(true); // Exit
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
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
              icon: _buildAnimatedIcon(Icons.home, 0,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.document_scanner, 1,),
              label: 'Scan Code',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryColor,
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
        color: isSelected ? AppColors.primaryColor : Colors.grey,
        size: isSelected ? 30 : 24, // Adjust icon size
      ),
    );
  }
}
