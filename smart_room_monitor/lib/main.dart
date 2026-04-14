import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/sensor_provider.dart';
import 'repositories/sensor_repository.dart';
import 'services/api_service.dart';
import 'services/cache_service.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

/// ============================================================
/// MAIN - Entry Point Aplikasi Smart Room Monitor
/// ============================================================
///
/// Setup:
/// 1. Inisialisasi dependency injection:
///    ApiService → CacheService → SensorRepository → SensorProvider
/// 2. Konfigurasi ChangeNotifierProvider untuk state management
/// 3. Menampilkan SplashScreen sebagai halaman awal
///
/// Arsitektur:
/// ┌─────────┐    ┌──────────────────┐    ┌─────────────┐
/// │   UI    │ ←→ │  SensorProvider   │ ←→ │ Repository  │
/// │(Screens)│    │(State Management) │    │  (Logic)    │
/// └─────────┘    └──────────────────┘    └──────┬──────┘
///                                               │
///                                    ┌──────────┴──────────┐
///                                    │                     │
///                               ┌────┴─────┐       ┌──────┴──────┐
///                               │ApiService│       │CacheService │
///                               │(Mock API)│       │(SharedPrefs)│
///                               └──────────┘       └─────────────┘
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // DEPENDENCY INJECTION
    // ============================================================
    // Inisialisasi service layer
    final apiService = ApiService();
    final cacheService = CacheService();

    // Inisialisasi repository (menggabungkan API + Cache)
    final sensorRepository = SensorRepository(
      apiService: apiService,
      cacheService: cacheService,
    );

    return ChangeNotifierProvider(
      // Provider menyediakan SensorProvider ke seluruh widget tree
      create: (_) => SensorProvider(repository: sensorRepository),
      child: MaterialApp(
        title: kAppName,
        debugShowCheckedModeBanner: false,

        // ============================================================
        // TEMA APLIKASI
        // ============================================================
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kPrimaryColor,
            brightness: Brightness.light,
          ),
          useMaterial3: true,

          // Scaffold background
          scaffoldBackgroundColor: kBackgroundColor,

          // AppBar theme
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),

          // Card theme
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          // Elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // Halaman awal: Splash Screen
        home: const SplashScreen(),
      ),
    );
  }
}
