import 'package:farmicon1/bottomBar/bottomBar_page.dart';
import 'package:farmicon1/testing/wifi_checker.dart';
import 'package:get/get.dart';

import '../signUp/view/signUp_screen.dart';

// class ApplicationPages {
//   static const splashScreen = '/';
//   static const bottomBarScreen = '/bottomBarScreen';
//
//   static List<GetPage>? getApplicationPages() => [
//
//     GetPage(name: splashScreen,
//       page: () => const SignupScreen()),
//
//     GetPage(name: bottomBarScreen,
//         page: () => const BottomBar()),
//
//   ];
// }

class ApplicationPages {
  static const splashScreen = '/';
  static const bottomBarScreen = '/bottomBarScreen';
  static const wifiScreen = '/wifiScreen';  // New route for Wi-Fi screen

  static List<GetPage> getApplicationPages() => [
    GetPage(name: splashScreen, page: () => const SignupScreen()),
    GetPage(name: bottomBarScreen, page: () => const BottomBar()),
    GetPage(name: wifiScreen, page: () => WifiScreen()),  // Register Wi-Fi screen
  ];
}
