import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/providers.dart';
import '../data/models/noise_log_model.dart';
import 'widgets/location_map.dart';

class AddNoiseLogScreen extends ConsumerStatefulWidget {
  const AddNoiseLogScreen({super.key});

  @override
  ConsumerState<AddNoiseLogScreen> createState() => _AddNoiseLogScreenState();
}

class _AddNoiseLogScreenState extends ConsumerState<AddNoiseLogScreen> {
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isRecording = false;
  double? _estimatedDb;
  double? _rmsValue;
  bool _isLoading = false;
  String? _currentLocation;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();
      
      // Get location name from coordinates
      final locationName = await locationService.getLocationName(
        position.latitude,
        position.longitude,
      );
      
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _currentLocation = locationName;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
      // Set default location if failed
      setState(() {
        _latitude = 0.0;
        _longitude = 0.0;
        _currentLocation = 'Location unavailable';
      });
    }
  }

  Future<void> _recordNoise() async {
    setState(() => _isRecording = true);
    try {
      final micService = ref.read(microphoneServiceProvider); // plain Provider, no .future

      final result = await micService.recordAndAnalyzeNoise(durationSeconds: 5);

      setState(() {
        _estimatedDb = result.estimatedDb;
        _rmsValue = result.rmsValue;
        _isRecording = false;
      });

      // Show notification after recording
      final notificationService = ref.read(notificationServiceProvider);
      final dbValue = _estimatedDb?.toStringAsFixed(1) ?? "0";
      final classification = _classifyNoise(_estimatedDb ?? 0).name.toUpperCase();
      
      await notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch.hashCode,
        title: 'Noise Level Recorded',
        body: '$dbValue dB - $classification',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recorded: ${_estimatedDb?.toStringAsFixed(1) ?? "0"} dB')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording failed: $e')),
        );
      }
      setState(() => _isRecording = false);
    }
  }

  NoiseClassification _classifyNoise(double db) {
    if (db < 50) return NoiseClassification.quiet;
    if (db < 70) return NoiseClassification.moderate;
    return NoiseClassification.noisy;
  }

  Future<void> _saveNoiseLog() async {
    if (_estimatedDb == null || _rmsValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please record a noise level first')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final currentUserId = ref.read(currentUserIdProvider);
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final noiseLog = NoiseLogModel(
        id: const Uuid().v4(),
        userId: currentUserId,
        timestamp: DateTime.now(),
        latitude: _latitude ?? 0.0,
        longitude: _longitude ?? 0.0,
        locationName: _currentLocation ?? 'Unknown Location',
        rmsValue: _rmsValue!,
        estimatedDb: _estimatedDb!,
        classification: _classifyNoise(_estimatedDb!),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      final repository = ref.read(noiseLogRepositoryProvider);
      await repository.addNoiseLog(noiseLog);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Noise log saved successfully')),
        );
        // Refresh the home screen data
        ref.refresh(noiseLogsProvider(currentUserId));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Noise Level'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Recording Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.mic,
                      size: 48,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(height: 16),
                    if (_estimatedDb != null) ...[
                      Text(
                        '${_estimatedDb!.toStringAsFixed(1)} dB',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _classifyNoise(_estimatedDb!).name.toUpperCase(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.blue[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      Text(
                        'Tap the button below to record',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isRecording || _isLoading ? null : _recordNoise,
                        icon: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                        ),
                        label: Text(
                          _isRecording ? 'Recording...' : 'Start Recording',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Location Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Your Location',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 200,
                      child: _latitude != null && _longitude != null
                          ? LocationMap(
                              latitude: _latitude!,
                              longitude: _longitude!,
                              locationName: _currentLocation ?? 'Current Location',
                              isInteractive: true,
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Notes Section
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'e.g., Traffic, construction, quiet park',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value != null && value.length > 500) {
                    return 'Notes must be less than 500 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveNoiseLog,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save Noise Log'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
