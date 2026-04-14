import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../utils/constants.dart';

/// ============================================================
/// SCREEN - SettingsScreen
/// ============================================================
///
/// Halaman pengaturan aplikasi.
///
/// Fitur:
/// - Info profil mahasiswa
/// - Clear cache button
/// - Info versi aplikasi
/// - About section
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient dengan info profil
            _buildProfileHeader(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Pengaturan Data
                  const Text(
                    'Pengaturan Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Clear Cache Button
                  _buildSettingCard(
                    icon: Icons.delete_outline,
                    iconColor: kErrorColor,
                    title: 'Hapus Cache',
                    subtitle: 'Menghapus data sensor yang tersimpan secara lokal',
                    onTap: () => _showClearCacheDialog(context),
                  ),

                  const SizedBox(height: 8),

                  // Refresh Data
                  _buildSettingCard(
                    icon: Icons.refresh,
                    iconColor: kPrimaryColor,
                    title: 'Refresh Data',
                    subtitle: 'Memuat ulang data sensor dari server',
                    onTap: () {
                      context.read<SensorProvider>().loadSensors();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data sensor sedang dimuat ulang...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Section: Tentang Aplikasi
                  const Text(
                    'Tentang Aplikasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // App Info
                  _buildSettingCard(
                    icon: Icons.info_outline,
                    iconColor: kSecondaryColor,
                    title: kAppName,
                    subtitle: 'Versi $kAppVersion',
                    onTap: () => _showAboutDialog(context),
                  ),

                  const SizedBox(height: 8),

                  // Teknologi
                  _buildSettingCard(
                    icon: Icons.code,
                    iconColor: Colors.purple,
                    title: 'Teknologi',
                    subtitle: 'Flutter • Provider • SharedPreferences',
                    onTap: null,
                  ),

                  const SizedBox(height: 8),

                  // Mata Kuliah
                  _buildSettingCard(
                    icon: Icons.school,
                    iconColor: kCachedColor,
                    title: 'Project Individu',
                    subtitle: 'Flutter Mobile App for Simple IoT Monitoring',
                    onTap: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header gradient dengan info profil mahasiswa
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kPrimaryColor, Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Nama
          const Text(
            'Mahasiswa',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          // Prodi
          Text(
            'Teknik Informatika',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 4),

          // NIM placeholder
          Text(
            'NIM: XXXXXXXXXX',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// Card pengaturan individual
  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),

              // Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog konfirmasi hapus cache
  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: kCachedColor),
            SizedBox(width: 8),
            Text('Hapus Cache?'),
          ],
        ),
        content: const Text(
          'Semua data sensor yang tersimpan secara lokal akan dihapus. '
          'Data akan dimuat ulang dari server saat Anda kembali ke Dashboard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Hapus cache melalui Provider
              context.read<SensorProvider>().clearCache();
              Navigator.pop(dialogContext);

              // Tampilkan snackbar konfirmasi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('Cache berhasil dihapus'),
                    ],
                  ),
                  backgroundColor: kOnlineColor,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kErrorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  /// Dialog about app
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.sensors, color: kPrimaryColor),
            SizedBox(width: 8),
            Text(kAppName),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aplikasi monitoring IoT sederhana untuk memantau '
              'data sensor ruangan (suhu, kelembapan, status lampu & kipas).',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Fitur Utama:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Dashboard monitoring sensor'),
            Text('• Detail informasi sensor'),
            Text('• Data caching (offline support)'),
            Text('• Indikator sumber data'),
            Text('• Loading, error, & empty state'),
            SizedBox(height: 16),
            Text(
              'Dibuat dengan Flutter + Provider',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
