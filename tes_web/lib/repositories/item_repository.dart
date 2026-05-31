import 'dart:convert';
import '../core/storage/local_storage.dart';
import '../models/item_model.dart';
import '../services/api_service.dart';

/// Enum untuk menandai sumber data yang ditampilkan di UI.
///
/// Digunakan oleh Provider dan UI untuk menampilkan label
/// apakah data berasal dari API (online) atau cache (offline).
enum DataSource {
  /// Data berhasil diambil dari API server
  online,

  /// Data diambil dari cache SharedPreferences
  cached,
}

/// Repository class yang menjadi jembatan antara Service dan Provider.
///
/// Berperan sebagai abstraction layer sehingga Provider
/// tidak perlu tahu detail implementasi API.
/// Memudahkan testing dan penggantian sumber data di masa depan.
///
/// Ditambahkan fitur cache & offline support:
/// - Saat API berhasil → simpan ke cache, return data online
/// - Saat API gagal → ambil dari cache, return data cached
/// - Saat cache kosong → throw error
class ItemRepository {
  final ApiService _apiService;

  /// Constructor menerima instance ApiService melalui dependency injection.
  /// Ini memudahkan unit testing dengan mock service.
  ItemRepository({required ApiService apiService}) : _apiService = apiService;

  /// Mengambil items dengan fallback ke cache jika API gagal.
  ///
  /// Mengembalikan record berisi list items dan sumber datanya.
  /// - Jika API berhasil → simpan cache, kembalikan data online
  /// - Jika API gagal → ambil dari cache
  /// - Jika cache juga kosong → throw error
  Future<({List<ItemModel> items, DataSource source})> fetchItems() async {
    try {
      // Coba ambil data dari API
      final items = await _apiService.getItems();

      // API berhasil → simpan ke cache untuk offline access
      await _saveItemsToCache(items);

      return (items: items, source: DataSource.online);
    } catch (e) {
      // API gagal → coba ambil dari cache
      final cachedItems = await _loadItemsFromCache();

      if (cachedItems != null && cachedItems.isNotEmpty) {
        return (items: cachedItems, source: DataSource.cached);
      }

      // Cache juga tidak tersedia → throw error dengan pesan yang jelas
      throw Exception(
        'Tidak dapat mengambil data. '
        'Koneksi internet tidak tersedia dan tidak ada data cache. '
        'Silakan periksa koneksi internet Anda dan coba lagi.',
      );
    }
  }

  /// Menambahkan item baru melalui API.
  ///
  /// [item] - Data item yang akan ditambahkan.
  /// Mengembalikan ItemModel yang baru dibuat (dengan id dari API).
  Future<ItemModel> addItem(ItemModel item) async {
    return await _apiService.createItem(item);
  }

  /// Mengupdate item yang sudah ada melalui API.
  ///
  /// [item] - Data item yang sudah diperbarui.
  /// Mengembalikan ItemModel yang sudah diupdate.
  Future<ItemModel> editItem(ItemModel item) async {
    return await _apiService.updateItem(item);
  }

  /// Menghapus item dari API berdasarkan ID.
  ///
  /// [id] - ID item yang akan dihapus.
  /// Mengembalikan true jika berhasil dihapus.
  Future<bool> removeItem(int id) async {
    return await _apiService.deleteItem(id);
  }

  // ============================================================
  // PRIVATE CACHE METHODS
  // ============================================================

  /// Menyimpan list items ke cache sebagai JSON string.
  Future<void> _saveItemsToCache(List<ItemModel> items) async {
    final jsonList = items.map((item) => item.toJson()..['id'] = item.id).toList();
    final jsonString = json.encode(jsonList);
    await LocalStorage.saveCachedData(jsonString);
  }

  /// Membaca list items dari cache.
  /// Mengembalikan `null` jika cache tidak tersedia.
  Future<List<ItemModel>?> _loadItemsFromCache() async {
    final jsonString = await LocalStorage.getCachedData();
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    } catch (e) {
      // Cache corrupt → abaikan dan return null
      return null;
    }
  }
}
