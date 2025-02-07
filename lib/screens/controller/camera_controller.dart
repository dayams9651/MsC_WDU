
import 'dart:convert';
import 'dart:io';
import 'package:farmicon1/screens/scanQR_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
class UploadController extends GetxController {
  var isLoading = false.obs;
  var selectedImages = RxList<File>();
  var uploadingImages = <File>{}.obs;
  final box = GetStorage();

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
  Future<void> uploadImage(String? result) async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image');
      return;
    }

    String? token = box.read('token');
    debugPrint('Retrieved Token: $token');  // Debugging token retrieval

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token not found. Please log in first.');
      return;
    }

    isLoading.value = true;
    var uri = Uri.parse(
      'https://api-bpe.mscapi.live/wrongDevice/uploadImages/$result',
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
        Get.snackbar('Success', message);
        debugPrint('Response Message: $responseBody');
        Get.to(ScanqrScreenPage(setResult: ''));
      } else {
        var jsonResponse = json.decode(responseBody);
        var errorMessage = jsonResponse['message'] ?? 'Failed to upload images';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      uploadingImages.clear();
      isLoading.value = false;
    }
  }


  void removeImage(File image) {
    selectedImages.remove(image);
  }
}



