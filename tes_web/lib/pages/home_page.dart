import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/item_card.dart';
import 'form_page.dart';

/// Halaman utama yang menampilkan daftar semua items.
///
/// Fitur yang tersedia:
/// - Menampilkan data dari API menggunakan Provider
/// - Pull-to-refresh untuk memuat ulang data
/// - Empty state jika data kosong
/// - Loading indicator saat API dipanggil
/// - FAB untuk menambah item baru
/// - Tombol edit & delete pada setiap item
/// - Konfirmasi sebelum hapus (AlertDialog)
/// - Snackbar untuk feedback operasi CRUD
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load data saat halaman pertama kali dibuka
    // Menggunakan addPostFrameCallback agar context sudah tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// Memuat data dari API melalui Provider
  Future<void> _loadData() async {
    await context.read<ItemProvider>().loadItems();
  }

  /// Navigasi ke halaman form untuk tambah item baru (CREATE)
  void _navigateToAddItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FormPage(),
      ),
    );
  }

  /// Navigasi ke halaman form untuk edit item (UPDATE)
  void _navigateToEditItem(ItemModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormPage(item: item),
      ),
    );
  }

  /// Menampilkan dialog konfirmasi sebelum hapus item (DELETE)
  void _showDeleteConfirmation(int itemId, String itemName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "$itemName"?\n\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          // Tombol batal
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          // Tombol hapus
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteItem(itemId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  /// Menghapus item dan menampilkan feedback via Snackbar
  Future<void> _deleteItem(int itemId) async {
    try {
      await context.read<ItemProvider>().deleteItem(itemId);

      if (mounted) {
        // Snackbar berhasil hapus
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Item berhasil dihapus!'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Snackbar gagal hapus
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Gagal menghapus: $e')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul aplikasi
      appBar: AppBar(
        title: const Text(
          'CRUD Items',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Tombol refresh di AppBar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh data',
          ),
        ],
      ),

      // Body: Menampilkan list data menggunakan Consumer dari Provider
      body: Consumer<ItemProvider>(
        builder: (context, provider, child) {
          // State: Loading
          if (provider.isLoading && provider.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data...'),
                ],
              ),
            );
          }

          // State: Error
          if (provider.hasError && provider.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off_outlined,
                      size: 80,
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi Kesalahan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _loadData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // State: Empty (data kosong)
          if (provider.items.isEmpty) {
            return const EmptyStateWidget();
          }

          // State: Data tersedia - tampilkan dalam list
          return RefreshIndicator(
            onRefresh: _loadData,
            child: Column(
              children: [
                // Info jumlah data
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Text(
                    'Total: ${provider.items.length} item',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                  ),
                ),

                // ListView dengan data items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: provider.items.length,
                    itemBuilder: (context, index) {
                      final item = provider.items[index];

                      return ItemCard(
                        item: item,
                        onEdit: () => _navigateToEditItem(item),
                        onDelete: () => _showDeleteConfirmation(
                          item.id!,
                          item.name,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // FAB untuk menambah item baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddItem,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Item'),
        tooltip: 'Tambah item baru',
      ),
    );
  }
}
