enum NoiseClassification { quiet, moderate, noisy }

class NoiseLogModel {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String locationName;
  final double rmsValue;
  final double estimatedDb;
  final NoiseClassification classification;
  final String? manualLabel;
  final String? notes;
  final bool isDeleted;

  NoiseLogModel({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.rmsValue,
    required this.estimatedDb,
    required this.classification,
    this.manualLabel,
    this.notes,
    this.isDeleted = false,
  });
}
