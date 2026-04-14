/// ============================================================
/// MODEL - SensorModel
/// ============================================================
///
/// Model class yang merepresentasikan data sensor IoT.
/// Digunakan untuk memetakan data JSON dari API ke objek Dart.
///
/// Fields:
/// - id          : ID unik sensor
/// - deviceName  : Nama perangkat/ruangan
/// - temperature : Suhu dalam Celsius
/// - humidity    : Kelembapan dalam persen (%)
/// - statusLamp  : Status lampu (true = ON, false = OFF)
/// - statusFan   : Status kipas (true = ON, false = OFF)
/// - updatedAt   : Waktu terakhir data diperbarui
class SensorModel {
  final String id;
  final String deviceName;
  final double temperature;
  final double humidity;
  final bool statusLamp;
  final bool statusFan;
  final DateTime updatedAt;

  /// Constructor utama
  SensorModel({
    required this.id,
    required this.deviceName,
    required this.temperature,
    required this.humidity,
    required this.statusLamp,
    required this.statusFan,
    required this.updatedAt,
  });

  /// Factory constructor untuk membuat SensorModel dari JSON.
  ///
  /// Digunakan saat parsing response dari API atau
  /// saat membaca data dari cache SharedPreferences.
  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['id'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
      statusLamp: json['status_lamp'] as bool? ?? false,
      statusFan: json['status_fan'] as bool? ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  /// Konversi SensorModel ke Map untuk disimpan ke cache
  /// atau dikirim ke API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_name': deviceName,
      'temperature': temperature,
      'humidity': humidity,
      'status_lamp': statusLamp,
      'status_fan': statusFan,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Method copyWith untuk membuat salinan dengan perubahan tertentu.
  /// Berguna untuk immutability saat update data.
  SensorModel copyWith({
    String? id,
    String? deviceName,
    double? temperature,
    double? humidity,
    bool? statusLamp,
    bool? statusFan,
    DateTime? updatedAt,
  }) {
    return SensorModel(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      statusLamp: statusLamp ?? this.statusLamp,
      statusFan: statusFan ?? this.statusFan,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SensorModel(id: $id, deviceName: $deviceName, '
        'temp: $temperature°C, humidity: $humidity%, '
        'lamp: $statusLamp, fan: $statusFan)';
  }
}
