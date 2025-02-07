import 'package:farmicon1/bottomBar/bottomBar_page.dart';
import 'package:get/get.dart';

import '../signUp/view/signUp_screen.dart';

class ApplicationPages {
  static const splashScreen = '/';
  static const bottomBarScreen = '/bottomBarScreen';

  static List<GetPage>? getApplicationPages() => [

    GetPage(name: splashScreen,
      page: () => const SignupScreen()),

    GetPage(name: bottomBarScreen,
        page: () => const BottomBar()),

  ];
}
