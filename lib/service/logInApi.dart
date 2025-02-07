import 'dart:convert';
import 'package:farmicon1/bottomBar/bottomBar_page.dart';
import 'package:farmicon1/service/loginIn_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../common/widget/snackbar_helper.dart';
import '../const/api_url.dart';
import '../style/color.dart';
import 'package:get_storage/get_storage.dart';
final box = GetStorage();

class UserLogInService extends GetxController {
  RxBool isLoading = false.obs;
  var responseMessage = ''.obs;
  var logInData = Rxn<LoginResponse>();
  Future<void> logInUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(logInApi),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success']) {
          String token = responseData['data']['token'];
          box.write('token', token);
           // Save token here
          debugPrint("Saved Token: $token");
          debugPrint("LogIn Api Response : ${response.body}");
          showCustomSnackbar('LogIn', '${responseData['message']}');
          debugPrint("LogIn Data: ${responseData['message']}");
          Get.to( const BottomBar());
          var decodedResponse = json.decode(response.body);
          logInData.value = LoginResponse.fromJson(decodedResponse);
        } else {
          showCustomSnackbar('Error', responseData['message'] ?? 'Your Email or Password is wrong');
          debugPrint("Error ${responseData['message']}");
        }
      } else {
        showCustomSnackbar('Alert', 'Your Email or Password is wrong');
      }
    } catch (error) {
      showCustomSnackbar('Error', 'Please Check Your Internet Connection', backgroundColor: AppColors.error10);
    }
  }
  String getToken() {
    return box.read('token') ?? '';
  }

  bool isUserLoggedIn() {
    return box.read('token') != null;
  }
}

