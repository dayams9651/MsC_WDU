import 'package:farmicon1/common/widget/round_button.dart';
import 'package:farmicon1/const/image_strings.dart';
import 'package:farmicon1/routes/routes.dart';
import 'package:farmicon1/screens/qe_result_screen.dart';
import 'package:farmicon1/style/color.dart';
import 'package:farmicon1/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:flutter/services.dart';
import 'controller/get_devices_details_controller.dart';

class ScanQrScreenPage extends StatefulWidget {
  final String setResult;

  const ScanQrScreenPage({
    required this.setResult,
    super.key,
  });

  @override
  State<ScanQrScreenPage> createState() => _ScanQrScreenPageState();
}
class _ScanQrScreenPageState extends State<ScanQrScreenPage> {
  final TextEditingController _textController = TextEditingController();
  final DeviceController deviceController = Get.put(DeviceController());
  QRViewController? _qrViewController;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _textController.clear();
  }

  @override
  void dispose() {
    _textController.clear();
    _qrViewController?.dispose();
    super.dispose();
  }

  void _toggleFlash() async {
    if (_qrViewController != null) {
      _qrViewController?.toggleFlash();
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
          child: Text(
            "Scan IMEI QR/Barcode",
            style: AppTextStyles.kCaption13SemiBoldTextStyle.copyWith(color: AppColors.white),
          ),
        ),
        actions: [
          IconButton(onPressed: _toggleFlash, icon: Icon(Icons.flash_auto)),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 370,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: QRView(
                  key: GlobalKey(debugLabel: 'QR'),
                  onQRViewCreated: (QRViewController controller) {
                    _qrViewController = controller;
                    _qrViewController?.resumeCamera();
                    _qrViewController?.scannedDataStream.listen((scanData) async {
                      if (scanData != null && scanData.code != null && scanData.format == BarcodeFormat.qrcode) {
                        String scannedCode = scanData.code ?? '';
                        if (scannedCode.length > 15) {
                          scannedCode = scannedCode.substring(0, 15);
                        }
                        if (_textController.text != scannedCode) {
                          setState(() {
                            _textController.text = scannedCode;
                          });
                        }
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "OR",
              style: AppTextStyles.kBody16SemiBoldTextStyle.copyWith(color: AppColors.error60),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter IMEI Number',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryColor),
                    child: TextButton(
                      onPressed: isSubmitting ? null : _submitText,
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: AppColors.white)
                          : const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 35,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              final device = deviceController.deviceDetail.value;
              if (device != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Name : ${device.productName}", style: AppTextStyles.kSmall12SemiBoldTextStyle),
                      Text("Device IMEI: ${device.deviceImei}", style: AppTextStyles.kSmall12SemiBoldTextStyle),
                      Text("Device Model : ${device.deviceModel}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                      Text("Serial Number : ${device.serialNumber}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                      Text("Manufacturing Months : ${device.manufacturingMonth}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                      Text("Manufacturing Year : ${device.manufacturingYear}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                      Text("Manufacturing BY : ${device.manufacturer}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                    ],
                  ),
                );
              } else {
                return Image.asset(noData1, height: 250, width: 250);
              }
            }),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RoundButton(title: "Next", onTap: () {
                Get.to(() => QrResultScreen(result: _textController.text));
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _submitText() async {
    final result = _textController.text;
    if (result.isNotEmpty) {
      setState(() {
        isSubmitting = true;
      });
      await deviceController.fetchDeviceDetails(result);
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log out"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Logout"),
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
}




