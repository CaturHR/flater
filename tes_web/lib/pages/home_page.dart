import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/auth_provider.dart';
import '../providers/item_provider.dart';
import '../repositories/item_repository.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/item_card.dart';
import 'form_page.dart';
import 'settings_page.dart';

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
/// - Label sumber data (Online Data / Cached Data)
/// - Tombol logout di AppBar
/// - Navigasi ke Settings page
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

  /// Navigasi ke halaman settings (pengaturan)
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsPage(),
      ),
    );
  }

  /// Melakukan logout dan kembali ke halaman login.
  /// Menggunakan pushNamedAndRemoveUntil agar user tidak bisa
  /// kembali ke home dengan tombol Back setelah logout.
  Future<void> _handleLogout() async {
    // Tampilkan dialog konfirmasi logout
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.orange),
            SizedBox(width: 8),
            Text('Konfirmasi Logout'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      // Panggil AuthProvider untuk logout
      await context.read<AuthProvider>().logout();

      if (mounted) {
        // Navigasi ke login dan hapus semua route sebelumnya
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    }
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

  /// Membangun widget label sumber data (Online Data / Cached Data).
  /// Label ditentukan oleh DataSource dari provider, bukan hardcode.
  Widget _buildDataSourceLabel(DataSource source) {
    final isOnline = source == DataSource.online;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isOnline
            ? Colors.green.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isOnline
              ? Colors.green.shade200
              : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.cloud_done_outlined : Icons.cached,
            size: 20,
            color: isOnline ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? 'Online Data' : 'Cached Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isOnline
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
                Text(
                  isOnline
                      ? '✓ data berasal dari server'
                      : '✓ data berasal dari SharedPreferences cache',
                  style: TextStyle(
                    fontSize: 11,
                    color: isOnline
                        ? Colors.green.shade600
                        : Colors.orange.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul, settings, dan logout
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
          // Tombol settings
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _navigateToSettings,
            tooltip: 'Pengaturan',
          ),
          // Tombol logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
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
                // Label sumber data (Online Data / Cached Data)
                _buildDataSourceLabel(provider.dataSource),

                // Info jumlah data
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
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
