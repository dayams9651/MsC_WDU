import 'package:farmicon1/const/image_strings.dart';
import 'package:farmicon1/routes/routes.dart';
import 'package:farmicon1/service/logInApi.dart';
import 'package:farmicon1/style/color.dart';
import 'package:farmicon1/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import '../common/widget/const_shimmer_effects.dart';

class QrScanList extends StatefulWidget {
  const QrScanList({super.key});
  @override
  State<QrScanList> createState() => _QrScanListState();
}
class _QrScanListState extends State<QrScanList> {
  final UserLogInService controller = Get.put(UserLogInService());
  @override

  void _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log out"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout ?? false) {
      final box = GetStorage();
      box.erase();
      String? token = box.read('token');
      if (token == null) {
        Get.toNamed(ApplicationPages.splashScreen);
        debugPrint('Token has been deleted');
      } else {
        debugPrint('Token still exists: $token');
      }
      SystemNavigator.pop();
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Text('', style: AppTextStyles.kSmall12SemiBoldTextStyle,),
      ),
      body: Obx((){
        if(controller.isLoading.value){
          return Shimmer.fromColors(baseColor: baseColor, highlightColor: highLightColor, child: loadSke());
        }
        else {
          final profileData = controller.logInData.value;
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  CircleAvatar(
                    radius: 110,
                    backgroundColor: AppColors.white20,
                    child: Image.asset(logo, height: 110,),
                  ),
                  const SizedBox(height: 20,),
                  Text("MsCorpres Automation", style: AppTextStyles.kCaption13SemiBoldTextStyle.copyWith(color: AppColors.primaryColor),),
                  const SizedBox(height: 20,),
                  Text("Welcome back,", style: AppTextStyles.kBody20SemiBoldTextStyle,),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: AppColors.white40,
                      child: ListTile(
                        title: Text("${profileData?.data?.username} (${profileData?.data?.companyId})", style: AppTextStyles.kCaption14SemiBoldTextStyle,),
                        subtitle: Text("${profileData?.data?.crnId}", style: AppTextStyles.kCaption13RegularTextStyle),
                        leading: const CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.white,
                          child: Icon(Icons.person, size: 40,),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120,),
                  Center(
                      child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.white20,
                          child: IconButton(
                              onPressed: _showLogoutConfirmation,
                              icon: const Icon(Icons.power_settings_new_rounded,
                                color: AppColors.error60,
                                size: 38,)
                          )
                      )
                  )
                ],
              ),
            ),
          );
        }
      })
    );
  }
}

