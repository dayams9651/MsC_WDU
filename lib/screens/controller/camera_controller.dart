import 'dart:io';
import 'package:farmicon1/screens/scanQR_screen_page.dart';
import 'package:farmicon1/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../const/api_url.dart';

class UploadController extends GetxController {
  var isLoading = false.obs;
  var selectedImages = RxList<File>();
  var uploadingImages = <File>{}.obs;
  final box = GetStorage();
  QRViewController? _qrViewController;
  final TextEditingController _textController = TextEditingController();
  Future<void> startQrScanner(BuildContext context) async {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    final QRView qrView = QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        _qrViewController = controller;
        _qrViewController?.resumeCamera();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Scan QR Code"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: qrView,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _qrViewController?.dispose();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );

    _qrViewController?.scannedDataStream.listen((scanData) async {
      if (scanData != null && scanData.code != null && scanData.format == BarcodeFormat.qrcode) {
        String scannedCode = scanData.code ?? '';
        if (scannedCode.length > 15) {
          scannedCode = scannedCode.substring(0, 15);
        }
        _textController.text = scannedCode;
      }
    });
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImages.add(File(image.path));
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImages.add(File(image.path));
    }
  }

  // This method is used to upload the selected images.
  Future<void> uploadImage(String? result) async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image',
          backgroundColor: AppColors.error20);
      return;
    }

    String? token = box.read('token');
    debugPrint('Retrieved Token: $token');

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token not found. Please log in first.',
          backgroundColor: AppColors.error20);
      return;
    }

    isLoading.value = true;
    var uri = Uri.parse(
      'https://api-bpe.mscapi.live/device-movement/ber/uploadImages/$result',
    );

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = ' $token';

    for (var file in selectedImages) {
      uploadingImages.add(file);
      var multipartFile = await http.MultipartFile.fromPath(
        'file', file.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        var message = jsonResponse['message'] ?? 'No message from server';
        Get.snackbar('Success', message, backgroundColor: AppColors.success20);
        debugPrint('Response Message: $responseBody');
        Get.to(const ScanQrScreenPage(setResult: ''));
      } else {
        var jsonResponse = json.decode(responseBody);
        debugPrint(responseBody);
        var errorMessage = jsonResponse['message'] ?? 'Failed to upload images';
        if (jsonResponse['success'] == false) {
          errorMessage = jsonResponse['message'] ?? 'Failed to upload images';
          Get.snackbar('Error', errorMessage, backgroundColor: AppColors.error20);
        }
      }
    } catch (e) {
      debugPrint("$e");
      Get.snackbar('Error', "$e", backgroundColor: AppColors.error20);
    } finally {
      uploadingImages.clear();
      isLoading.value = false;
    }
  }


  Future<void> wrongDeviceUploadImage(String? result) async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image', backgroundColor: AppColors.error20);
      return;
    }

    String? token = box.read('token');
    debugPrint('Retrieved Token: $token');

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token not found. Please log in first.', backgroundColor: AppColors.error20);
      return;
    }

    isLoading.value = true;
    var uri = Uri.parse(
      '$uploadImageApi/$result',
    );

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = ' $token';

    for (var file in selectedImages) {
      uploadingImages.add(file);
      var multipartFile = await http.MultipartFile.fromPath(
        'file', file.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        var message = jsonResponse['message'] ?? 'No message from server';
        Get.snackbar('Success', message , backgroundColor: AppColors.success20 );
        debugPrint('Response Message: $responseBody');
        Get.to(const ScanQrScreenPage(setResult: ''));
      } else {
        var jsonResponse = json.decode(responseBody);
        var errorMessage = jsonResponse['message'] ?? 'Failed to upload images';
        Get.snackbar('Error', errorMessage, backgroundColor: AppColors.error20);
      }
    } catch (e) {
      Get.snackbar('Error', 'Please check your internet connection', backgroundColor: AppColors.error20);
    } finally {
      uploadingImages.clear();
      isLoading.value = false;
    }
  }

  Future<void> NewDeviceUploadImage(String? result) async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image', backgroundColor: AppColors.error20);
      return;
    }

    String? token = box.read('token');
    debugPrint('Retrieved Token: $token');

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token not found. Please log in first.', backgroundColor: AppColors.error20);
      return;
    }

    isLoading.value = true;
    var uri = Uri.parse(
      '$uploadImageApi/$result',
    );

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = ' $token';

    for (var file in selectedImages) {
      uploadingImages.add(file);
      var multipartFile = await http.MultipartFile.fromPath(
        'file', file.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        var message = jsonResponse['message'] ?? 'No message from server';
        Get.snackbar('Success', message , backgroundColor: AppColors.success20 );
        debugPrint('Response Message: $responseBody');
        Get.to(const ScanQrScreenPage(setResult: ''));
      } else {
        var jsonResponse = json.decode(responseBody);
        var errorMessage = jsonResponse['message'] ?? 'Failed to upload images';
        Get.snackbar('Error', errorMessage, backgroundColor: AppColors.error20);
      }
    } catch (e) {
      Get.snackbar('Error', 'Please check your internet connection', backgroundColor: AppColors.error20);
    } finally {
      uploadingImages.clear();
      isLoading.value = false;
    }
  }

  void removeImage(File image) {
    selectedImages.remove(image);
  }

  TextEditingController get textController => _textController;
}





