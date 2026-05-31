import 'package:flutter/foundation.dart';
import '../core/storage/local_storage.dart';

/// Provider untuk mengelola state autentikasi user.
///
/// Menyediakan fungsi login, logout, dan pengecekan status login.
/// Data disimpan menggunakan LocalStorage (SharedPreferences).
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';

  /// Status login user saat ini.
  bool get isLoggedIn => _isLoggedIn;

  /// Username user yang sedang login.
  String get username => _username;

  /// Mengecek status login dari SharedPreferences saat aplikasi dibuka.
  /// Dipanggil saat inisialisasi aplikasi.
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await LocalStorage.getLoginStatus();
    _username = await LocalStorage.getUsername();
    notifyListeners();
  }

  /// Melakukan login user.
  ///
  /// Menyimpan status login dan username ke SharedPreferences,
  /// kemudian memperbarui state.
  ///
  /// [username] - Nama user yang login.
  /// [password] - Password user (validasi sederhana, tidak kosong).
  ///
  /// Returns `true` jika login berhasil.
  /// Throws [Exception] jika validasi gagal.
  Future<bool> login(String username, String password) async {
    // Validasi sederhana
    if (username.trim().isEmpty) {
      throw Exception('Username tidak boleh kosong');
    }
    if (password.trim().isEmpty) {
      throw Exception('Password tidak boleh kosong');
    }

    // Simpan status login dan username ke LocalStorage
    await LocalStorage.saveLoginStatus(true);
    await LocalStorage.saveUsername(username.trim());

    // Update state
    _isLoggedIn = true;
    _username = username.trim();
    notifyListeners();

    return true;
  }

  /// Melakukan logout user.
  ///
  /// Menghapus status login dan data session dari SharedPreferences.
  /// Setelah logout, user harus login kembali.
  Future<void> logout() async {
    // Hapus status login dan username dari LocalStorage
    await LocalStorage.saveLoginStatus(false);
    await LocalStorage.saveUsername('');

    // Update state
    _isLoggedIn = false;
    _username = '';
    notifyListeners();
  }
}
