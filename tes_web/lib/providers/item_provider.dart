import 'package:flutter/foundation.dart';
import '../models/item_model.dart';
import '../repositories/item_repository.dart';

/// Provider class untuk mengelola state data items.
///
/// Menggunakan ChangeNotifier dari package provider
/// untuk reactive state management. UI akan otomatis
/// diperbarui setiap kali notifyListeners() dipanggil.
class ItemProvider extends ChangeNotifier {
  final ItemRepository _repository;

  /// Constructor menerima ItemRepository melalui dependency injection.
  ItemProvider({required ItemRepository repository}) : _repository = repository;

  // ============================================================
  // STATE VARIABLES
  // ============================================================

  /// List data items yang ditampilkan di UI
  List<ItemModel> _items = [];

  /// Status loading (true saat API sedang dipanggil)
  bool _isLoading = false;

  /// Pesan error jika terjadi kegagalan
  String _errorMessage = '';

  // ============================================================
  // GETTERS - Akses state dari UI
  // ============================================================

  /// Getter untuk daftar items (immutable dari luar)
  List<ItemModel> get items => _items;

  /// Getter untuk status loading
  bool get isLoading => _isLoading;

  /// Getter untuk pesan error
  String get errorMessage => _errorMessage;

  /// Cek apakah ada error
  bool get hasError => _errorMessage.isNotEmpty;

  // ============================================================
  // CRUD OPERATIONS
  // ============================================================

  /// READ - Mengambil semua data dari API.
  ///
  /// Mengatur loading state, memanggil repository,
  /// dan memperbarui UI setelah data diterima.
  Future<void> loadItems() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _items = await _repository.fetchItems();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// CREATE - Menambahkan item baru melalui API.
  ///
  /// Setelah berhasil, item ditambahkan ke list lokal
  /// dan UI diperbarui secara otomatis.
  ///
  /// [name] - Nama item baru
  /// [description] - Deskripsi item baru
  ///
  /// Throws [Exception] jika gagal agar UI bisa menampilkan pesan error.
  Future<void> addItem(String name, String description) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newItem = ItemModel(name: name, description: description);
      final createdItem = await _repository.addItem(newItem);

      // Tambahkan ke awal list agar item baru terlihat di paling atas
      // Gunakan id unik berdasarkan timestamp untuk menghindari duplikasi id
      final itemWithUniqueId = createdItem.copyWith(
        id: DateTime.now().millisecondsSinceEpoch,
      );
      _items.insert(0, itemWithUniqueId);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      rethrow; // Rethrow agar UI bisa menangkap error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// UPDATE - Mengupdate item yang sudah ada melalui API.
  ///
  /// Setelah berhasil, item di list lokal diperbarui
  /// pada posisi yang sama (berdasarkan id).
  ///
  /// [item] - ItemModel dengan data yang diperbarui (harus memiliki id).
  ///
  /// Throws [Exception] jika gagal.
  Future<void> updateItem(ItemModel item) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.editItem(item);

      // Update item di list lokal berdasarkan id
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// DELETE - Menghapus item melalui API berdasarkan id.
  ///
  /// Setelah berhasil, item dihapus dari list lokal
  /// dan UI diperbarui secara otomatis.
  ///
  /// [id] - ID item yang akan dihapus.
  ///
  /// Throws [Exception] jika gagal.
  Future<void> deleteItem(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.removeItem(id);

      // Hapus item dari list lokal
      _items.removeWhere((item) => item.id == id);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Membersihkan pesan error.
  /// Dipanggil setelah error ditampilkan ke user.
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
