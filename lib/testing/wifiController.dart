// lib/wifi_controller.dart
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiController extends GetxController {
  var wifiList = <WifiNetwork>[].obs;
  var isScanning = false.obs;

  // Method to start scanning for Wi-Fi networks
  void scanWifi() async {
    isScanning.value = true;
    wifiList.value = await WiFiForIoTPlugin.loadWifiList();
    isScanning.value = false;
  }
}
