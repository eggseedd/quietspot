import 'package:drift/drift.dart';
import '../../../../data/local/app_database.dart';
import '../models/noise_log_model.dart';

class NoiseLogLocalDataSource {
  final AppDatabase _database = AppDatabase();

  Future<void> insertNoiseLog(NoiseLogModel log) async {
    await _database.into(_database.noiseLogs).insert(
      NoiseLogsCompanion(
        id: Value(log.id),
        userId: Value(log.userId),
        timestamp: Value(log.timestamp),
        latitude: Value(log.latitude),
        longitude: Value(log.longitude),
        locationName: Value(log.locationName),
        rmsValue: Value(log.rmsValue),
        estimatedDb: Value(log.estimatedDb),
        classification: Value(log.classification.name),
        manualLabel: Value(log.manualLabel),
        notes: Value(log.notes),
        isDeleted: Value(log.isDeleted),
      ),
    );
  }

  Future<List<NoiseLogModel>> fetchLogsForUser(String userId) async {
    final query = _database.select(_database.noiseLogs)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.timestamp, mode: OrderingMode.desc)]);

    final rows = await query.get();
    return rows.map((entry) {
      return NoiseLogModel(
        id: entry.id,
        userId: entry.userId,
        timestamp: entry.timestamp,
        latitude: entry.latitude,
        longitude: entry.longitude,
        locationName: entry.locationName,
        rmsValue: entry.rmsValue,
        estimatedDb: entry.estimatedDb,
        classification: NoiseClassification.values.firstWhere(
          (value) => value.name == entry.classification,
          orElse: () => NoiseClassification.moderate,
        ),
        manualLabel: entry.manualLabel,
        notes: entry.notes,
        isDeleted: entry.isDeleted,
      );
    }).toList();
  }

  Future<void> updateNoiseLog(NoiseLogModel log) async {
    final entity = _database.noiseLogs;
    await _database.update(entity).replace(
      NoiseLogsCompanion(
        id: Value(log.id),
        userId: Value(log.userId),
        timestamp: Value(log.timestamp),
        latitude: Value(log.latitude),
        longitude: Value(log.longitude),
        locationName: Value(log.locationName),
        rmsValue: Value(log.rmsValue),
        estimatedDb: Value(log.estimatedDb),
        classification: Value(log.classification.name),
        manualLabel: Value(log.manualLabel),
        notes: Value(log.notes),
        isDeleted: Value(log.isDeleted),
      ),
    );
  }

  Future<void> deleteNoiseLog(String logId) async {
    final entity = _database.noiseLogs;
    await (entity.delete()..where((tbl) => tbl.id.equals(logId))).go();
  }
}
