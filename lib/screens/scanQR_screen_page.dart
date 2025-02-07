import 'package:farmicon1/style/color.dart';
import 'package:farmicon1/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'qe_result_screen.dart';

class ScanqrScreenPage extends StatefulWidget {
  final String setResult;
  const ScanqrScreenPage({
    required this.setResult,
    super.key,
  });
  @override
  State<ScanqrScreenPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ScanqrScreenPage> {
  final MobileScannerController controller = MobileScannerController();
  final TextEditingController _textController = TextEditingController();

  void _submitText() {
    final enteredText = _textController.text;
    if (enteredText.isNotEmpty) {
      Get.to(QrResultScreen(result: enteredText));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text("Scan QR", style: AppTextStyles.kCaption13SemiBoldTextStyle,),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    // height: 44,
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
                const SizedBox(width: 5),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor
                  ),
                  child: TextButton(onPressed: _submitText,
                    child: Text('Submit', style: AppTextStyles.kSmall10SemiBoldTextStyle.copyWith(color: AppColors.white),),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
