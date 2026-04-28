import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../shared/providers.dart';
import '../../../shared/services/location_service.dart';
import '../data/models/noise_log_model.dart';
import 'location_detail_screen.dart';

class SurroundingNoiseMapScreen extends ConsumerStatefulWidget {
  const SurroundingNoiseMapScreen({super.key});

  @override
  ConsumerState<SurroundingNoiseMapScreen> createState() =>
      _SurroundingNoiseMapScreenState();
}

class _SurroundingNoiseMapScreenState
    extends ConsumerState<SurroundingNoiseMapScreen> {
  late MapController _mapController;
  double _radiusKm = 2.0;
  LatLng? _userLocation;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // Schedule location fetch after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
    });
  }

  Future<void> _getUserLocation() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      
      // Request location permission first
      final hasPermission = await locationService.requestPermission();
      if (!hasPermission) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      
      final position = await locationService.getCurrentPosition();
      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  Color _getNoiseColor(NoiseClassification classification) {
    switch (classification) {
      case NoiseClassification.quiet:
        return Colors.green;
      case NoiseClassification.moderate:
        return Colors.orange;
      case NoiseClassification.noisy:
        return Colors.red;
    }
  }

  String _getClassificationLabel(NoiseClassification classification) {
    switch (classification) {
      case NoiseClassification.quiet:
        return 'Quiet';
      case NoiseClassification.moderate:
        return 'Moderate';
      case NoiseClassification.noisy:
        return 'Noisy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surrounding Noise Map'),
        elevation: 0,
      ),
      body: _isLoadingLocation
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _userLocation == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text('Unable to get your location'),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Map
                    _buildMap(),

                    // Radius Control (Top Right)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: _buildRadiusControl(),
                    ),

                    // Current Location Button (Top Left)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: _buildLocateButton(),
                    ),

                    // Legend (Bottom Left)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: _buildLegend(),
                    ),

                    // Logs List Preview (Bottom Right - shows count)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: _buildLogsCountCard(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildMap() {
    return Consumer(
      builder: (context, ref, child) {
        final nearbyLogsAsync = ref.watch(
          nearbyNoiseLogsProvider((_userLocation!.latitude, _userLocation!.longitude, _radiusKm)),
        );

        return nearbyLogsAsync.when(
          data: (logs) {
            final markers = _buildMarkers(logs as List<NoiseLogModel>);
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _userLocation!,
                initialZoom: 14.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.quietspot',
                ),
                // User location marker
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                // Radius circle
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _userLocation!,
                      radius: _radiusKm * 111 / 2, // Approximate conversion (rough)
                      useRadiusInMeter: false,
                      color: Colors.blue.withOpacity(0.1),
                      borderColor: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                // Noise log markers
                MarkerLayer(markers: markers),
              ],
            );
          },
          loading: () => Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _userLocation!,
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.quietspot',
                  ),
                ],
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
          error: (error, stackTrace) => Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _userLocation!,
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.quietspot',
                  ),
                ],
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red[900], size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading logs',
                        style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Marker> _buildMarkers(List<NoiseLogModel> logs) {
    return logs.map((log) {
      final color = _getNoiseColor(log.classification);
      return Marker(
        point: LatLng(log.latitude, log.longitude),
        width: 100,
        height: 120,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => _showLogDetails(log),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${log.estimatedDb.toStringAsFixed(1)} dB',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getClassificationLabel(log.classification),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.location_on,
                color: color,
                size: 28,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _showLogDetails(NoiseLogModel log) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildLogDetailSheet(log),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildLogDetailSheet(NoiseLogModel log) {
    final color = _getNoiseColor(log.classification);
    final dateFormatter = DateFormat('MMM d, yyyy h:mm a');

    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.locationName,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormatter.format(log.timestamp),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    _getClassificationLabel(log.classification),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Noise Level', '${log.estimatedDb.toStringAsFixed(1)} dB', Colors.blue),
            const SizedBox(height: 12),
            _buildDetailRow('RMS Value', log.rmsValue.toStringAsFixed(3), Colors.purple),
            if (log.manualLabel != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Manual Label', log.manualLabel!, Colors.green),
            ],
            if (log.notes != null && log.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  log.notes!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LocationDetailScreen(noiseLog: log),
                    ),
                  );
                },
                child: const Text('View Full Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadiusControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_radiusKm.toStringAsFixed(1)} km',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_radiusKm < 10) {
                      setState(() => _radiusKm += 0.5);
                    }
                  },
                  child: const Icon(Icons.add_circle_outline, size: 24),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    if (_radiusKm > 0.5) {
                      setState(() => _radiusKm -= 0.5);
                    }
                  },
                  child: const Icon(Icons.remove_circle_outline, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocateButton() {
    return FloatingActionButton.small(
      heroTag: 'locate',
      onPressed: () {
        if (_userLocation != null) {
          _mapController.move(_userLocation!, 14.0);
        }
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.my_location),
    );
  }

  Widget _buildLegend() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Noise Levels',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.green, 'Quiet'),
          const SizedBox(height: 6),
          _buildLegendItem(Colors.orange, 'Moderate'),
          const SizedBox(height: 6),
          _buildLegendItem(Colors.red, 'Noisy'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildLogsCountCard() {
    return Consumer(
      builder: (context, ref, child) {
        final nearbyLogsAsync = ref.watch(
          nearbyNoiseLogsProvider((_userLocation!.latitude, _userLocation!.longitude, _radiusKm)),
        );

        return nearbyLogsAsync.when(
          data: (logs) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${logs.length}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                Text(
                  'nearby logs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          loading: () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Icon(Icons.error_outline, color: Colors.red),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
