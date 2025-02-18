import 'package:farmicon1/routes/routes.dart';
import 'package:farmicon1/style/color.dart';
import 'package:farmicon1/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qe_result_screen.dart';

class ScanQrScreenPage extends StatefulWidget {
  final String setResult;
  const ScanQrScreenPage({
    required this.setResult,
    super.key,
  });
  @override
  State<ScanQrScreenPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ScanQrScreenPage> {
  final MobileScannerController controller = MobileScannerController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.clear();
  }

  void dispose() {
    _textController.clear();
    super.dispose();
  }

  void _submitText() {
    final enteredText = _textController.text;
    if (enteredText.isNotEmpty) {
      Get.to(QrResultScreen(result: enteredText));
    }
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Scan AWB QR/Barcode", style: AppTextStyles.kCaption13SemiBoldTextStyle.copyWith(color: AppColors.white),),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: _showLogoutConfirmation,
              icon: const Icon(Icons.login, size: 35, color: AppColors.error60),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Center(
            child: Container(
              width: 370,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: MobileScanner(
                controller: controller,
                onDetect: (BarcodeCapture capture) async {
                  final List<Barcode> barcodes = capture.barcodes;
                  final barcode = barcodes.first;
                  if (barcode.rawValue != null) {
                    widget.setResult;
                    Get.to(QrResultScreen(result: barcode.rawValue!));
                    await controller.stop().then((value) => controller.dispose());
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Text("OR", style: AppTextStyles.kBody16SemiBoldTextStyle.copyWith(color: AppColors.error60),),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter AWB number',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor
                  ),
                  child: TextButton(
                      onPressed: _submitText,
                      child: Icon(Icons.arrow_forward_ios_outlined, size: 35, color: AppColors.white,)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


