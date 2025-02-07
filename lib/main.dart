import 'package:farmicon1/bottomBar/bottomBar_page.dart';
import 'package:farmicon1/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'style/color.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(300, 800),
      child: GetMaterialApp(
        enableLog: true,
        defaultTransition: Transition.fade,
        opaqueRoute: Get.isPlatformDarkMode,
        popGesture: Get.isLogEnable,
        transitionDuration: Get.defaultDialogTransitionDuration,
        defaultGlobalState: Get.isLogEnable,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
          ),
        ),
        initialRoute: ApplicationPages.splashScreen,
        getPages: ApplicationPages.getApplicationPages(),
        // home: BottomBar(),
      ),
    );
  }
}


