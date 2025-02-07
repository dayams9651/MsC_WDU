import 'package:farmicon1/const/image_strings.dart';
import 'package:farmicon1/service/logInApi.dart';
import 'package:farmicon1/style/color.dart';
import 'package:farmicon1/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Text('Profile Page', style: AppTextStyles.kSmall12SemiBoldTextStyle,),
      ),
      body: Obx((){
        if(controller.isLoading.value){
          return Shimmer.fromColors(baseColor: baseColor, highlightColor: highLightColor, child: loadSke());
        }
        else {
          final profileData = controller.logInData.value;
          return Center(
            child: Column(
              children: [
                SizedBox(height: 50,),
                CircleAvatar(
                  radius: 110,
                  backgroundColor: AppColors.white20,
                  child: Image.asset(logo, height: 110,),
                ),
                SizedBox(height: 20,),
                Text("Welcome to back", style: AppTextStyles.kBody20SemiBoldTextStyle,),
                SizedBox(height: 8,),
                Text("MsCorpres Automation", style: AppTextStyles.kCaption13SemiBoldTextStyle.copyWith(color: AppColors.primaryColor),),
                SizedBox(height: 20,),
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
                )
              ],
            ),
          );
        }
      })
    );
  }
}

