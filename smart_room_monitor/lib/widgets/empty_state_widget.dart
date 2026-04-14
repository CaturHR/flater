import 'package:flutter/material.dart';

/// ============================================================
/// WIDGET - EmptyStateWidget
/// ============================================================
///
/// Widget yang menampilkan empty state saat tidak ada
/// data sensor yang tersedia.
///
/// Menampilkan:
/// - Ilustrasi icon sensor kosong
/// - Judul empty state
/// - Pesan deskripsi
/// - Tombol refresh (opsional)
class EmptyStateWidget extends StatelessWidget {
  /// Callback saat tombol refresh ditekan (opsional)
  final VoidCallback? onRefresh;

  const EmptyStateWidget({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustrasi icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sensors_off_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),

            const SizedBox(height: 24),

            // Judul
            Text(
              'Belum Ada Data Sensor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Deskripsi
            Text(
              'Data sensor belum tersedia.\n'
              'Silakan refresh untuk memuat data terbaru.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Tombol refresh (jika callback disediakan)
            if (onRefresh != null)
              SizedBox(
                width: 180,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Refresh Data',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    side: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
