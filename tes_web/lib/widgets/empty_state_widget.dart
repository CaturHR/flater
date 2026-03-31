import 'package:flutter/material.dart';

/// Widget reusable untuk menampilkan empty state.
///
/// Digunakan ketika tidak ada data yang ditampilkan di list.
/// Menampilkan ikon, judul, dan subjudul yang informatif.
class EmptyStateWidget extends StatelessWidget {
  /// Ikon yang ditampilkan
  final IconData icon;

  /// Judul pesan empty state
  final String title;

  /// Sub-judul / deskripsi tambahan
  final String subtitle;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = 'Belum ada data',
    this.subtitle = 'Tap tombol + untuk menambahkan item baru',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon besar dengan warna sesuai tema
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),

            // Judul empty state
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Sub-judul
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
