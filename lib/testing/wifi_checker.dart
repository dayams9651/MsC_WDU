import 'package:farmicon1/testing/wifiController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WifiScreen extends StatelessWidget {
  final WifiController controller = Get.put(WifiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wi-Fi Networks'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: controller.scanWifi,
              child: Obx(() {
                return controller.isScanning.value
                    ? CircularProgressIndicator()
                    : Text('Scan for Wi-Fi');
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.wifiList.isEmpty) {
                  return const Center(child: Text('No Wi-Fi networks found'));
                }
                return ListView.builder(
                  itemCount: controller.wifiList.length,
                  itemBuilder: (context, index) {
                    var wifi = controller.wifiList[index];
                    return ListTile(
                      title: Text(wifi.ssid ?? 'Unknown SSID'),
                      subtitle: Text('Signal Strength: ${wifi.level}'),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
