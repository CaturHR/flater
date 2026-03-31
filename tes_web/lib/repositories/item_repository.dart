import '../models/item_model.dart';
import '../services/api_service.dart';

/// Repository class yang menjadi jembatan antara Service dan Provider.
///
/// Berperan sebagai abstraction layer sehingga Provider
/// tidak perlu tahu detail implementasi API.
/// Memudahkan testing dan penggantian sumber data di masa depan.
class ItemRepository {
  final ApiService _apiService;

  /// Constructor menerima instance ApiService melalui dependency injection.
  /// Ini memudahkan unit testing dengan mock service.
  ItemRepository({required ApiService apiService}) : _apiService = apiService;

  /// Mengambil semua items dari API melalui service.
  ///
  /// Mengembalikan `Future<List<ItemModel>>` yang berisi daftar item.
  Future<List<ItemModel>> fetchItems() async {
    return await _apiService.getItems();
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
}
