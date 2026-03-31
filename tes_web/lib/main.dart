import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/item_provider.dart';
import 'repositories/item_repository.dart';
import 'services/api_service.dart';
import 'pages/home_page.dart';

/// Entry point aplikasi Flutter CRUD.
///
/// Setup:
/// 1. Inisialisasi dependency injection (ApiService → ItemRepository → ItemProvider)
/// 2. Konfigurasi ChangeNotifierProvider untuk state management
/// 3. Menampilkan HomePage sebagai halaman utama
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

    return ChangeNotifierProvider(
      // Provider menyediakan ItemProvider ke seluruh widget tree
      create: (_) => ItemProvider(repository: itemRepository),
      child: MaterialApp(
        title: 'Flutter CRUD App',
        debugShowCheckedModeBanner: false,

        // Konfigurasi tema aplikasi menggunakan Material 3
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

        // Halaman utama aplikasi
        home: const HomePage(),
      ),
    );
  }
}
