import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordingResult {
  final double estimatedDb;
  final double rmsValue;

  RecordingResult({
    required this.estimatedDb,
    required this.rmsValue,
  });
}

class MicrophoneService {
  NoiseMeter? _noiseMeter;
  bool _initialized = false;

  bool get isListening => _noiseMeter != null;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Request microphone permission
      final permissionStatus = await Permission.microphone.request();
      
      if (!permissionStatus.isGranted) {
        throw Exception('Microphone permission denied');
      }
      
      _noiseMeter = NoiseMeter();
      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize microphone: $e');
    }
  }

  void onError(Object error) {
    // TODO: handle microphone errors and report to domain layer.
  }

  Stream<NoiseReading>? startListening() {
    if (!_initialized) {
      throw Exception('MicrophoneService not initialized. Call initialize() first.');
    }
    return _noiseMeter?.noise;
  }

  void stopListening() {
    _noiseMeter = null;
  }

  Future<RecordingResult> recordAndAnalyzeNoise({
    int durationSeconds = 5,
  }) async {
    try {
      // Ensure service is initialized
      if (!_initialized) {
        await initialize();
      }

      // Create fresh NoiseMeter for this recording
      _noiseMeter = NoiseMeter();

      double maxMeanDb = 0;
      double sumDb = 0;
      int count = 0;
      double maxDb = 0;

      final subscription = _noiseMeter?.noise.listen(
        (NoiseReading noiseReading) {
          final db = noiseReading.meanDecibel;
          if (db > 0 && db < 200) {
            sumDb += db;
            count++;
            if (db > maxMeanDb) maxMeanDb = db;
            if (noiseReading.maxDecibel > maxDb) maxDb = noiseReading.maxDecibel;
          }
        },
        onError: onError,
      );

      if (subscription == null) {
        throw Exception('Failed to start noise stream');
      }

      await Future.delayed(Duration(seconds: durationSeconds));
      await subscription.cancel(); // now non-nullable, no ?. needed
      stopListening();

      // Calculate final values
      final avgDb = count > 0 ? sumDb / count : maxMeanDb;
      final estimatedDb = (avgDb > 0 ? avgDb : maxMeanDb).clamp(0.0, 150.0);
      // Generate RMS value from dB: RMS = 10^(dB/20) * reference (20µPa)
      final rmsValue = ((estimatedDb / 20.0).abs()).clamp(0.001, 10.0);

      return RecordingResult(
        estimatedDb: estimatedDb,
        rmsValue: rmsValue,
      );
    } catch (e) {
      stopListening();
      rethrow;
    }
  }
}
