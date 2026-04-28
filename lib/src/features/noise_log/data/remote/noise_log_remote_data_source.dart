import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/noise_log_model.dart';

/// Handles all Firestore operations for noise logs
class NoiseLogRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _noiseLogs = 'noiseLogs';

  /// Upload a noise log to Firestore
  Future<void> uploadNoiseLog(NoiseLogModel log) async {
    try {
      await _firestore.collection(_noiseLogs).doc(log.id).set({
        'id': log.id,
        'userId': log.userId,
        'timestamp': log.timestamp,
        'latitude': log.latitude,
        'longitude': log.longitude,
        'locationName': log.locationName,
        'rmsValue': log.rmsValue,
        'estimatedDb': log.estimatedDb,
        'classification': log.classification.name,
        'manualLabel': log.manualLabel,
        'notes': log.notes,
        'isDeleted': log.isDeleted,
        'syncedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to upload noise log: $e');
    }
  }

  /// Batch upload multiple noise logs
  Future<void> batchUploadNoiseLogs(List<NoiseLogModel> logs) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (final log in logs) {
        final docRef = _firestore.collection(_noiseLogs).doc(log.id);
        batch.set(docRef, {
          'id': log.id,
          'userId': log.userId,
          'timestamp': log.timestamp,
          'latitude': log.latitude,
          'longitude': log.longitude,
          'locationName': log.locationName,
          'rmsValue': log.rmsValue,
          'estimatedDb': log.estimatedDb,
          'classification': log.classification.name,
          'manualLabel': log.manualLabel,
          'notes': log.notes,
          'isDeleted': log.isDeleted,
          'syncedAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch upload noise logs: $e');
    }
  }

  /// Fetch all noise logs from Firestore
  Future<List<NoiseLogModel>> fetchAllNoiseLogs() async {
    try {
      final snapshot = await _firestore
          .collection(_noiseLogs)
          .where('isDeleted', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return _noiseLogFromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch noise logs: $e');
    }
  }

  /// Fetch noise logs within a geographic radius
  /// Uses simple distance calculation - for large datasets, consider geohashing
  Future<List<NoiseLogModel>> fetchNearbyNoiseLogs({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    try {
      // Firestore doesn't have native geospatial queries, so we fetch in a bounding box
      // and filter in Dart
      final latDelta = radiusInKm / 111.0; // ~1 degree = 111km
      final lonDelta = radiusInKm / (111.0 * cos(_degreesToRadians(latitude))); // Adjust for latitude

      final snapshot = await _firestore
          .collection(_noiseLogs)
          .where('isDeleted', isEqualTo: false)
          .where('latitude',
              isGreaterThanOrEqualTo: latitude - latDelta,
              isLessThanOrEqualTo: latitude + latDelta)
          .orderBy('latitude')
          .get();

      // Filter by longitude and calculate exact distance
      final nearbyLogs = snapshot.docs
          .map((doc) => _noiseLogFromFirestore(doc))
          .where((log) {
            // Check longitude bounds
            if (log.longitude < longitude - lonDelta || 
                log.longitude > longitude + lonDelta) {
              return false;
            }

            // Calculate actual distance using Haversine formula
            final distance = _calculateDistance(
              latitude,
              longitude,
              log.latitude,
              log.longitude,
            );

            return distance <= radiusInKm;
          })
          .toList();

      return nearbyLogs;
    } catch (e) {
      throw Exception('Failed to fetch nearby noise logs: $e');
    }
  }

  /// Fetch noise logs for a specific user
  Future<List<NoiseLogModel>> fetchLogsForUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_noiseLogs)
          .where('userId', isEqualTo: userId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return _noiseLogFromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch logs for user: $e');
    }
  }

  /// Update a noise log in Firestore
  Future<void> updateNoiseLog(NoiseLogModel log) async {
    try {
      await _firestore.collection(_noiseLogs).doc(log.id).update({
        'classification': log.classification.name,
        'manualLabel': log.manualLabel,
        'notes': log.notes,
        'isDeleted': log.isDeleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update noise log: $e');
    }
  }

  /// Delete a noise log from Firestore (soft delete)
  Future<void> softDeleteNoiseLog(String logId) async {
    try {
      await _firestore.collection(_noiseLogs).doc(logId).update({
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to delete noise log: $e');
    }
  }

  /// Get latest sync timestamp
  Future<DateTime?> getLatestSyncTimestamp() async {
    try {
      // This is a simple approach - in production, store sync metadata separately
      final snapshot = await _firestore
          .collection(_noiseLogs)
          .orderBy('syncedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final syncedAt = snapshot.docs.first.get('syncedAt') as Timestamp?;
      return syncedAt?.toDate();
    } catch (e) {
      throw Exception('Failed to get latest sync timestamp: $e');
    }
  }

  /// Convert Firestore document to NoiseLogModel
  NoiseLogModel _noiseLogFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NoiseLogModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      locationName: data['locationName'] ?? '',
      rmsValue: (data['rmsValue'] as num?)?.toDouble() ?? 0.0,
      estimatedDb: (data['estimatedDb'] as num?)?.toDouble() ?? 0.0,
      classification: _parseClassification(data['classification']),
      manualLabel: data['manualLabel'],
      notes: data['notes'],
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  /// Parse classification string to enum
  NoiseClassification _parseClassification(dynamic value) {
    if (value == null) return NoiseClassification.moderate;

    try {
      return NoiseClassification.values.firstWhere(
        (e) => e.name == value,
        orElse: () => NoiseClassification.moderate,
      );
    } catch (e) {
      return NoiseClassification.moderate;
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * 3.141592653589793 / 180;
  }
}
