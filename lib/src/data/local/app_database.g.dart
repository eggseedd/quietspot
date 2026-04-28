// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NoiseLogsTable extends NoiseLogs
    with TableInfo<$NoiseLogsTable, NoiseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoiseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rmsValueMeta = const VerificationMeta(
    'rmsValue',
  );
  @override
  late final GeneratedColumn<double> rmsValue = GeneratedColumn<double>(
    'rms_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedDbMeta = const VerificationMeta(
    'estimatedDb',
  );
  @override
  late final GeneratedColumn<double> estimatedDb = GeneratedColumn<double>(
    'estimated_db',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualLabelMeta = const VerificationMeta(
    'manualLabel',
  );
  @override
  late final GeneratedColumn<String> manualLabel = GeneratedColumn<String>(
    'manual_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    timestamp,
    latitude,
    longitude,
    locationName,
    rmsValue,
    estimatedDb,
    classification,
    manualLabel,
    notes,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'noise_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoiseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('rms_value')) {
      context.handle(
        _rmsValueMeta,
        rmsValue.isAcceptableOrUnknown(data['rms_value']!, _rmsValueMeta),
      );
    } else if (isInserting) {
      context.missing(_rmsValueMeta);
    }
    if (data.containsKey('estimated_db')) {
      context.handle(
        _estimatedDbMeta,
        estimatedDb.isAcceptableOrUnknown(
          data['estimated_db']!,
          _estimatedDbMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedDbMeta);
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classificationMeta);
    }
    if (data.containsKey('manual_label')) {
      context.handle(
        _manualLabelMeta,
        manualLabel.isAcceptableOrUnknown(
          data['manual_label']!,
          _manualLabelMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoiseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoiseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      )!,
      rmsValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rms_value'],
      )!,
      estimatedDb: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_db'],
      )!,
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      manualLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manual_label'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $NoiseLogsTable createAlias(String alias) {
    return $NoiseLogsTable(attachedDatabase, alias);
  }
}

class NoiseLog extends DataClass implements Insertable<NoiseLog> {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String locationName;
  final double rmsValue;
  final double estimatedDb;
  final String classification;
  final String? manualLabel;
  final String? notes;
  final bool isDeleted;
  const NoiseLog({
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
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['location_name'] = Variable<String>(locationName);
    map['rms_value'] = Variable<double>(rmsValue);
    map['estimated_db'] = Variable<double>(estimatedDb);
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || manualLabel != null) {
      map['manual_label'] = Variable<String>(manualLabel);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  NoiseLogsCompanion toCompanion(bool nullToAbsent) {
    return NoiseLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      timestamp: Value(timestamp),
      latitude: Value(latitude),
      longitude: Value(longitude),
      locationName: Value(locationName),
      rmsValue: Value(rmsValue),
      estimatedDb: Value(estimatedDb),
      classification: Value(classification),
      manualLabel: manualLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(manualLabel),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isDeleted: Value(isDeleted),
    );
  }

  factory NoiseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoiseLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      locationName: serializer.fromJson<String>(json['locationName']),
      rmsValue: serializer.fromJson<double>(json['rmsValue']),
      estimatedDb: serializer.fromJson<double>(json['estimatedDb']),
      classification: serializer.fromJson<String>(json['classification']),
      manualLabel: serializer.fromJson<String?>(json['manualLabel']),
      notes: serializer.fromJson<String?>(json['notes']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'locationName': serializer.toJson<String>(locationName),
      'rmsValue': serializer.toJson<double>(rmsValue),
      'estimatedDb': serializer.toJson<double>(estimatedDb),
      'classification': serializer.toJson<String>(classification),
      'manualLabel': serializer.toJson<String?>(manualLabel),
      'notes': serializer.toJson<String?>(notes),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  NoiseLog copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? locationName,
    double? rmsValue,
    double? estimatedDb,
    String? classification,
    Value<String?> manualLabel = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isDeleted,
  }) => NoiseLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    timestamp: timestamp ?? this.timestamp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    locationName: locationName ?? this.locationName,
    rmsValue: rmsValue ?? this.rmsValue,
    estimatedDb: estimatedDb ?? this.estimatedDb,
    classification: classification ?? this.classification,
    manualLabel: manualLabel.present ? manualLabel.value : this.manualLabel,
    notes: notes.present ? notes.value : this.notes,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  NoiseLog copyWithCompanion(NoiseLogsCompanion data) {
    return NoiseLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      rmsValue: data.rmsValue.present ? data.rmsValue.value : this.rmsValue,
      estimatedDb: data.estimatedDb.present
          ? data.estimatedDb.value
          : this.estimatedDb,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      manualLabel: data.manualLabel.present
          ? data.manualLabel.value
          : this.manualLabel,
      notes: data.notes.present ? data.notes.value : this.notes,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoiseLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('rmsValue: $rmsValue, ')
          ..write('estimatedDb: $estimatedDb, ')
          ..write('classification: $classification, ')
          ..write('manualLabel: $manualLabel, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    timestamp,
    latitude,
    longitude,
    locationName,
    rmsValue,
    estimatedDb,
    classification,
    manualLabel,
    notes,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoiseLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.locationName == this.locationName &&
          other.rmsValue == this.rmsValue &&
          other.estimatedDb == this.estimatedDb &&
          other.classification == this.classification &&
          other.manualLabel == this.manualLabel &&
          other.notes == this.notes &&
          other.isDeleted == this.isDeleted);
}

class NoiseLogsCompanion extends UpdateCompanion<NoiseLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> timestamp;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> locationName;
  final Value<double> rmsValue;
  final Value<double> estimatedDb;
  final Value<String> classification;
  final Value<String?> manualLabel;
  final Value<String?> notes;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const NoiseLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.locationName = const Value.absent(),
    this.rmsValue = const Value.absent(),
    this.estimatedDb = const Value.absent(),
    this.classification = const Value.absent(),
    this.manualLabel = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoiseLogsCompanion.insert({
    required String id,
    required String userId,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required String locationName,
    required double rmsValue,
    required double estimatedDb,
    required String classification,
    this.manualLabel = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       timestamp = Value(timestamp),
       latitude = Value(latitude),
       longitude = Value(longitude),
       locationName = Value(locationName),
       rmsValue = Value(rmsValue),
       estimatedDb = Value(estimatedDb),
       classification = Value(classification);
  static Insertable<NoiseLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? locationName,
    Expression<double>? rmsValue,
    Expression<double>? estimatedDb,
    Expression<String>? classification,
    Expression<String>? manualLabel,
    Expression<String>? notes,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationName != null) 'location_name': locationName,
      if (rmsValue != null) 'rms_value': rmsValue,
      if (estimatedDb != null) 'estimated_db': estimatedDb,
      if (classification != null) 'classification': classification,
      if (manualLabel != null) 'manual_label': manualLabel,
      if (notes != null) 'notes': notes,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoiseLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? timestamp,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String>? locationName,
    Value<double>? rmsValue,
    Value<double>? estimatedDb,
    Value<String>? classification,
    Value<String?>? manualLabel,
    Value<String?>? notes,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return NoiseLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      rmsValue: rmsValue ?? this.rmsValue,
      estimatedDb: estimatedDb ?? this.estimatedDb,
      classification: classification ?? this.classification,
      manualLabel: manualLabel ?? this.manualLabel,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (rmsValue.present) {
      map['rms_value'] = Variable<double>(rmsValue.value);
    }
    if (estimatedDb.present) {
      map['estimated_db'] = Variable<double>(estimatedDb.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (manualLabel.present) {
      map['manual_label'] = Variable<String>(manualLabel.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoiseLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('rmsValue: $rmsValue, ')
          ..write('estimatedDb: $estimatedDb, ')
          ..write('classification: $classification, ')
          ..write('manualLabel: $manualLabel, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NoiseLogsTable noiseLogs = $NoiseLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [noiseLogs];
}

typedef $$NoiseLogsTableCreateCompanionBuilder =
    NoiseLogsCompanion Function({
      required String id,
      required String userId,
      required DateTime timestamp,
      required double latitude,
      required double longitude,
      required String locationName,
      required double rmsValue,
      required double estimatedDb,
      required String classification,
      Value<String?> manualLabel,
      Value<String?> notes,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$NoiseLogsTableUpdateCompanionBuilder =
    NoiseLogsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> timestamp,
      Value<double> latitude,
      Value<double> longitude,
      Value<String> locationName,
      Value<double> rmsValue,
      Value<double> estimatedDb,
      Value<String> classification,
      Value<String?> manualLabel,
      Value<String?> notes,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$NoiseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $NoiseLogsTable> {
  $$NoiseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rmsValue => $composableBuilder(
    column: $table.rmsValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedDb => $composableBuilder(
    column: $table.estimatedDb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manualLabel => $composableBuilder(
    column: $table.manualLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoiseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoiseLogsTable> {
  $$NoiseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rmsValue => $composableBuilder(
    column: $table.rmsValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedDb => $composableBuilder(
    column: $table.estimatedDb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manualLabel => $composableBuilder(
    column: $table.manualLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoiseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoiseLogsTable> {
  $$NoiseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rmsValue =>
      $composableBuilder(column: $table.rmsValue, builder: (column) => column);

  GeneratedColumn<double> get estimatedDb => $composableBuilder(
    column: $table.estimatedDb,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manualLabel => $composableBuilder(
    column: $table.manualLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$NoiseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoiseLogsTable,
          NoiseLog,
          $$NoiseLogsTableFilterComposer,
          $$NoiseLogsTableOrderingComposer,
          $$NoiseLogsTableAnnotationComposer,
          $$NoiseLogsTableCreateCompanionBuilder,
          $$NoiseLogsTableUpdateCompanionBuilder,
          (NoiseLog, BaseReferences<_$AppDatabase, $NoiseLogsTable, NoiseLog>),
          NoiseLog,
          PrefetchHooks Function()
        > {
  $$NoiseLogsTableTableManager(_$AppDatabase db, $NoiseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoiseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoiseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoiseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String> locationName = const Value.absent(),
                Value<double> rmsValue = const Value.absent(),
                Value<double> estimatedDb = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> manualLabel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoiseLogsCompanion(
                id: id,
                userId: userId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                locationName: locationName,
                rmsValue: rmsValue,
                estimatedDb: estimatedDb,
                classification: classification,
                manualLabel: manualLabel,
                notes: notes,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime timestamp,
                required double latitude,
                required double longitude,
                required String locationName,
                required double rmsValue,
                required double estimatedDb,
                required String classification,
                Value<String?> manualLabel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoiseLogsCompanion.insert(
                id: id,
                userId: userId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                locationName: locationName,
                rmsValue: rmsValue,
                estimatedDb: estimatedDb,
                classification: classification,
                manualLabel: manualLabel,
                notes: notes,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoiseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoiseLogsTable,
      NoiseLog,
      $$NoiseLogsTableFilterComposer,
      $$NoiseLogsTableOrderingComposer,
      $$NoiseLogsTableAnnotationComposer,
      $$NoiseLogsTableCreateCompanionBuilder,
      $$NoiseLogsTableUpdateCompanionBuilder,
      (NoiseLog, BaseReferences<_$AppDatabase, $NoiseLogsTable, NoiseLog>),
      NoiseLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NoiseLogsTableTableManager get noiseLogs =>
      $$NoiseLogsTableTableManager(_db, _db.noiseLogs);
}
