import 'package:flutter/material.dart';

/// ============================================================
/// CONSTANTS - Konstanta dan konfigurasi aplikasi
/// ============================================================
///
/// File ini berisi semua konstanta yang digunakan di seluruh
/// aplikasi, termasuk warna tema, string, dan key SharedPreferences.

// ============================================================
// WARNA TEMA APLIKASI
// ============================================================

/// Warna utama aplikasi - Biru teal modern
const Color kPrimaryColor = Color(0xFF0D47A1);

/// Warna sekunder - Cyan terang
const Color kSecondaryColor = Color(0xFF00BCD4);

/// Warna aksen - Orange untuk highlight
const Color kAccentColor = Color(0xFFFF6D00);

/// Warna background utama
const Color kBackgroundColor = Color(0xFFF5F7FA);

/// Warna card
const Color kCardColor = Colors.white;

/// Warna untuk status ON / aktif
const Color kOnlineColor = Color(0xFF4CAF50);

/// Warna untuk status OFF / cached
const Color kCachedColor = Color(0xFFFF9800);

/// Warna untuk error
const Color kErrorColor = Color(0xFFE53935);

/// Warna suhu panas
const Color kHotColor = Color(0xFFE53935);

/// Warna suhu normal
const Color kNormalColor = Color(0xFF4CAF50);

/// Warna suhu dingin
const Color kColdColor = Color(0xFF2196F3);

// ============================================================
// SHARED PREFERENCES KEYS
// ============================================================

/// Key untuk menyimpan data sensor di SharedPreferences
const String kCacheSensorsKey = 'cached_sensors';

/// Key untuk menyimpan waktu terakhir cache
const String kCacheTimeKey = 'cache_time';

// ============================================================
// STRING CONSTANTS
// ============================================================

/// Nama aplikasi
const String kAppName = 'Smart Room Monitor';

/// Versi aplikasi
const String kAppVersion = '1.0.0';

/// Pesan saat data kosong
const String kEmptyMessage = 'Belum ada data sensor tersedia';

/// Pesan saat error
const String kErrorMessage = 'Terjadi kesalahan saat memuat data';

/// Label sumber data online
const String kOnlineLabel = 'Online Data';

/// Label sumber data cache
const String kCachedLabel = 'Cached Data';

// ============================================================
// DURASI
// ============================================================

/// Durasi splash screen (dalam detik)
const int kSplashDuration = 3;

/// Durasi simulasi API delay (dalam milidetik)
const int kApiDelay = 1200;
