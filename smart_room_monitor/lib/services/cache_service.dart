import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sensor_model.dart';
import '../utils/constants.dart';

/// ============================================================
/// SERVICE - CacheService (Local Storage)
/// ============================================================
///
/// Service class yang mengelola penyimpanan data lokal
/// menggunakan SharedPreferences.
///
/// Fungsi utama:
/// 1. Menyimpan data sensor ke local storage (cache)
/// 2. Mengambil data sensor dari cache
/// 3. Mengecek apakah ada data tersimpan
/// 4. Menghapus cache
/// 5. Menyimpan & mengambil waktu terakhir cache
///
/// Data sensor di-encode ke format JSON string sebelum disimpan,
/// dan di-decode kembali saat dibaca.
class CacheService {
  /// Menyimpan daftar sensor ke SharedPreferences.
  ///
  /// Proses:
  /// 1. Convert setiap SensorModel ke Map (toJson)
  /// 2. Encode List<Map> ke JSON string
  /// 3. Simpan JSON string ke SharedPreferences
  /// 4. Simpan juga timestamp saat cache dilakukan
  ///
  /// [sensors] - List sensor yang akan di-cache.
  Future<void> saveSensors(List<SensorModel> sensors) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert list SensorModel ke JSON string
    final jsonList = sensors.map((sensor) => sensor.toJson()).toList();
    final jsonString = json.encode(jsonList);

    // Simpan data sensor ke SharedPreferences
    await prefs.setString(kCacheSensorsKey, jsonString);

    // Simpan waktu saat cache dilakukan
    await prefs.setString(kCacheTimeKey, DateTime.now().toIso8601String());
  }

  /// Mengambil daftar sensor dari cache SharedPreferences.
  ///
  /// Proses:
  /// 1. Ambil JSON string dari SharedPreferences
  /// 2. Decode JSON string ke List<Map>
  /// 3. Convert setiap Map ke SensorModel (fromJson)
  ///
  /// Mengembalikan List kosong jika tidak ada data tersimpan.
  Future<List<SensorModel>> getCachedSensors() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil JSON string dari cache
    final jsonString = prefs.getString(kCacheSensorsKey);

    // Jika tidak ada data, return list kosong
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    // Decode JSON string ke List<SensorModel>
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => SensorModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Mengecek apakah ada data sensor yang tersimpan di cache.
  ///
  /// Mengembalikan true jika ada data tersimpan, false jika kosong.
  Future<bool> hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(kCacheSensorsKey);
    return jsonString != null && jsonString.isNotEmpty;
  }

  /// Mengambil waktu terakhir data di-cache.
  ///
  /// Mengembalikan DateTime jika ada data tersimpan,
  /// null jika belum pernah cache.
  Future<DateTime?> getLastCacheTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString(kCacheTimeKey);

    if (timeString == null) return null;
    return DateTime.parse(timeString);
  }

  /// Menghapus semua data cache sensor dari SharedPreferences.
  ///
  /// Dipanggil dari Settings screen saat user
  /// ingin membersihkan cache secara manual.
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kCacheSensorsKey);
    await prefs.remove(kCacheTimeKey);
  }
}
