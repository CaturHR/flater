import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/sensor_model.dart';
import '../providers/sensor_provider.dart';
import '../utils/constants.dart';

/// ============================================================
/// SCREEN - DetailScreen
/// ============================================================
///
/// Halaman detail yang menampilkan informasi lengkap
/// satu sensor tertentu.
///
/// Menampilkan:
/// - Header dengan nama device dan icon
/// - Gauge visual suhu
/// - Detail kelembapan
/// - Status lampu (ON/OFF)
/// - Status kipas (ON/OFF)
/// - Waktu terakhir update
class DetailScreen extends StatelessWidget {
  /// ID sensor yang akan ditampilkan detailnya
  final String sensorId;

  const DetailScreen({
    super.key,
    required this.sensorId,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data sensor dari Provider berdasarkan ID
    final provider = context.watch<SensorProvider>();
    final sensor = provider.getSensorById(sensorId);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      // AppBar dengan gradient
      appBar: AppBar(
        title: Text(sensor?.deviceName ?? 'Detail Sensor'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: sensor == null
          ? const Center(
              child: Text('Sensor tidak ditemukan'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header gradient dengan info utama
                  _buildHeader(sensor),

                  // Detail cards
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Title
                        const Text(
                          'Informasi Sensor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Suhu Detail Card
                        _buildTemperatureCard(sensor),
                        const SizedBox(height: 12),

                        // Kelembapan Detail Card
                        _buildHumidityCard(sensor),
                        const SizedBox(height: 12),

                        // Status Perangkat
                        _buildDeviceStatusCard(sensor),
                        const SizedBox(height: 12),

                        // Waktu Update
                        _buildUpdateTimeCard(sensor),

                        const SizedBox(height: 20),

                        // Data source indicator
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: provider.isFromCache
                                  ? kCachedColor.withValues(alpha: 0.1)
                                  : kOnlineColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  provider.isFromCache
                                      ? Icons.cloud_off
                                      : Icons.cloud_done,
                                  size: 16,
                                  color: provider.isFromCache
                                      ? kCachedColor
                                      : kOnlineColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  provider.isFromCache
                                      ? 'Data dari Cache'
                                      : 'Data Real-time',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: provider.isFromCache
                                        ? kCachedColor
                                        : kOnlineColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Header gradient dengan icon dan info utama sensor
  Widget _buildHeader(SensorModel sensor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kPrimaryColor,
            Color(0xFF1565C0),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Icon perangkat besar
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getDeviceIcon(sensor.deviceName),
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Nama device
          Text(
            sensor.deviceName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // ID Sensor
          Text(
            'ID: ${sensor.id}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Suhu & Kelembapan besar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Suhu
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${sensor.temperature}',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '°C',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Suhu',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),

              // Divider vertical
              Container(
                height: 50,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                color: Colors.white.withValues(alpha: 0.3),
              ),

              // Kelembapan
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${sensor.humidity}',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '%',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Kelembapan',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card detail suhu dengan gauge visual
  Widget _buildTemperatureCard(SensorModel sensor) {
    final tempColor = _getTemperatureColor(sensor.temperature);
    final tempLabel = _getTemperatureLabel(sensor.temperature);

    // Progress bar: 0°C - 50°C range
    final tempProgress = (sensor.temperature / 50).clamp(0.0, 1.0);

    return _buildDetailCard(
      icon: Icons.thermostat,
      iconColor: tempColor,
      title: 'Suhu',
      children: [
        // Label suhu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${sensor.temperature}°C',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: tempColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: tempColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tempLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tempColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Progress bar visual
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: tempProgress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(tempColor),
          ),
        ),
        const SizedBox(height: 6),

        // Range label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0°C', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            Text('50°C', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ],
    );
  }

  /// Card detail kelembapan
  Widget _buildHumidityCard(SensorModel sensor) {
    final humidityProgress = (sensor.humidity / 100).clamp(0.0, 1.0);

    return _buildDetailCard(
      icon: Icons.water_drop,
      iconColor: const Color(0xFF42A5F5),
      title: 'Kelembapan',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${sensor.humidity}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF42A5F5),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF42A5F5).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getHumidityLabel(sensor.humidity),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF42A5F5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: humidityProgress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF42A5F5)),
          ),
        ),
        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            Text('100%', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ],
    );
  }

  /// Card status perangkat (lampu & kipas)
  Widget _buildDeviceStatusCard(SensorModel sensor) {
    return _buildDetailCard(
      icon: Icons.devices,
      iconColor: kPrimaryColor,
      title: 'Status Perangkat',
      children: [
        // Status Lampu
        _buildStatusRow(
          icon: Icons.lightbulb,
          label: 'Lampu',
          isOn: sensor.statusLamp,
        ),
        const Divider(height: 20),
        // Status Kipas
        _buildStatusRow(
          icon: Icons.air,
          label: 'Kipas',
          isOn: sensor.statusFan,
        ),
      ],
    );
  }

  /// Card waktu update terakhir
  Widget _buildUpdateTimeCard(SensorModel sensor) {
    final formattedDate = DateFormat('dd MMMM yyyy', 'id').format(sensor.updatedAt);
    final formattedTime = DateFormat('HH:mm:ss').format(sensor.updatedAt);

    return _buildDetailCard(
      icon: Icons.access_time,
      iconColor: Colors.grey.shade600,
      title: 'Terakhir Diperbarui',
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Template card detail yang reusable
  Widget _buildDetailCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  /// Widget row status ON/OFF
  Widget _buildStatusRow({
    required IconData icon,
    required String label,
    required bool isOn,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: isOn ? kCachedColor : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // Badge ON/OFF
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isOn
                ? kOnlineColor.withValues(alpha: 0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isOn ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isOn ? kOnlineColor : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  /// Menentukan icon berdasarkan nama device
  IconData _getDeviceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('server')) return Icons.dns;
    if (lower.contains('meeting')) return Icons.meeting_room;
    if (lower.contains('lab')) return Icons.computer;
    if (lower.contains('perpustakaan')) return Icons.local_library;
    if (lower.contains('lobby')) return Icons.door_front_door;
    return Icons.sensors;
  }

  /// Menentukan warna suhu
  Color _getTemperatureColor(double temp) {
    if (temp >= 30) return kHotColor;
    if (temp >= 24) return kNormalColor;
    return kColdColor;
  }

  /// Menentukan label suhu
  String _getTemperatureLabel(double temp) {
    if (temp >= 30) return 'Panas';
    if (temp >= 24) return 'Normal';
    return 'Dingin';
  }

  /// Menentukan label kelembapan
  String _getHumidityLabel(double humidity) {
    if (humidity >= 70) return 'Tinggi';
    if (humidity >= 50) return 'Normal';
    return 'Rendah';
  }
}
