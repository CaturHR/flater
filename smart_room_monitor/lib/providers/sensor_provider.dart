import 'package:flutter/foundation.dart';
import '../models/sensor_model.dart';
import '../repositories/sensor_repository.dart';

/// ============================================================
/// PROVIDER - SensorProvider
/// ============================================================
///
/// Provider class untuk mengelola seluruh state data sensor.
///
/// Menggunakan ChangeNotifier dari package Provider
/// untuk reactive state management. UI akan otomatis
/// diperbarui setiap kali notifyListeners() dipanggil.
///
/// State yang dikelola:
/// - List sensor data
/// - Loading state
/// - Error state
/// - Sumber data (online/cache)
/// - Waktu terakhir update
class SensorProvider extends ChangeNotifier {
  final SensorRepository _repository;

  /// Constructor menerima SensorRepository melalui dependency injection.
  SensorProvider({required SensorRepository repository})
      : _repository = repository;

  // ============================================================
  // STATE VARIABLES
  // ============================================================

  /// List data sensor yang ditampilkan di UI
  List<SensorModel> _sensors = [];

  /// Status loading (true saat data sedang di-fetch)
  bool _isLoading = false;

  /// Pesan error jika terjadi kegagalan
  String _errorMessage = '';

  /// Flag apakah data berasal dari cache (true) atau API (false)
  bool _isFromCache = false;

  /// Waktu terakhir data berhasil dimuat
  DateTime? _lastUpdated;

  // ============================================================
  // GETTERS - Akses state dari UI (read-only)
  // ============================================================

  /// Getter untuk daftar sensor (immutable dari luar)
  List<SensorModel> get sensors => _sensors;

  /// Getter untuk status loading
  bool get isLoading => _isLoading;

  /// Getter untuk pesan error
  String get errorMessage => _errorMessage;

  /// Cek apakah ada error
  bool get hasError => _errorMessage.isNotEmpty;

  /// Getter untuk flag sumber data (online/cache)
  bool get isFromCache => _isFromCache;

  /// Getter untuk waktu terakhir update
  DateTime? get lastUpdated => _lastUpdated;

  /// Cek apakah data kosong (untuk empty state)
  bool get isEmpty => _sensors.isEmpty && !_isLoading && !hasError;

  // ============================================================
  // COMPUTED PROPERTIES - Kalkulasi dari data sensor
  // ============================================================

  /// Menghitung rata-rata suhu dari semua sensor
  double get averageTemperature {
    if (_sensors.isEmpty) return 0.0;
    final total = _sensors.fold<double>(
      0.0,
      (sum, sensor) => sum + sensor.temperature,
    );
    return double.parse((total / _sensors.length).toStringAsFixed(1));
  }

  /// Menghitung rata-rata kelembapan dari semua sensor
  double get averageHumidity {
    if (_sensors.isEmpty) return 0.0;
    final total = _sensors.fold<double>(
      0.0,
      (sum, sensor) => sum + sensor.humidity,
    );
    return double.parse((total / _sensors.length).toStringAsFixed(1));
  }

  /// Menghitung jumlah lampu yang aktif
  int get activeLamps {
    return _sensors.where((s) => s.statusLamp).length;
  }

  /// Menghitung jumlah kipas yang aktif
  int get activeFans {
    return _sensors.where((s) => s.statusFan).length;
  }

  // ============================================================
  // METHODS - Operasi data
  // ============================================================

  /// Memuat data sensor dari repository.
  ///
  /// Flow:
  /// 1. Set loading = true
  /// 2. Clear error message
  /// 3. Panggil repository.fetchSensors()
  /// 4. Update state (sensors, isFromCache)
  /// 5. Set loading = false
  /// 6. notifyListeners() → UI update otomatis
  Future<void> loadSensors() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // UI tampilkan loading state

    try {
      // Fetch data dari repository (API atau cache)
      final result = await _repository.fetchSensors();

      // Update state dengan data yang diterima
      _sensors = result['sensors'] as List<SensorModel>;
      _isFromCache = result['isFromCache'] as bool;
      _lastUpdated = DateTime.now();
    } catch (e) {
      // Simpan pesan error untuk ditampilkan di UI
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners(); // UI update dengan data/error/empty
    }
  }

  /// Force refresh data dari API.
  ///
  /// Sama seperti loadSensors(), tapi dipanggil saat
  /// user melakukan pull-to-refresh.
  Future<void> refreshSensors() async {
    await loadSensors();
  }

  /// Mengambil sensor berdasarkan ID.
  ///
  /// Mencari di list sensor yang sudah dimuat.
  /// Mengembalikan null jika tidak ditemukan.
  ///
  /// [id] - ID sensor yang dicari.
  SensorModel? getSensorById(String id) {
    try {
      return _sensors.firstWhere((sensor) => sensor.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Menghapus cache data sensor.
  ///
  /// Dipanggil dari Settings screen.
  /// Setelah cache dihapus, list sensor dikosongkan.
  Future<void> clearCache() async {
    await _repository.clearCache();
    _sensors = [];
    _isFromCache = false;
    _lastUpdated = null;
    notifyListeners();
  }

  /// Membersihkan pesan error.
  /// Dipanggil setelah error ditampilkan ke user.
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
