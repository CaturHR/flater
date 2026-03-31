import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';

/// Service class yang bertanggung jawab untuk komunikasi langsung dengan REST API.
///
/// Berisi semua fungsi HTTP (GET, POST, PUT, DELETE)
/// untuk operasi CRUD terhadap endpoint JSONPlaceholder.
class ApiService {
  /// Base URL untuk REST API
  /// Menggunakan JSONPlaceholder sebagai mock API untuk simulasi CRUD
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Header default untuk setiap request API
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  /// GET - Mengambil semua data items dari API.
  ///
  /// Mengirim HTTP GET request ke endpoint /posts
  /// dan mengembalikan `List<ItemModel>`.
  /// Dibatasi 20 item untuk performa yang lebih baik.
  ///
  /// Throws [Exception] jika request gagal atau status code bukan 200.
  Future<List<ItemModel>> getItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?_limit=20'),
      );

      if (response.statusCode == 200) {
        // Decode JSON response menjadi List
        final List<dynamic> jsonData = json.decode(response.body);

        // Mapping setiap JSON object ke ItemModel
        return jsonData.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data: $e');
    }
  }

  /// POST - Membuat item baru melalui API.
  ///
  /// Mengirim HTTP POST request dengan data item baru ke endpoint /posts.
  /// Mengembalikan ItemModel yang baru dibuat (dengan id dari response API).
  ///
  /// [item] - ItemModel yang akan dikirim ke API.
  /// Throws [Exception] jika request gagal.
  Future<ItemModel> createItem(ItemModel item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: _headers,
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201) {
        // API mengembalikan item yang baru dibuat beserta id-nya
        return ItemModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal membuat item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat membuat item: $e');
    }
  }

  /// PUT - Mengupdate item yang sudah ada melalui API.
  ///
  /// Mengirim HTTP PUT request dengan data yang diperbarui ke endpoint /posts/{id}.
  /// Mengembalikan ItemModel yang sudah diupdate.
  ///
  /// [item] - ItemModel dengan data yang sudah diperbarui (harus memiliki id).
  /// Throws [Exception] jika request gagal.
  Future<ItemModel> updateItem(ItemModel item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/${item.id}'),
        headers: _headers,
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return ItemModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal mengupdate item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengupdate item: $e');
    }
  }

  /// DELETE - Menghapus item dari API berdasarkan id.
  ///
  /// Mengirim HTTP DELETE request ke endpoint /posts/{id}.
  /// Mengembalikan true jika berhasil dihapus.
  ///
  /// [id] - ID item yang akan dihapus.
  /// Throws [Exception] jika request gagal.
  Future<bool> deleteItem(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Gagal menghapus item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat menghapus item: $e');
    }
  }
}
