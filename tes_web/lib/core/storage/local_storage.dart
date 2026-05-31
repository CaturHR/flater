import 'package:shared_preferences/shared_preferences.dart';

/// Helper class untuk mengelola semua operasi Local Storage
/// menggunakan SharedPreferences.
///
/// Menyediakan fungsi untuk menyimpan dan membaca:
/// - Status login
/// - Username
/// - Dark mode preference
/// - Cached data (items dari API)
class LocalStorage {
  // Keys untuk SharedPreferences
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyCachedItems = 'cached_items';

  // ============================================================
  // LOGIN STATUS
  // ============================================================

  /// Menyimpan status login user.
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  /// Membaca status login user.
  /// Mengembalikan `false` jika belum pernah disimpan.
  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ============================================================
  // USERNAME
  // ============================================================

  /// Menyimpan nama user ke SharedPreferences.
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  /// Membaca nama user dari SharedPreferences.
  /// Mengembalikan string kosong jika belum pernah disimpan.
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? '';
  }

  // ============================================================
  // DARK MODE
  // ============================================================

  /// Menyimpan preferensi dark mode.
  static Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDarkMode);
  }

  /// Membaca preferensi dark mode.
  /// Mengembalikan `false` (light mode) jika belum pernah disimpan.
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  // ============================================================
  // CACHED DATA (Items)
  // ============================================================

  /// Menyimpan data items yang telah di-encode ke JSON string.
  /// Digunakan untuk offline cache.
  static Future<void> saveCachedData(String jsonData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCachedItems, jsonData);
  }

  /// Membaca cached data items dari SharedPreferences.
  /// Mengembalikan `null` jika cache tidak tersedia.
  static Future<String?> getCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCachedItems);
  }

  // ============================================================
  // CLEAR ALL
  // ============================================================

  /// Menghapus semua data dari SharedPreferences.
  /// Digunakan saat logout atau reset aplikasi.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
