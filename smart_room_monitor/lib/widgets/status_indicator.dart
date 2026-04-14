import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// ============================================================
/// WIDGET - StatusIndicator
/// ============================================================
///
/// Widget badge/chip yang menampilkan sumber data:
/// - "🟢 Online Data"  → data fresh dari API
/// - "📦 Cached Data"  → data dari local cache
///
/// Ditampilkan di bawah AppBar pada Dashboard screen
/// agar user tahu apakah data yang ditampilkan real-time
/// atau dari cache (offline).
class StatusIndicator extends StatelessWidget {
  /// True jika data berasal dari cache
  final bool isFromCache;

  /// Waktu terakhir data di-update (opsional)
  final DateTime? lastUpdated;

  const StatusIndicator({
    super.key,
    required this.isFromCache,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        // Warna background berbeda untuk online vs cached
        color: isFromCache
            ? kCachedColor.withValues(alpha: 0.1)
            : kOnlineColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isFromCache
              ? kCachedColor.withValues(alpha: 0.3)
              : kOnlineColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon lingkaran berwarna
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isFromCache ? kCachedColor : kOnlineColor,
              shape: BoxShape.circle,
              // Efek glow
              boxShadow: [
                BoxShadow(
                  color: (isFromCache ? kCachedColor : kOnlineColor)
                      .withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Label teks
          Text(
            isFromCache ? kCachedLabel : kOnlineLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isFromCache ? kCachedColor : kOnlineColor,
            ),
          ),

          // Waktu terakhir update (jika ada)
          if (lastUpdated != null) ...[
            const SizedBox(width: 8),
            Text(
              '• ${_formatTime(lastUpdated!)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Format waktu ke format "HH:mm"
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
