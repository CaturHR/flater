import 'package:flutter/material.dart';
import '../core/storage/local_storage.dart';

/// Provider untuk mengelola preferensi user (dark mode & username).
///
/// Data disimpan secara persisten menggunakan SharedPreferences
/// melalui LocalStorage helper, sehingga preferensi tetap tersedia
/// setelah aplikasi ditutup dan dibuka kembali.
class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _username = '';

  /// Status dark mode saat ini.
  bool get isDarkMode => _isDarkMode;

  /// Username yang tersimpan.
  String get username => _username;

  /// Mengembalikan ThemeMode berdasarkan preferensi dark mode.
  /// Digunakan oleh MaterialApp untuk menentukan tema aktif.
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Memuat semua preferensi dari SharedPreferences.
  /// Dipanggil saat aplikasi pertama kali dibuka.
  Future<void> loadSettings() async {
    _isDarkMode = await LocalStorage.getDarkMode();
    _username = await LocalStorage.getUsername();
    notifyListeners();
  }

  /// Toggle dark mode dan simpan ke SharedPreferences.
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await LocalStorage.saveDarkMode(value);
    notifyListeners();
  }

  /// Simpan username baru ke SharedPreferences dan perbarui state.
  Future<void> updateUsername(String username) async {
    _username = username.trim();
    await LocalStorage.saveUsername(_username);
    notifyListeners();
  }
}
