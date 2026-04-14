import 'dart:math';
import '../models/sensor_model.dart';

/// ============================================================
/// SERVICE - ApiService (Mock API)
/// ============================================================
///
/// Service class yang mensimulasikan komunikasi dengan REST API IoT.
///
/// Karena project ini tidak menggunakan device fisik,
/// data sensor di-generate secara mock (simulasi) dengan
/// nilai random yang realistis.
///
/// Menggunakan Future.delayed untuk mensimulasikan
/// network latency seperti API asli.
class ApiService {
  /// Random generator untuk variasi data
  final Random _random = Random();

  /// Flag untuk simulasi mode offline (untuk testing error state)
  /// Set ke true untuk mensimulasikan kegagalan API
  bool simulateOffline = false;

  /// GET - Mengambil semua data sensor dari Mock API.
  ///
  /// Mensimulasikan HTTP GET request dengan delay 1.2 detik.
  /// Mengembalikan `List<SensorModel>` berisi 5 sensor device.
  ///
  /// Throws [Exception] jika simulateOffline = true
  /// (untuk testing error/offline state).
  Future<List<SensorModel>> getSensors() async {
    // Simulasi network delay (seolah-olah memanggil API)
    await Future.delayed(const Duration(milliseconds: 1200));

    // Simulasi kegagalan API (untuk testing error state)
    if (simulateOffline) {
      throw Exception('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }

    // Generate mock data sensor dengan nilai yang bervariasi
    // setiap kali dipanggil (seperti data real-time dari IoT)
    return _generateMockSensors();
  }

  /// GET by ID - Mengambil data sensor tertentu berdasarkan ID.
  ///
  /// [id] - ID sensor yang dicari.
  /// Mengembalikan SensorModel jika ditemukan.
  ///
  /// Throws [Exception] jika sensor tidak ditemukan.
  Future<SensorModel> getSensorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (simulateOffline) {
      throw Exception('Gagal terhubung ke server.');
    }

    final sensors = _generateMockSensors();
    return sensors.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Sensor dengan ID $id tidak ditemukan'),
    );
  }

  /// Generate 5 mock sensor devices dengan data realistis.
  ///
  /// Setiap sensor merepresentasikan satu ruangan dengan
  /// karakteristik suhu dan kelembapan yang berbeda.
  List<SensorModel> _generateMockSensors() {
    final now = DateTime.now();

    return [
      // Sensor 1: Ruang Server - suhu tinggi karena perangkat banyak
      SensorModel(
        id: 'sensor_001',
        deviceName: 'Ruang Server',
        temperature: _randomTemp(28.0, 35.0),  // Suhu tinggi
        humidity: _randomHumidity(40.0, 55.0),  // Kelembapan rendah
        statusLamp: true,                        // Lampu selalu ON
        statusFan: true,                         // Kipas/AC selalu ON
        updatedAt: now.subtract(Duration(minutes: _random.nextInt(5))),
      ),

      // Sensor 2: Ruang Meeting - suhu nyaman
      SensorModel(
        id: 'sensor_002',
        deviceName: 'Ruang Meeting',
        temperature: _randomTemp(22.0, 26.0),  // Suhu normal
        humidity: _randomHumidity(50.0, 65.0),  // Kelembapan normal
        statusLamp: _random.nextBool(),          // Lampu bisa ON/OFF
        statusFan: true,                         // Kipas ON
        updatedAt: now.subtract(Duration(minutes: _random.nextInt(10))),
      ),

      // Sensor 3: Lab Komputer - suhu sedang
      SensorModel(
        id: 'sensor_003',
        deviceName: 'Lab Komputer',
        temperature: _randomTemp(24.0, 29.0),  // Suhu sedang
        humidity: _randomHumidity(45.0, 60.0),  // Kelembapan sedang
        statusLamp: true,                        // Lampu ON
        statusFan: true,                         // Kipas ON
        updatedAt: now.subtract(Duration(minutes: _random.nextInt(3))),
      ),

      // Sensor 4: Perpustakaan - suhu sejuk
      SensorModel(
        id: 'sensor_004',
        deviceName: 'Perpustakaan',
        temperature: _randomTemp(20.0, 24.0),  // Suhu sejuk
        humidity: _randomHumidity(55.0, 70.0),  // Kelembapan tinggi
        statusLamp: true,                        // Lampu ON
        statusFan: false,                        // Kipas OFF
        updatedAt: now.subtract(Duration(minutes: _random.nextInt(15))),
      ),

      // Sensor 5: Lobby Utama - suhu normal
      SensorModel(
        id: 'sensor_005',
        deviceName: 'Lobby Utama',
        temperature: _randomTemp(25.0, 30.0),  // Suhu normal-hangat
        humidity: _randomHumidity(50.0, 65.0),  // Kelembapan normal
        statusLamp: _random.nextBool(),          // Lampu bisa ON/OFF
        statusFan: _random.nextBool(),           // Kipas bisa ON/OFF
        updatedAt: now.subtract(Duration(minutes: _random.nextInt(8))),
      ),
    ];
  }

  /// Helper: Generate suhu random dalam range [min, max]
  /// dengan 1 angka di belakang koma
  double _randomTemp(double min, double max) {
    final value = min + _random.nextDouble() * (max - min);
    return double.parse(value.toStringAsFixed(1));
  }

  /// Helper: Generate kelembapan random dalam range [min, max]
  /// dengan 1 angka di belakang koma
  double _randomHumidity(double min, double max) {
    final value = min + _random.nextDouble() * (max - min);
    return double.parse(value.toStringAsFixed(1));
  }
}
