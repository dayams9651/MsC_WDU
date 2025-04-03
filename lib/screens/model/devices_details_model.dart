// lib/models/device_detail.dart

class DeviceDetail {
  final String deviceSku;
  final String productName;
  final String productKey;
  final String deviceModel;
  final String serialNumber;
  final String deviceImei;
  final String manufacturingMonth;
  final String manufacturingYear;
  final String manufacturer;

  DeviceDetail({
    required this.deviceSku,
    required this.productName,
    required this.productKey,
    required this.deviceModel,
    required this.serialNumber,
    required this.deviceImei,
    required this.manufacturingMonth,
    required this.manufacturingYear,
    required this.manufacturer,
  });

  factory DeviceDetail.fromJson(Map<String, dynamic> json) {
    return DeviceDetail(
      deviceSku: json['device_sku'],
      productName: json['p_name'],
      productKey: json['product_key'],
      deviceModel: json['device_model'],
      serialNumber: json['sl_no'],
      deviceImei: json['device_imei'],
      manufacturingMonth: json['mfgMonth'],
      manufacturingYear: json['mfgYear'],
      manufacturer: json['mfgBy'],
    );
  }
}

class DeviceResponse {
  final bool success;
  final List<DeviceDetail> data;
  final String status;

  DeviceResponse({
    required this.success,
    required this.data,
    required this.status,
  });

  factory DeviceResponse.fromJson(Map<String, dynamic> json) {
    return DeviceResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((deviceJson) => DeviceDetail.fromJson(deviceJson))
          .toList(),
      status: json['status'],
    );
  }
}
