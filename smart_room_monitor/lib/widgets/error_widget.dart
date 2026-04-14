import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// ============================================================
/// WIDGET - AppErrorWidget
/// ============================================================
///
/// Widget yang menampilkan error state saat data gagal dimuat.
///
/// Menampilkan:
/// - Icon error besar
/// - Judul error
/// - Pesan error detail
/// - Tombol "Coba Lagi" untuk retry
///
/// Catatan: Nama class menggunakan 'AppErrorWidget' untuk
/// menghindari konflik dengan ErrorWidget bawaan Flutter.
class AppErrorWidget extends StatelessWidget {
  /// Pesan error yang ditampilkan
  final String message;

  /// Callback saat tombol "Coba Lagi" ditekan
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon error dengan background lingkaran
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kErrorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: kErrorColor,
              ),
            ),

            const SizedBox(height: 24),

            // Judul error
            const Text(
              'Oops! Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Pesan error detail
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Tombol Coba Lagi
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
