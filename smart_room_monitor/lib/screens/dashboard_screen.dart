import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../utils/constants.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_indicator.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

/// ============================================================
/// SCREEN - DashboardScreen
/// ============================================================
///
/// Halaman utama yang menampilkan daftar semua sensor.
///
/// Fitur:
/// - Summary cards (rata-rata suhu & kelembapan)
/// - Status indicator (Online/Cached)
/// - Grid sensor cards
/// - Pull-to-refresh
/// - Loading state (shimmer)
/// - Error state (dengan retry)
/// - Empty state
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    // Load data sensor saat screen pertama kali dibuka
    // Menggunakan addPostFrameCallback agar context sudah ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SensorProvider>().loadSensors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,

      // AppBar dengan judul dan tombol settings
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sensors, size: 24),
            SizedBox(width: 8),
            Text(
              kAppName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),

      // Body menggunakan Consumer untuk listen perubahan state
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          // STATE 1: Loading - tampilkan shimmer
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          // STATE 2: Error - tampilkan error widget
          if (provider.hasError) {
            return AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.loadSensors(),
            );
          }

          // STATE 3: Empty - tampilkan empty state
          if (provider.isEmpty) {
            return EmptyStateWidget(
              onRefresh: () => provider.loadSensors(),
            );
          }

          // STATE 4: Data tersedia - tampilkan dashboard
          return RefreshIndicator(
            // Pull-to-refresh untuk memuat ulang data
            onRefresh: () => provider.refreshSensors(),
            color: kPrimaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Indicator (Online/Cached)
                    Center(
                      child: StatusIndicator(
                        isFromCache: provider.isFromCache,
                        lastUpdated: provider.lastUpdated,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Summary Cards Row
                    _buildSummaryCards(provider),

                    const SizedBox(height: 20),

                    // Section Title
                    const Text(
                      'Daftar Sensor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${provider.sensors.length} perangkat terhubung',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Grid Sensor Cards
                    GridView.builder(
                      // Agar bisa scroll di dalam SingleChildScrollView
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: provider.sensors.length,
                      itemBuilder: (context, index) {
                        final sensor = provider.sensors[index];
                        return SensorCard(
                          sensor: sensor,
                          onTap: () {
                            // Navigasi ke Detail Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailScreen(sensorId: sensor.id),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget untuk menampilkan summary cards
  /// (rata-rata suhu, rata-rata kelembapan, lampu aktif, kipas aktif)
  Widget _buildSummaryCards(SensorProvider provider) {
    return Column(
      children: [
        // Baris 1: Suhu rata-rata & Kelembapan rata-rata
        Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                icon: Icons.thermostat,
                iconColor: kHotColor,
                title: 'Rata-rata Suhu',
                value: '${provider.averageTemperature}°C',
                bgColor: kHotColor.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryItem(
                icon: Icons.water_drop,
                iconColor: const Color(0xFF42A5F5),
                title: 'Rata-rata Kelembapan',
                value: '${provider.averageHumidity}%',
                bgColor: const Color(0xFF42A5F5).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Baris 2: Lampu aktif & Kipas aktif
        Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                icon: Icons.lightbulb,
                iconColor: kCachedColor,
                title: 'Lampu Aktif',
                value: '${provider.activeLamps}/${provider.sensors.length}',
                bgColor: kCachedColor.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryItem(
                icon: Icons.air,
                iconColor: kOnlineColor,
                title: 'Kipas Aktif',
                value: '${provider.activeFans}/${provider.sensors.length}',
                bgColor: kOnlineColor.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Widget item summary individual
  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon dengan background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          // Title & Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
