import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/item_provider.dart';
import 'providers/settings_provider.dart';
import 'repositories/item_repository.dart';
import 'services/api_service.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

/// Entry point aplikasi Flutter CRUD.
///
/// Setup:
/// 1. Inisialisasi dependency injection (ApiService → ItemRepository → ItemProvider)
/// 2. Konfigurasi MultiProvider untuk state management (Auth, Settings, Items)
/// 3. Cek status login → arahkan ke LoginPage atau HomePage
/// 4. Dark mode reactive berdasarkan preferensi user
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi dependency chain:
    // ApiService → ItemRepository → ItemProvider
    final apiService = ApiService();
    final itemRepository = ItemRepository(apiService: apiService);

    return MultiProvider(
      providers: [
        // Provider untuk autentikasi (login/logout)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Provider untuk pengaturan (dark mode, username)
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        // Provider untuk data items (CRUD + data source tracking)
        ChangeNotifierProvider(
          create: (_) => ItemProvider(repository: itemRepository),
        ),
      ],
      child: const _AppWithTheme(),
    );
  }
}

/// Widget terpisah untuk menangani theme switching secara reaktif.
/// Menggunakan `Consumer` SettingsProvider agar MaterialApp
/// otomatis rebuild saat dark mode di-toggle.
class _AppWithTheme extends StatelessWidget {
  const _AppWithTheme();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Flutter CRUD App',
          debugShowCheckedModeBanner: false,

          // ThemeMode ditentukan oleh preferensi user
          themeMode: settings.themeMode,

          // ========================
          // LIGHT THEME
          // ========================
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            ),
            useMaterial3: true,

            // Konfigurasi AppBar theme
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),

            // Konfigurasi Card theme
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // Konfigurasi Input decoration theme
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

          // ========================
          // DARK THEME
          // ========================
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,

            // Konfigurasi AppBar theme
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),

            // Konfigurasi Card theme
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // Konfigurasi Input decoration theme
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

          // Named routes untuk navigasi
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
          },

          // Halaman awal: cek status login terlebih dahulu
          home: const _SplashScreen(),
        );
      },
    );
  }
}

/// Splash screen sederhana yang mengecek status login
/// dan preferensi user sebelum menampilkan halaman utama.
///
/// Jika user sudah login → arahkan ke HomePage
/// Jika belum login → arahkan ke LoginPage
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  /// Inisialisasi: load settings dan cek login status
  Future<void> _initApp() async {
    final settingsProvider = context.read<SettingsProvider>();
    final authProvider = context.read<AuthProvider>();

    // Load preferensi user (dark mode, username)
    await settingsProvider.loadSettings();

    // Cek status login
    await authProvider.checkLoginStatus();

    if (mounted) {
      final isLoggedIn = authProvider.isLoggedIn;

      // Navigasi berdasarkan status login
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading indicator saat mengecek status
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
