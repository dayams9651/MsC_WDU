// lib/controllers/device_controller.dart

import 'package:farmicon1/const/api_url.dart';
import 'package:farmicon1/screens/model/devices_details_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceController extends GetxController {


  var deviceDetail = Rx<DeviceDetail?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  static final box = GetStorage();

  Future<void> fetchDeviceDetails(String result) async {
    String? token = box.read('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found. Please log in first.');
    }
    try {
      final response = await http.get(Uri.parse('$getDevicesDetailsApi/$result'),
        headers: {
          'Authorization': ' $token',
        },
      );

      if (response.statusCode == 200) {
        final deviceResponse = DeviceResponse.fromJson(jsonDecode(response.body));

        if (deviceResponse.success && deviceResponse.data.isNotEmpty) {
          deviceDetail(deviceResponse.data[0]);
        } else {
          errorMessage('No data found.');
        }
      } else {
        errorMessage('Failed to load data.');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
