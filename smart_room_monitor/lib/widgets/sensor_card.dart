import 'package:flutter/material.dart';
import '../models/sensor_model.dart';
import '../utils/constants.dart';

/// ============================================================
/// WIDGET - SensorCard
/// ============================================================
///
/// Card widget yang menampilkan ringkasan data satu sensor.
/// Digunakan di Dashboard screen dalam GridView.
///
/// Menampilkan:
/// - Icon perangkat
/// - Nama device
/// - Suhu (dengan warna sesuai level)
/// - Kelembapan
/// - Status lampu & kipas (dot indicator)
/// - Waktu terakhir update
class SensorCard extends StatelessWidget {
  /// Data sensor yang ditampilkan
  final SensorModel sensor;

  /// Callback saat card di-tap (navigasi ke detail)
  final VoidCallback onTap;

  const SensorCard({
    super.key,
    required this.sensor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Nama Device
              Row(
                children: [
                  // Icon perangkat dengan background warna
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getDeviceIcon(),
                      color: kPrimaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nama device
                  Expanded(
                    child: Text(
                      sensor.deviceName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Suhu - besar dan menonjol
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.thermostat,
                    color: _getTemperatureColor(),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${sensor.temperature}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _getTemperatureColor(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      '°C',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Kelembapan
              Row(
                children: [
                  const Icon(
                    Icons.water_drop,
                    color: Color(0xFF42A5F5),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${sensor.humidity}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Status Lampu & Kipas (dot indicators)
              Row(
                children: [
                  // Status Lampu
                  _buildStatusDot(
                    icon: Icons.lightbulb_outline,
                    isOn: sensor.statusLamp,
                    label: 'Lamp',
                  ),
                  const SizedBox(width: 12),
                  // Status Kipas
                  _buildStatusDot(
                    icon: Icons.air,
                    isOn: sensor.statusFan,
                    label: 'Fan',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget dot indicator untuk status ON/OFF
  Widget _buildStatusDot({
    required IconData icon,
    required bool isOn,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dot indicator (hijau = ON, abu-abu = OFF)
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isOn ? kOnlineColor : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          icon,
          size: 14,
          color: isOn ? kOnlineColor : Colors.grey.shade400,
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isOn ? kOnlineColor : Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Menentukan icon berdasarkan nama device
  IconData _getDeviceIcon() {
    final name = sensor.deviceName.toLowerCase();
    if (name.contains('server')) return Icons.dns;
    if (name.contains('meeting')) return Icons.meeting_room;
    if (name.contains('lab')) return Icons.computer;
    if (name.contains('perpustakaan')) return Icons.local_library;
    if (name.contains('lobby')) return Icons.door_front_door;
    return Icons.sensors;
  }

  /// Menentukan warna suhu berdasarkan nilai
  /// - >= 30°C : Merah (panas)
  /// - 24-29°C : Hijau (normal)
  /// - < 24°C  : Biru (dingin)
  Color _getTemperatureColor() {
    if (sensor.temperature >= 30) return kHotColor;
    if (sensor.temperature >= 24) return kNormalColor;
    return kColdColor;
  }
}
