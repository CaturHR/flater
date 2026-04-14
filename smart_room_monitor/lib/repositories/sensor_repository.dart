import '../models/sensor_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

/// ============================================================
/// REPOSITORY - SensorRepository
/// ============================================================
///
/// Repository class yang menjadi jembatan antara Service dan Provider.
///
/// Mengelola logic pengambilan data dengan strategi:
/// 1. Coba fetch dari API terlebih dahulu
/// 2. Jika berhasil → simpan ke cache → return data
/// 3. Jika gagal → coba ambil dari cache
/// 4. Jika cache juga kosong → throw exception
///
/// Juga menyediakan informasi apakah data berasal dari
/// API (online) atau cache (offline).
class SensorRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  /// Constructor menerima ApiService dan CacheService
  /// melalui dependency injection.
  SensorRepository({
    required ApiService apiService,
    required CacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  /// Mengambil data sensor dengan strategi API-first, Cache-fallback.
  ///
  /// Return: Map dengan keys:
  /// - 'sensors' : `List<SensorModel>` data sensor
  /// - 'isFromCache' : bool apakah data dari cache
  ///
  /// Flow:
  /// 1. Coba ambil dari API
  /// 2. Sukses → simpan ke cache → return {data, isFromCache: false}
  /// 3. Gagal → coba ambil dari cache
  /// 4. Cache ada → return {data, isFromCache: true}
  /// 5. Cache kosong → throw exception
  Future<Map<String, dynamic>> fetchSensors() async {
    try {
      // STEP 1: Coba fetch data dari API (mock)
      final sensors = await _apiService.getSensors();

      // STEP 2: Jika berhasil, simpan ke cache untuk backup offline
      await _cacheService.saveSensors(sensors);

      // STEP 3: Return data dengan flag isFromCache = false (online)
      return {
        'sensors': sensors,
        'isFromCache': false,
      };
    } catch (e) {
      // STEP 4: API gagal, coba ambil dari cache
      final cachedSensors = await _cacheService.getCachedSensors();

      if (cachedSensors.isNotEmpty) {
        // STEP 5: Cache tersedia, return data cache
        return {
          'sensors': cachedSensors,
          'isFromCache': true,
        };
      } else {
        // STEP 6: Cache juga kosong, throw error
        throw Exception(
          'Tidak dapat memuat data sensor. '
          'Periksa koneksi internet Anda dan coba lagi.',
        );
      }
    }
  }

  /// Mengambil data sensor tertentu berdasarkan ID.
  ///
  /// Mencari dari list sensor yang sudah di-cache di memory.
  /// Jika tidak ditemukan, coba fetch ulang dari API.
  ///
  /// [id] - ID sensor yang dicari.
  Future<SensorModel> fetchSensorById(String id) async {
    // Coba cari di cache local terlebih dahulu
    final cachedSensors = await _cacheService.getCachedSensors();
    final cached = cachedSensors.where((s) => s.id == id);

    if (cached.isNotEmpty) {
      return cached.first;
    }

    // Jika tidak ada di cache, fetch dari API
    return await _apiService.getSensorById(id);
  }

  /// Menghapus semua data cache.
  /// Dipanggil dari Settings screen.
  Future<void> clearCache() async {
    await _cacheService.clearCache();
  }

  /// Mengecek apakah ada data tersimpan di cache.
  Future<bool> hasCachedData() async {
    return await _cacheService.hasCachedData();
  }

  /// Mengambil waktu terakhir cache dilakukan.
  Future<DateTime?> getLastCacheTime() async {
    return await _cacheService.getLastCacheTime();
  }
}
