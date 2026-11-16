// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Semestre Académico 2024–II'),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('book'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _totalStudySecondsMeta = const VerificationMeta(
    'totalStudySeconds',
  );
  @override
  late final GeneratedColumn<int> totalStudySeconds = GeneratedColumn<int>(
    'total_study_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastStudiedAtMeta = const VerificationMeta(
    'lastStudiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastStudiedAt =
      GeneratedColumn<DateTime>(
        'last_studied_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedPomodorosMeta =
      const VerificationMeta('completedPomodoros');
  @override
  late final GeneratedColumn<int> completedPomodoros = GeneratedColumn<int>(
    'completed_pomodoros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code,
    period,
    iconKey,
    colorValue,
    isArchived,
    totalStudySeconds,
    lastStudiedAt,
    completedPomodoros,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('total_study_seconds')) {
      context.handle(
        _totalStudySecondsMeta,
        totalStudySeconds.isAcceptableOrUnknown(
          data['total_study_seconds']!,
          _totalStudySecondsMeta,
        ),
      );
    }
    if (data.containsKey('last_studied_at')) {
      context.handle(
        _lastStudiedAtMeta,
        lastStudiedAt.isAcceptableOrUnknown(
          data['last_studied_at']!,
          _lastStudiedAtMeta,
        ),
      );
    }
    if (data.containsKey('completed_pomodoros')) {
      context.handle(
        _completedPomodorosMeta,
        completedPomodoros.isAcceptableOrUnknown(
          data['completed_pomodoros']!,
          _completedPomodorosMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      totalStudySeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_study_seconds'],
      )!,
      lastStudiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_studied_at'],
      ),
      completedPomodoros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_pomodoros'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String name;
  final String code;
  final String period;
  final String iconKey;
  final int colorValue;
  final bool isArchived;
  final int totalStudySeconds;
  final DateTime? lastStudiedAt;
  final int completedPomodoros;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.period,
    required this.iconKey,
    required this.colorValue,
    required this.isArchived,
    required this.totalStudySeconds,
    this.lastStudiedAt,
    required this.completedPomodoros,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    map['period'] = Variable<String>(period);
    map['icon_key'] = Variable<String>(iconKey);
    map['color_value'] = Variable<int>(colorValue);
    map['is_archived'] = Variable<bool>(isArchived);
    map['total_study_seconds'] = Variable<int>(totalStudySeconds);
    if (!nullToAbsent || lastStudiedAt != null) {
      map['last_studied_at'] = Variable<DateTime>(lastStudiedAt);
    }
    map['completed_pomodoros'] = Variable<int>(completedPomodoros);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
      period: Value(period),
      iconKey: Value(iconKey),
      colorValue: Value(colorValue),
      isArchived: Value(isArchived),
      totalStudySeconds: Value(totalStudySeconds),
      lastStudiedAt: lastStudiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStudiedAt),
      completedPomodoros: Value(completedPomodoros),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      period: serializer.fromJson<String>(json['period']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      totalStudySeconds: serializer.fromJson<int>(json['totalStudySeconds']),
      lastStudiedAt: serializer.fromJson<DateTime?>(json['lastStudiedAt']),
      completedPomodoros: serializer.fromJson<int>(json['completedPomodoros']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'period': serializer.toJson<String>(period),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorValue': serializer.toJson<int>(colorValue),
      'isArchived': serializer.toJson<bool>(isArchived),
      'totalStudySeconds': serializer.toJson<int>(totalStudySeconds),
      'lastStudiedAt': serializer.toJson<DateTime?>(lastStudiedAt),
      'completedPomodoros': serializer.toJson<int>(completedPomodoros),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Subject copyWith({
    String? id,
    String? name,
    String? code,
    String? period,
    String? iconKey,
    int? colorValue,
    bool? isArchived,
    int? totalStudySeconds,
    Value<DateTime?> lastStudiedAt = const Value.absent(),
    int? completedPomodoros,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Subject(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code ?? this.code,
    period: period ?? this.period,
    iconKey: iconKey ?? this.iconKey,
    colorValue: colorValue ?? this.colorValue,
    isArchived: isArchived ?? this.isArchived,
    totalStudySeconds: totalStudySeconds ?? this.totalStudySeconds,
    lastStudiedAt: lastStudiedAt.present
        ? lastStudiedAt.value
        : this.lastStudiedAt,
    completedPomodoros: completedPomodoros ?? this.completedPomodoros,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      period: data.period.present ? data.period.value : this.period,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      totalStudySeconds: data.totalStudySeconds.present
          ? data.totalStudySeconds.value
          : this.totalStudySeconds,
      lastStudiedAt: data.lastStudiedAt.present
          ? data.lastStudiedAt.value
          : this.lastStudiedAt,
      completedPomodoros: data.completedPomodoros.present
          ? data.completedPomodoros.value
          : this.completedPomodoros,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('period: $period, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('isArchived: $isArchived, ')
          ..write('totalStudySeconds: $totalStudySeconds, ')
          ..write('lastStudiedAt: $lastStudiedAt, ')
          ..write('completedPomodoros: $completedPomodoros, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    code,
    period,
    iconKey,
    colorValue,
    isArchived,
    totalStudySeconds,
    lastStudiedAt,
    completedPomodoros,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.period == this.period &&
          other.iconKey == this.iconKey &&
          other.colorValue == this.colorValue &&
          other.isArchived == this.isArchived &&
          other.totalStudySeconds == this.totalStudySeconds &&
          other.lastStudiedAt == this.lastStudiedAt &&
          other.completedPomodoros == this.completedPomodoros &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> code;
  final Value<String> period;
  final Value<String> iconKey;
  final Value<int> colorValue;
  final Value<bool> isArchived;
  final Value<int> totalStudySeconds;
  final Value<DateTime?> lastStudiedAt;
  final Value<int> completedPomodoros;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.period = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.totalStudySeconds = const Value.absent(),
    this.lastStudiedAt = const Value.absent(),
    this.completedPomodoros = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    this.code = const Value.absent(),
    this.period = const Value.absent(),
    this.iconKey = const Value.absent(),
    required int colorValue,
    this.isArchived = const Value.absent(),
    this.totalStudySeconds = const Value.absent(),
    this.lastStudiedAt = const Value.absent(),
    this.completedPomodoros = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue);
  static Insertable<Subject> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? period,
    Expression<String>? iconKey,
    Expression<int>? colorValue,
    Expression<bool>? isArchived,
    Expression<int>? totalStudySeconds,
    Expression<DateTime>? lastStudiedAt,
    Expression<int>? completedPomodoros,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (period != null) 'period': period,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorValue != null) 'color_value': colorValue,
      if (isArchived != null) 'is_archived': isArchived,
      if (totalStudySeconds != null) 'total_study_seconds': totalStudySeconds,
      if (lastStudiedAt != null) 'last_studied_at': lastStudiedAt,
      if (completedPomodoros != null) 'completed_pomodoros': completedPomodoros,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? code,
    Value<String>? period,
    Value<String>? iconKey,
    Value<int>? colorValue,
    Value<bool>? isArchived,
    Value<int>? totalStudySeconds,
    Value<DateTime?>? lastStudiedAt,
    Value<int>? completedPomodoros,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      period: period ?? this.period,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      isArchived: isArchived ?? this.isArchived,
      totalStudySeconds: totalStudySeconds ?? this.totalStudySeconds,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (totalStudySeconds.present) {
      map['total_study_seconds'] = Variable<int>(totalStudySeconds.value);
    }
    if (lastStudiedAt.present) {
      map['last_studied_at'] = Variable<DateTime>(lastStudiedAt.value);
    }
    if (completedPomodoros.present) {
      map['completed_pomodoros'] = Variable<int>(completedPomodoros.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('period: $period, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('isArchived: $isArchived, ')
          ..write('totalStudySeconds: $totalStudySeconds, ')
          ..write('lastStudiedAt: $lastStudiedAt, ')
          ..write('completedPomodoros: $completedPomodoros, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AcademicEventsTable extends AcademicEvents
    with TableInfo<$AcademicEventsTable, AcademicEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AcademicEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasDueTimeMeta = const VerificationMeta(
    'hasDueTime',
  );
  @override
  late final GeneratedColumn<bool> hasDueTime = GeneratedColumn<bool>(
    'has_due_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_due_time" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _targetPomodorosMeta = const VerificationMeta(
    'targetPomodoros',
  );
  @override
  late final GeneratedColumn<int> targetPomodoros = GeneratedColumn<int>(
    'target_pomodoros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _completedPomodorosMeta =
      const VerificationMeta('completedPomodoros');
  @override
  late final GeneratedColumn<int> completedPomodoros = GeneratedColumn<int>(
    'completed_pomodoros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _academicWeightMeta = const VerificationMeta(
    'academicWeight',
  );
  @override
  late final GeneratedColumn<int> academicWeight = GeneratedColumn<int>(
    'academic_weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPriorityMeta = const VerificationMeta(
    'isPriority',
  );
  @override
  late final GeneratedColumn<bool> isPriority = GeneratedColumn<bool>(
    'is_priority',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_priority" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    title,
    type,
    description,
    dueAt,
    hasDueTime,
    targetPomodoros,
    completedPomodoros,
    isCompleted,
    academicWeight,
    isPriority,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'academic_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AcademicEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('has_due_time')) {
      context.handle(
        _hasDueTimeMeta,
        hasDueTime.isAcceptableOrUnknown(
          data['has_due_time']!,
          _hasDueTimeMeta,
        ),
      );
    }
    if (data.containsKey('target_pomodoros')) {
      context.handle(
        _targetPomodorosMeta,
        targetPomodoros.isAcceptableOrUnknown(
          data['target_pomodoros']!,
          _targetPomodorosMeta,
        ),
      );
    }
    if (data.containsKey('completed_pomodoros')) {
      context.handle(
        _completedPomodorosMeta,
        completedPomodoros.isAcceptableOrUnknown(
          data['completed_pomodoros']!,
          _completedPomodorosMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('academic_weight')) {
      context.handle(
        _academicWeightMeta,
        academicWeight.isAcceptableOrUnknown(
          data['academic_weight']!,
          _academicWeightMeta,
        ),
      );
    }
    if (data.containsKey('is_priority')) {
      context.handle(
        _isPriorityMeta,
        isPriority.isAcceptableOrUnknown(data['is_priority']!, _isPriorityMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AcademicEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AcademicEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      hasDueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_due_time'],
      )!,
      targetPomodoros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_pomodoros'],
      )!,
      completedPomodoros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_pomodoros'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      academicWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}academic_weight'],
      )!,
      isPriority: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_priority'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AcademicEventsTable createAlias(String alias) {
    return $AcademicEventsTable(attachedDatabase, alias);
  }
}

class AcademicEvent extends DataClass implements Insertable<AcademicEvent> {
  final String id;
  final String subjectId;
  final String title;
  final String type;
  final String description;
  final DateTime dueAt;
  final bool hasDueTime;
  final int targetPomodoros;
  final int completedPomodoros;
  final bool isCompleted;
  final int academicWeight;
  final bool isPriority;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AcademicEvent({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.type,
    required this.description,
    required this.dueAt,
    required this.hasDueTime,
    required this.targetPomodoros,
    required this.completedPomodoros,
    required this.isCompleted,
    required this.academicWeight,
    required this.isPriority,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['has_due_time'] = Variable<bool>(hasDueTime);
    map['target_pomodoros'] = Variable<int>(targetPomodoros);
    map['completed_pomodoros'] = Variable<int>(completedPomodoros);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['academic_weight'] = Variable<int>(academicWeight);
    map['is_priority'] = Variable<bool>(isPriority);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AcademicEventsCompanion toCompanion(bool nullToAbsent) {
    return AcademicEventsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      title: Value(title),
      type: Value(type),
      description: Value(description),
      dueAt: Value(dueAt),
      hasDueTime: Value(hasDueTime),
      targetPomodoros: Value(targetPomodoros),
      completedPomodoros: Value(completedPomodoros),
      isCompleted: Value(isCompleted),
      academicWeight: Value(academicWeight),
      isPriority: Value(isPriority),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AcademicEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AcademicEvent(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      hasDueTime: serializer.fromJson<bool>(json['hasDueTime']),
      targetPomodoros: serializer.fromJson<int>(json['targetPomodoros']),
      completedPomodoros: serializer.fromJson<int>(json['completedPomodoros']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      academicWeight: serializer.fromJson<int>(json['academicWeight']),
      isPriority: serializer.fromJson<bool>(json['isPriority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'hasDueTime': serializer.toJson<bool>(hasDueTime),
      'targetPomodoros': serializer.toJson<int>(targetPomodoros),
      'completedPomodoros': serializer.toJson<int>(completedPomodoros),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'academicWeight': serializer.toJson<int>(academicWeight),
      'isPriority': serializer.toJson<bool>(isPriority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AcademicEvent copyWith({
    String? id,
    String? subjectId,
    String? title,
    String? type,
    String? description,
    DateTime? dueAt,
    bool? hasDueTime,
    int? targetPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
    int? academicWeight,
    bool? isPriority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AcademicEvent(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    title: title ?? this.title,
    type: type ?? this.type,
    description: description ?? this.description,
    dueAt: dueAt ?? this.dueAt,
    hasDueTime: hasDueTime ?? this.hasDueTime,
    targetPomodoros: targetPomodoros ?? this.targetPomodoros,
    completedPomodoros: completedPomodoros ?? this.completedPomodoros,
    isCompleted: isCompleted ?? this.isCompleted,
    academicWeight: academicWeight ?? this.academicWeight,
    isPriority: isPriority ?? this.isPriority,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AcademicEvent copyWithCompanion(AcademicEventsCompanion data) {
    return AcademicEvent(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      hasDueTime: data.hasDueTime.present
          ? data.hasDueTime.value
          : this.hasDueTime,
      targetPomodoros: data.targetPomodoros.present
          ? data.targetPomodoros.value
          : this.targetPomodoros,
      completedPomodoros: data.completedPomodoros.present
          ? data.completedPomodoros.value
          : this.completedPomodoros,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      academicWeight: data.academicWeight.present
          ? data.academicWeight.value
          : this.academicWeight,
      isPriority: data.isPriority.present
          ? data.isPriority.value
          : this.isPriority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AcademicEvent(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('dueAt: $dueAt, ')
          ..write('hasDueTime: $hasDueTime, ')
          ..write('targetPomodoros: $targetPomodoros, ')
          ..write('completedPomodoros: $completedPomodoros, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('academicWeight: $academicWeight, ')
          ..write('isPriority: $isPriority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    title,
    type,
    description,
    dueAt,
    hasDueTime,
    targetPomodoros,
    completedPomodoros,
    isCompleted,
    academicWeight,
    isPriority,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AcademicEvent &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.type == this.type &&
          other.description == this.description &&
          other.dueAt == this.dueAt &&
          other.hasDueTime == this.hasDueTime &&
          other.targetPomodoros == this.targetPomodoros &&
          other.completedPomodoros == this.completedPomodoros &&
          other.isCompleted == this.isCompleted &&
          other.academicWeight == this.academicWeight &&
          other.isPriority == this.isPriority &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AcademicEventsCompanion extends UpdateCompanion<AcademicEvent> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<String> type;
  final Value<String> description;
  final Value<DateTime> dueAt;
  final Value<bool> hasDueTime;
  final Value<int> targetPomodoros;
  final Value<int> completedPomodoros;
  final Value<bool> isCompleted;
  final Value<int> academicWeight;
  final Value<bool> isPriority;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AcademicEventsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.hasDueTime = const Value.absent(),
    this.targetPomodoros = const Value.absent(),
    this.completedPomodoros = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.academicWeight = const Value.absent(),
    this.isPriority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AcademicEventsCompanion.insert({
    required String id,
    required String subjectId,
    required String title,
    required String type,
    this.description = const Value.absent(),
    required DateTime dueAt,
    this.hasDueTime = const Value.absent(),
    this.targetPomodoros = const Value.absent(),
    this.completedPomodoros = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.academicWeight = const Value.absent(),
    this.isPriority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       title = Value(title),
       type = Value(type),
       dueAt = Value(dueAt);
  static Insertable<AcademicEvent> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? description,
    Expression<DateTime>? dueAt,
    Expression<bool>? hasDueTime,
    Expression<int>? targetPomodoros,
    Expression<int>? completedPomodoros,
    Expression<bool>? isCompleted,
    Expression<int>? academicWeight,
    Expression<bool>? isPriority,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (dueAt != null) 'due_at': dueAt,
      if (hasDueTime != null) 'has_due_time': hasDueTime,
      if (targetPomodoros != null) 'target_pomodoros': targetPomodoros,
      if (completedPomodoros != null) 'completed_pomodoros': completedPomodoros,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (academicWeight != null) 'academic_weight': academicWeight,
      if (isPriority != null) 'is_priority': isPriority,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AcademicEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String>? title,
    Value<String>? type,
    Value<String>? description,
    Value<DateTime>? dueAt,
    Value<bool>? hasDueTime,
    Value<int>? targetPomodoros,
    Value<int>? completedPomodoros,
    Value<bool>? isCompleted,
    Value<int>? academicWeight,
    Value<bool>? isPriority,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AcademicEventsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      hasDueTime: hasDueTime ?? this.hasDueTime,
      targetPomodoros: targetPomodoros ?? this.targetPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
      academicWeight: academicWeight ?? this.academicWeight,
      isPriority: isPriority ?? this.isPriority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (hasDueTime.present) {
      map['has_due_time'] = Variable<bool>(hasDueTime.value);
    }
    if (targetPomodoros.present) {
      map['target_pomodoros'] = Variable<int>(targetPomodoros.value);
    }
    if (completedPomodoros.present) {
      map['completed_pomodoros'] = Variable<int>(completedPomodoros.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (academicWeight.present) {
      map['academic_weight'] = Variable<int>(academicWeight.value);
    }
    if (isPriority.present) {
      map['is_priority'] = Variable<bool>(isPriority.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AcademicEventsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('dueAt: $dueAt, ')
          ..write('hasDueTime: $hasDueTime, ')
          ..write('targetPomodoros: $targetPomodoros, ')
          ..write('completedPomodoros: $completedPomodoros, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('academicWeight: $academicWeight, ')
          ..write('isPriority: $isPriority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _academicEventIdMeta = const VerificationMeta(
    'academicEventId',
  );
  @override
  late final GeneratedColumn<String> academicEventId = GeneratedColumn<String>(
    'academic_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES academic_events (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    academicEventId,
    startedAt,
    completedAt,
    durationSeconds,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('academic_event_id')) {
      context.handle(
        _academicEventIdMeta,
        academicEventId.isAcceptableOrUnknown(
          data['academic_event_id']!,
          _academicEventIdMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      ),
      academicEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_event_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final String id;
  final String? subjectId;
  final String? academicEventId;
  final DateTime startedAt;
  final DateTime completedAt;
  final int durationSeconds;
  final String status;
  final DateTime createdAt;
  const FocusSession({
    required this.id,
    this.subjectId,
    this.academicEventId,
    required this.startedAt,
    required this.completedAt,
    required this.durationSeconds,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<String>(subjectId);
    }
    if (!nullToAbsent || academicEventId != null) {
      map['academic_event_id'] = Variable<String>(academicEventId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      academicEventId: academicEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(academicEventId),
      startedAt: Value(startedAt),
      completedAt: Value(completedAt),
      durationSeconds: Value(durationSeconds),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String?>(json['subjectId']),
      academicEventId: serializer.fromJson<String?>(json['academicEventId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String?>(subjectId),
      'academicEventId': serializer.toJson<String?>(academicEventId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FocusSession copyWith({
    String? id,
    Value<String?> subjectId = const Value.absent(),
    Value<String?> academicEventId = const Value.absent(),
    DateTime? startedAt,
    DateTime? completedAt,
    int? durationSeconds,
    String? status,
    DateTime? createdAt,
  }) => FocusSession(
    id: id ?? this.id,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    academicEventId: academicEventId.present
        ? academicEventId.value
        : this.academicEventId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      academicEventId: data.academicEventId.present
          ? data.academicEventId.value
          : this.academicEventId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('academicEventId: $academicEventId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    academicEventId,
    startedAt,
    completedAt,
    durationSeconds,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.academicEventId == this.academicEventId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<String> id;
  final Value<String?> subjectId;
  final Value<String?> academicEventId;
  final Value<DateTime> startedAt;
  final Value<DateTime> completedAt;
  final Value<int> durationSeconds;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.academicEventId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.subjectId = const Value.absent(),
    this.academicEventId = const Value.absent(),
    required DateTime startedAt,
    required DateTime completedAt,
    required int durationSeconds,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       completedAt = Value(completedAt),
       durationSeconds = Value(durationSeconds);
  static Insertable<FocusSession> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? academicEventId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? durationSeconds,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (academicEventId != null) 'academic_event_id': academicEventId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? subjectId,
    Value<String?>? academicEventId,
    Value<DateTime>? startedAt,
    Value<DateTime>? completedAt,
    Value<int>? durationSeconds,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      academicEventId: academicEventId ?? this.academicEventId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (academicEventId.present) {
      map['academic_event_id'] = Variable<String>(academicEventId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('academicEventId: $academicEventId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PomodoroSettingsEntriesTable extends PomodoroSettingsEntries
    with TableInfo<$PomodoroSettingsEntriesTable, PomodoroSettingsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroSettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusMinutesMeta = const VerificationMeta(
    'focusMinutes',
  );
  @override
  late final GeneratedColumn<int> focusMinutes = GeneratedColumn<int>(
    'focus_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _shortBreakMinutesMeta = const VerificationMeta(
    'shortBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> shortBreakMinutes = GeneratedColumn<int>(
    'short_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _longBreakMinutesMeta = const VerificationMeta(
    'longBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> longBreakMinutes = GeneratedColumn<int>(
    'long_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _cyclesBeforeLongBreakMeta =
      const VerificationMeta('cyclesBeforeLongBreak');
  @override
  late final GeneratedColumn<int> cyclesBeforeLongBreak = GeneratedColumn<int>(
    'cycles_before_long_break',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _autoStartBreaksMeta = const VerificationMeta(
    'autoStartBreaks',
  );
  @override
  late final GeneratedColumn<bool> autoStartBreaks = GeneratedColumn<bool>(
    'auto_start_breaks',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_breaks" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoStartFocusMeta = const VerificationMeta(
    'autoStartFocus',
  );
  @override
  late final GeneratedColumn<bool> autoStartFocus = GeneratedColumn<bool>(
    'auto_start_focus',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_focus" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _preventScreenLockMeta = const VerificationMeta(
    'preventScreenLock',
  );
  @override
  late final GeneratedColumn<bool> preventScreenLock = GeneratedColumn<bool>(
    'prevent_screen_lock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prevent_screen_lock" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dailyGoalHoursMeta = const VerificationMeta(
    'dailyGoalHours',
  );
  @override
  late final GeneratedColumn<int> dailyGoalHours = GeneratedColumn<int>(
    'daily_goal_hours',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _completionSoundMeta = const VerificationMeta(
    'completionSound',
  );
  @override
  late final GeneratedColumn<String> completionSound = GeneratedColumn<String>(
    'completion_sound',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Campana zen'),
  );
  static const VerificationMeta _themePreferenceMeta = const VerificationMeta(
    'themePreference',
  );
  @override
  late final GeneratedColumn<String> themePreference = GeneratedColumn<String>(
    'theme_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('light'),
  );
  static const VerificationMeta _use24HourFormatMeta = const VerificationMeta(
    'use24HourFormat',
  );
  @override
  late final GeneratedColumn<bool> use24HourFormat = GeneratedColumn<bool>(
    'use24_hour_format',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use24_hour_format" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _weekStartDayMeta = const VerificationMeta(
    'weekStartDay',
  );
  @override
  late final GeneratedColumn<String> weekStartDay = GeneratedColumn<String>(
    'week_start_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Lunes'),
  );
  static const VerificationMeta _notifyUnattendedSubjectsMeta =
      const VerificationMeta('notifyUnattendedSubjects');
  @override
  late final GeneratedColumn<bool> notifyUnattendedSubjects =
      GeneratedColumn<bool>(
        'notify_unattended_subjects',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notify_unattended_subjects" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _unattendedDaysThresholdMeta =
      const VerificationMeta('unattendedDaysThreshold');
  @override
  late final GeneratedColumn<int> unattendedDaysThreshold =
      GeneratedColumn<int>(
        'unattended_days_threshold',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(3),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    focusMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    cyclesBeforeLongBreak,
    autoStartBreaks,
    autoStartFocus,
    preventScreenLock,
    dailyGoalHours,
    completionSound,
    themePreference,
    use24HourFormat,
    weekStartDay,
    notifyUnattendedSubjects,
    unattendedDaysThreshold,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_settings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroSettingsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('focus_minutes')) {
      context.handle(
        _focusMinutesMeta,
        focusMinutes.isAcceptableOrUnknown(
          data['focus_minutes']!,
          _focusMinutesMeta,
        ),
      );
    }
    if (data.containsKey('short_break_minutes')) {
      context.handle(
        _shortBreakMinutesMeta,
        shortBreakMinutes.isAcceptableOrUnknown(
          data['short_break_minutes']!,
          _shortBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('long_break_minutes')) {
      context.handle(
        _longBreakMinutesMeta,
        longBreakMinutes.isAcceptableOrUnknown(
          data['long_break_minutes']!,
          _longBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cycles_before_long_break')) {
      context.handle(
        _cyclesBeforeLongBreakMeta,
        cyclesBeforeLongBreak.isAcceptableOrUnknown(
          data['cycles_before_long_break']!,
          _cyclesBeforeLongBreakMeta,
        ),
      );
    }
    if (data.containsKey('auto_start_breaks')) {
      context.handle(
        _autoStartBreaksMeta,
        autoStartBreaks.isAcceptableOrUnknown(
          data['auto_start_breaks']!,
          _autoStartBreaksMeta,
        ),
      );
    }
    if (data.containsKey('auto_start_focus')) {
      context.handle(
        _autoStartFocusMeta,
        autoStartFocus.isAcceptableOrUnknown(
          data['auto_start_focus']!,
          _autoStartFocusMeta,
        ),
      );
    }
    if (data.containsKey('prevent_screen_lock')) {
      context.handle(
        _preventScreenLockMeta,
        preventScreenLock.isAcceptableOrUnknown(
          data['prevent_screen_lock']!,
          _preventScreenLockMeta,
        ),
      );
    }
    if (data.containsKey('daily_goal_hours')) {
      context.handle(
        _dailyGoalHoursMeta,
        dailyGoalHours.isAcceptableOrUnknown(
          data['daily_goal_hours']!,
          _dailyGoalHoursMeta,
        ),
      );
    }
    if (data.containsKey('completion_sound')) {
      context.handle(
        _completionSoundMeta,
        completionSound.isAcceptableOrUnknown(
          data['completion_sound']!,
          _completionSoundMeta,
        ),
      );
    }
    if (data.containsKey('theme_preference')) {
      context.handle(
        _themePreferenceMeta,
        themePreference.isAcceptableOrUnknown(
          data['theme_preference']!,
          _themePreferenceMeta,
        ),
      );
    }
    if (data.containsKey('use24_hour_format')) {
      context.handle(
        _use24HourFormatMeta,
        use24HourFormat.isAcceptableOrUnknown(
          data['use24_hour_format']!,
          _use24HourFormatMeta,
        ),
      );
    }
    if (data.containsKey('week_start_day')) {
      context.handle(
        _weekStartDayMeta,
        weekStartDay.isAcceptableOrUnknown(
          data['week_start_day']!,
          _weekStartDayMeta,
        ),
      );
    }
    if (data.containsKey('notify_unattended_subjects')) {
      context.handle(
        _notifyUnattendedSubjectsMeta,
        notifyUnattendedSubjects.isAcceptableOrUnknown(
          data['notify_unattended_subjects']!,
          _notifyUnattendedSubjectsMeta,
        ),
      );
    }
    if (data.containsKey('unattended_days_threshold')) {
      context.handle(
        _unattendedDaysThresholdMeta,
        unattendedDaysThreshold.isAcceptableOrUnknown(
          data['unattended_days_threshold']!,
          _unattendedDaysThresholdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroSettingsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroSettingsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      focusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_minutes'],
      )!,
      shortBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_break_minutes'],
      )!,
      longBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_minutes'],
      )!,
      cyclesBeforeLongBreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycles_before_long_break'],
      )!,
      autoStartBreaks: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_breaks'],
      )!,
      autoStartFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_focus'],
      )!,
      preventScreenLock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prevent_screen_lock'],
      )!,
      dailyGoalHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_hours'],
      )!,
      completionSound: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_sound'],
      )!,
      themePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_preference'],
      )!,
      use24HourFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use24_hour_format'],
      )!,
      weekStartDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_start_day'],
      )!,
      notifyUnattendedSubjects: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_unattended_subjects'],
      )!,
      unattendedDaysThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unattended_days_threshold'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PomodoroSettingsEntriesTable createAlias(String alias) {
    return $PomodoroSettingsEntriesTable(attachedDatabase, alias);
  }
}

class PomodoroSettingsEntry extends DataClass
    implements Insertable<PomodoroSettingsEntry> {
  final int id;
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int cyclesBeforeLongBreak;
  final bool autoStartBreaks;
  final bool autoStartFocus;
  final bool preventScreenLock;
  final int dailyGoalHours;
  final String completionSound;
  final String themePreference;
  final bool use24HourFormat;
  final String weekStartDay;
  final bool notifyUnattendedSubjects;
  final int unattendedDaysThreshold;
  final DateTime updatedAt;
  const PomodoroSettingsEntry({
    required this.id,
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.cyclesBeforeLongBreak,
    required this.autoStartBreaks,
    required this.autoStartFocus,
    required this.preventScreenLock,
    required this.dailyGoalHours,
    required this.completionSound,
    required this.themePreference,
    required this.use24HourFormat,
    required this.weekStartDay,
    required this.notifyUnattendedSubjects,
    required this.unattendedDaysThreshold,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['focus_minutes'] = Variable<int>(focusMinutes);
    map['short_break_minutes'] = Variable<int>(shortBreakMinutes);
    map['long_break_minutes'] = Variable<int>(longBreakMinutes);
    map['cycles_before_long_break'] = Variable<int>(cyclesBeforeLongBreak);
    map['auto_start_breaks'] = Variable<bool>(autoStartBreaks);
    map['auto_start_focus'] = Variable<bool>(autoStartFocus);
    map['prevent_screen_lock'] = Variable<bool>(preventScreenLock);
    map['daily_goal_hours'] = Variable<int>(dailyGoalHours);
    map['completion_sound'] = Variable<String>(completionSound);
    map['theme_preference'] = Variable<String>(themePreference);
    map['use24_hour_format'] = Variable<bool>(use24HourFormat);
    map['week_start_day'] = Variable<String>(weekStartDay);
    map['notify_unattended_subjects'] = Variable<bool>(
      notifyUnattendedSubjects,
    );
    map['unattended_days_threshold'] = Variable<int>(unattendedDaysThreshold);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PomodoroSettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return PomodoroSettingsEntriesCompanion(
      id: Value(id),
      focusMinutes: Value(focusMinutes),
      shortBreakMinutes: Value(shortBreakMinutes),
      longBreakMinutes: Value(longBreakMinutes),
      cyclesBeforeLongBreak: Value(cyclesBeforeLongBreak),
      autoStartBreaks: Value(autoStartBreaks),
      autoStartFocus: Value(autoStartFocus),
      preventScreenLock: Value(preventScreenLock),
      dailyGoalHours: Value(dailyGoalHours),
      completionSound: Value(completionSound),
      themePreference: Value(themePreference),
      use24HourFormat: Value(use24HourFormat),
      weekStartDay: Value(weekStartDay),
      notifyUnattendedSubjects: Value(notifyUnattendedSubjects),
      unattendedDaysThreshold: Value(unattendedDaysThreshold),
      updatedAt: Value(updatedAt),
    );
  }

  factory PomodoroSettingsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroSettingsEntry(
      id: serializer.fromJson<int>(json['id']),
      focusMinutes: serializer.fromJson<int>(json['focusMinutes']),
      shortBreakMinutes: serializer.fromJson<int>(json['shortBreakMinutes']),
      longBreakMinutes: serializer.fromJson<int>(json['longBreakMinutes']),
      cyclesBeforeLongBreak: serializer.fromJson<int>(
        json['cyclesBeforeLongBreak'],
      ),
      autoStartBreaks: serializer.fromJson<bool>(json['autoStartBreaks']),
      autoStartFocus: serializer.fromJson<bool>(json['autoStartFocus']),
      preventScreenLock: serializer.fromJson<bool>(json['preventScreenLock']),
      dailyGoalHours: serializer.fromJson<int>(json['dailyGoalHours']),
      completionSound: serializer.fromJson<String>(json['completionSound']),
      themePreference: serializer.fromJson<String>(json['themePreference']),
      use24HourFormat: serializer.fromJson<bool>(json['use24HourFormat']),
      weekStartDay: serializer.fromJson<String>(json['weekStartDay']),
      notifyUnattendedSubjects: serializer.fromJson<bool>(
        json['notifyUnattendedSubjects'],
      ),
      unattendedDaysThreshold: serializer.fromJson<int>(
        json['unattendedDaysThreshold'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'focusMinutes': serializer.toJson<int>(focusMinutes),
      'shortBreakMinutes': serializer.toJson<int>(shortBreakMinutes),
      'longBreakMinutes': serializer.toJson<int>(longBreakMinutes),
      'cyclesBeforeLongBreak': serializer.toJson<int>(cyclesBeforeLongBreak),
      'autoStartBreaks': serializer.toJson<bool>(autoStartBreaks),
      'autoStartFocus': serializer.toJson<bool>(autoStartFocus),
      'preventScreenLock': serializer.toJson<bool>(preventScreenLock),
      'dailyGoalHours': serializer.toJson<int>(dailyGoalHours),
      'completionSound': serializer.toJson<String>(completionSound),
      'themePreference': serializer.toJson<String>(themePreference),
      'use24HourFormat': serializer.toJson<bool>(use24HourFormat),
      'weekStartDay': serializer.toJson<String>(weekStartDay),
      'notifyUnattendedSubjects': serializer.toJson<bool>(
        notifyUnattendedSubjects,
      ),
      'unattendedDaysThreshold': serializer.toJson<int>(
        unattendedDaysThreshold,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PomodoroSettingsEntry copyWith({
    int? id,
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? cyclesBeforeLongBreak,
    bool? autoStartBreaks,
    bool? autoStartFocus,
    bool? preventScreenLock,
    int? dailyGoalHours,
    String? completionSound,
    String? themePreference,
    bool? use24HourFormat,
    String? weekStartDay,
    bool? notifyUnattendedSubjects,
    int? unattendedDaysThreshold,
    DateTime? updatedAt,
  }) => PomodoroSettingsEntry(
    id: id ?? this.id,
    focusMinutes: focusMinutes ?? this.focusMinutes,
    shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    cyclesBeforeLongBreak: cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
    autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
    autoStartFocus: autoStartFocus ?? this.autoStartFocus,
    preventScreenLock: preventScreenLock ?? this.preventScreenLock,
    dailyGoalHours: dailyGoalHours ?? this.dailyGoalHours,
    completionSound: completionSound ?? this.completionSound,
    themePreference: themePreference ?? this.themePreference,
    use24HourFormat: use24HourFormat ?? this.use24HourFormat,
    weekStartDay: weekStartDay ?? this.weekStartDay,
    notifyUnattendedSubjects:
        notifyUnattendedSubjects ?? this.notifyUnattendedSubjects,
    unattendedDaysThreshold:
        unattendedDaysThreshold ?? this.unattendedDaysThreshold,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PomodoroSettingsEntry copyWithCompanion(
    PomodoroSettingsEntriesCompanion data,
  ) {
    return PomodoroSettingsEntry(
      id: data.id.present ? data.id.value : this.id,
      focusMinutes: data.focusMinutes.present
          ? data.focusMinutes.value
          : this.focusMinutes,
      shortBreakMinutes: data.shortBreakMinutes.present
          ? data.shortBreakMinutes.value
          : this.shortBreakMinutes,
      longBreakMinutes: data.longBreakMinutes.present
          ? data.longBreakMinutes.value
          : this.longBreakMinutes,
      cyclesBeforeLongBreak: data.cyclesBeforeLongBreak.present
          ? data.cyclesBeforeLongBreak.value
          : this.cyclesBeforeLongBreak,
      autoStartBreaks: data.autoStartBreaks.present
          ? data.autoStartBreaks.value
          : this.autoStartBreaks,
      autoStartFocus: data.autoStartFocus.present
          ? data.autoStartFocus.value
          : this.autoStartFocus,
      preventScreenLock: data.preventScreenLock.present
          ? data.preventScreenLock.value
          : this.preventScreenLock,
      dailyGoalHours: data.dailyGoalHours.present
          ? data.dailyGoalHours.value
          : this.dailyGoalHours,
      completionSound: data.completionSound.present
          ? data.completionSound.value
          : this.completionSound,
      themePreference: data.themePreference.present
          ? data.themePreference.value
          : this.themePreference,
      use24HourFormat: data.use24HourFormat.present
          ? data.use24HourFormat.value
          : this.use24HourFormat,
      weekStartDay: data.weekStartDay.present
          ? data.weekStartDay.value
          : this.weekStartDay,
      notifyUnattendedSubjects: data.notifyUnattendedSubjects.present
          ? data.notifyUnattendedSubjects.value
          : this.notifyUnattendedSubjects,
      unattendedDaysThreshold: data.unattendedDaysThreshold.present
          ? data.unattendedDaysThreshold.value
          : this.unattendedDaysThreshold,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSettingsEntry(')
          ..write('id: $id, ')
          ..write('focusMinutes: $focusMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('cyclesBeforeLongBreak: $cyclesBeforeLongBreak, ')
          ..write('autoStartBreaks: $autoStartBreaks, ')
          ..write('autoStartFocus: $autoStartFocus, ')
          ..write('preventScreenLock: $preventScreenLock, ')
          ..write('dailyGoalHours: $dailyGoalHours, ')
          ..write('completionSound: $completionSound, ')
          ..write('themePreference: $themePreference, ')
          ..write('use24HourFormat: $use24HourFormat, ')
          ..write('weekStartDay: $weekStartDay, ')
          ..write('notifyUnattendedSubjects: $notifyUnattendedSubjects, ')
          ..write('unattendedDaysThreshold: $unattendedDaysThreshold, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    focusMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    cyclesBeforeLongBreak,
    autoStartBreaks,
    autoStartFocus,
    preventScreenLock,
    dailyGoalHours,
    completionSound,
    themePreference,
    use24HourFormat,
    weekStartDay,
    notifyUnattendedSubjects,
    unattendedDaysThreshold,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroSettingsEntry &&
          other.id == this.id &&
          other.focusMinutes == this.focusMinutes &&
          other.shortBreakMinutes == this.shortBreakMinutes &&
          other.longBreakMinutes == this.longBreakMinutes &&
          other.cyclesBeforeLongBreak == this.cyclesBeforeLongBreak &&
          other.autoStartBreaks == this.autoStartBreaks &&
          other.autoStartFocus == this.autoStartFocus &&
          other.preventScreenLock == this.preventScreenLock &&
          other.dailyGoalHours == this.dailyGoalHours &&
          other.completionSound == this.completionSound &&
          other.themePreference == this.themePreference &&
          other.use24HourFormat == this.use24HourFormat &&
          other.weekStartDay == this.weekStartDay &&
          other.notifyUnattendedSubjects == this.notifyUnattendedSubjects &&
          other.unattendedDaysThreshold == this.unattendedDaysThreshold &&
          other.updatedAt == this.updatedAt);
}

class PomodoroSettingsEntriesCompanion
    extends UpdateCompanion<PomodoroSettingsEntry> {
  final Value<int> id;
  final Value<int> focusMinutes;
  final Value<int> shortBreakMinutes;
  final Value<int> longBreakMinutes;
  final Value<int> cyclesBeforeLongBreak;
  final Value<bool> autoStartBreaks;
  final Value<bool> autoStartFocus;
  final Value<bool> preventScreenLock;
  final Value<int> dailyGoalHours;
  final Value<String> completionSound;
  final Value<String> themePreference;
  final Value<bool> use24HourFormat;
  final Value<String> weekStartDay;
  final Value<bool> notifyUnattendedSubjects;
  final Value<int> unattendedDaysThreshold;
  final Value<DateTime> updatedAt;
  const PomodoroSettingsEntriesCompanion({
    this.id = const Value.absent(),
    this.focusMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.cyclesBeforeLongBreak = const Value.absent(),
    this.autoStartBreaks = const Value.absent(),
    this.autoStartFocus = const Value.absent(),
    this.preventScreenLock = const Value.absent(),
    this.dailyGoalHours = const Value.absent(),
    this.completionSound = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.use24HourFormat = const Value.absent(),
    this.weekStartDay = const Value.absent(),
    this.notifyUnattendedSubjects = const Value.absent(),
    this.unattendedDaysThreshold = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PomodoroSettingsEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.focusMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.cyclesBeforeLongBreak = const Value.absent(),
    this.autoStartBreaks = const Value.absent(),
    this.autoStartFocus = const Value.absent(),
    this.preventScreenLock = const Value.absent(),
    this.dailyGoalHours = const Value.absent(),
    this.completionSound = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.use24HourFormat = const Value.absent(),
    this.weekStartDay = const Value.absent(),
    this.notifyUnattendedSubjects = const Value.absent(),
    this.unattendedDaysThreshold = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<PomodoroSettingsEntry> custom({
    Expression<int>? id,
    Expression<int>? focusMinutes,
    Expression<int>? shortBreakMinutes,
    Expression<int>? longBreakMinutes,
    Expression<int>? cyclesBeforeLongBreak,
    Expression<bool>? autoStartBreaks,
    Expression<bool>? autoStartFocus,
    Expression<bool>? preventScreenLock,
    Expression<int>? dailyGoalHours,
    Expression<String>? completionSound,
    Expression<String>? themePreference,
    Expression<bool>? use24HourFormat,
    Expression<String>? weekStartDay,
    Expression<bool>? notifyUnattendedSubjects,
    Expression<int>? unattendedDaysThreshold,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (focusMinutes != null) 'focus_minutes': focusMinutes,
      if (shortBreakMinutes != null) 'short_break_minutes': shortBreakMinutes,
      if (longBreakMinutes != null) 'long_break_minutes': longBreakMinutes,
      if (cyclesBeforeLongBreak != null)
        'cycles_before_long_break': cyclesBeforeLongBreak,
      if (autoStartBreaks != null) 'auto_start_breaks': autoStartBreaks,
      if (autoStartFocus != null) 'auto_start_focus': autoStartFocus,
      if (preventScreenLock != null) 'prevent_screen_lock': preventScreenLock,
      if (dailyGoalHours != null) 'daily_goal_hours': dailyGoalHours,
      if (completionSound != null) 'completion_sound': completionSound,
      if (themePreference != null) 'theme_preference': themePreference,
      if (use24HourFormat != null) 'use24_hour_format': use24HourFormat,
      if (weekStartDay != null) 'week_start_day': weekStartDay,
      if (notifyUnattendedSubjects != null)
        'notify_unattended_subjects': notifyUnattendedSubjects,
      if (unattendedDaysThreshold != null)
        'unattended_days_threshold': unattendedDaysThreshold,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PomodoroSettingsEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? focusMinutes,
    Value<int>? shortBreakMinutes,
    Value<int>? longBreakMinutes,
    Value<int>? cyclesBeforeLongBreak,
    Value<bool>? autoStartBreaks,
    Value<bool>? autoStartFocus,
    Value<bool>? preventScreenLock,
    Value<int>? dailyGoalHours,
    Value<String>? completionSound,
    Value<String>? themePreference,
    Value<bool>? use24HourFormat,
    Value<String>? weekStartDay,
    Value<bool>? notifyUnattendedSubjects,
    Value<int>? unattendedDaysThreshold,
    Value<DateTime>? updatedAt,
  }) {
    return PomodoroSettingsEntriesCompanion(
      id: id ?? this.id,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      cyclesBeforeLongBreak:
          cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      preventScreenLock: preventScreenLock ?? this.preventScreenLock,
      dailyGoalHours: dailyGoalHours ?? this.dailyGoalHours,
      completionSound: completionSound ?? this.completionSound,
      themePreference: themePreference ?? this.themePreference,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      weekStartDay: weekStartDay ?? this.weekStartDay,
      notifyUnattendedSubjects:
          notifyUnattendedSubjects ?? this.notifyUnattendedSubjects,
      unattendedDaysThreshold:
          unattendedDaysThreshold ?? this.unattendedDaysThreshold,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (focusMinutes.present) {
      map['focus_minutes'] = Variable<int>(focusMinutes.value);
    }
    if (shortBreakMinutes.present) {
      map['short_break_minutes'] = Variable<int>(shortBreakMinutes.value);
    }
    if (longBreakMinutes.present) {
      map['long_break_minutes'] = Variable<int>(longBreakMinutes.value);
    }
    if (cyclesBeforeLongBreak.present) {
      map['cycles_before_long_break'] = Variable<int>(
        cyclesBeforeLongBreak.value,
      );
    }
    if (autoStartBreaks.present) {
      map['auto_start_breaks'] = Variable<bool>(autoStartBreaks.value);
    }
    if (autoStartFocus.present) {
      map['auto_start_focus'] = Variable<bool>(autoStartFocus.value);
    }
    if (preventScreenLock.present) {
      map['prevent_screen_lock'] = Variable<bool>(preventScreenLock.value);
    }
    if (dailyGoalHours.present) {
      map['daily_goal_hours'] = Variable<int>(dailyGoalHours.value);
    }
    if (completionSound.present) {
      map['completion_sound'] = Variable<String>(completionSound.value);
    }
    if (themePreference.present) {
      map['theme_preference'] = Variable<String>(themePreference.value);
    }
    if (use24HourFormat.present) {
      map['use24_hour_format'] = Variable<bool>(use24HourFormat.value);
    }
    if (weekStartDay.present) {
      map['week_start_day'] = Variable<String>(weekStartDay.value);
    }
    if (notifyUnattendedSubjects.present) {
      map['notify_unattended_subjects'] = Variable<bool>(
        notifyUnattendedSubjects.value,
      );
    }
    if (unattendedDaysThreshold.present) {
      map['unattended_days_threshold'] = Variable<int>(
        unattendedDaysThreshold.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSettingsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('focusMinutes: $focusMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('cyclesBeforeLongBreak: $cyclesBeforeLongBreak, ')
          ..write('autoStartBreaks: $autoStartBreaks, ')
          ..write('autoStartFocus: $autoStartFocus, ')
          ..write('preventScreenLock: $preventScreenLock, ')
          ..write('dailyGoalHours: $dailyGoalHours, ')
          ..write('completionSound: $completionSound, ')
          ..write('themePreference: $themePreference, ')
          ..write('use24HourFormat: $use24HourFormat, ')
          ..write('weekStartDay: $weekStartDay, ')
          ..write('notifyUnattendedSubjects: $notifyUnattendedSubjects, ')
          ..write('unattendedDaysThreshold: $unattendedDaysThreshold, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PomodoroStateEntriesTable extends PomodoroStateEntries
    with TableInfo<$PomodoroStateEntriesTable, PomodoroStateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroStateEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('focus'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('idle'),
  );
  static const VerificationMeta _activeSubjectIdMeta = const VerificationMeta(
    'activeSubjectId',
  );
  @override
  late final GeneratedColumn<String> activeSubjectId = GeneratedColumn<String>(
    'active_subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeEventIdMeta = const VerificationMeta(
    'activeEventId',
  );
  @override
  late final GeneratedColumn<String> activeEventId = GeneratedColumn<String>(
    'active_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remainingSecondsMeta = const VerificationMeta(
    'remainingSeconds',
  );
  @override
  late final GeneratedColumn<int> remainingSeconds = GeneratedColumn<int>(
    'remaining_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1500),
  );
  static const VerificationMeta _totalSecondsMeta = const VerificationMeta(
    'totalSeconds',
  );
  @override
  late final GeneratedColumn<int> totalSeconds = GeneratedColumn<int>(
    'total_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1500),
  );
  static const VerificationMeta _currentCycleMeta = const VerificationMeta(
    'currentCycle',
  );
  @override
  late final GeneratedColumn<int> currentCycle = GeneratedColumn<int>(
    'current_cycle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _cyclesBeforeLongBreakMeta =
      const VerificationMeta('cyclesBeforeLongBreak');
  @override
  late final GeneratedColumn<int> cyclesBeforeLongBreak = GeneratedColumn<int>(
    'cycles_before_long_break',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _lastResumedAtMeta = const VerificationMeta(
    'lastResumedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastResumedAt =
      GeneratedColumn<DateTime>(
        'last_resumed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phase,
    status,
    activeSubjectId,
    activeEventId,
    remainingSeconds,
    totalSeconds,
    currentCycle,
    cyclesBeforeLongBreak,
    lastResumedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_state_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroStateEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('active_subject_id')) {
      context.handle(
        _activeSubjectIdMeta,
        activeSubjectId.isAcceptableOrUnknown(
          data['active_subject_id']!,
          _activeSubjectIdMeta,
        ),
      );
    }
    if (data.containsKey('active_event_id')) {
      context.handle(
        _activeEventIdMeta,
        activeEventId.isAcceptableOrUnknown(
          data['active_event_id']!,
          _activeEventIdMeta,
        ),
      );
    }
    if (data.containsKey('remaining_seconds')) {
      context.handle(
        _remainingSecondsMeta,
        remainingSeconds.isAcceptableOrUnknown(
          data['remaining_seconds']!,
          _remainingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('total_seconds')) {
      context.handle(
        _totalSecondsMeta,
        totalSeconds.isAcceptableOrUnknown(
          data['total_seconds']!,
          _totalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('current_cycle')) {
      context.handle(
        _currentCycleMeta,
        currentCycle.isAcceptableOrUnknown(
          data['current_cycle']!,
          _currentCycleMeta,
        ),
      );
    }
    if (data.containsKey('cycles_before_long_break')) {
      context.handle(
        _cyclesBeforeLongBreakMeta,
        cyclesBeforeLongBreak.isAcceptableOrUnknown(
          data['cycles_before_long_break']!,
          _cyclesBeforeLongBreakMeta,
        ),
      );
    }
    if (data.containsKey('last_resumed_at')) {
      context.handle(
        _lastResumedAtMeta,
        lastResumedAt.isAcceptableOrUnknown(
          data['last_resumed_at']!,
          _lastResumedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroStateEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroStateEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      activeSubjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_subject_id'],
      ),
      activeEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_event_id'],
      ),
      remainingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_seconds'],
      )!,
      totalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_seconds'],
      )!,
      currentCycle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_cycle'],
      )!,
      cyclesBeforeLongBreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycles_before_long_break'],
      )!,
      lastResumedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_resumed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PomodoroStateEntriesTable createAlias(String alias) {
    return $PomodoroStateEntriesTable(attachedDatabase, alias);
  }
}

class PomodoroStateEntry extends DataClass
    implements Insertable<PomodoroStateEntry> {
  final int id;
  final String phase;
  final String status;
  final String? activeSubjectId;
  final String? activeEventId;
  final int remainingSeconds;
  final int totalSeconds;
  final int currentCycle;
  final int cyclesBeforeLongBreak;
  final DateTime? lastResumedAt;
  final DateTime updatedAt;
  const PomodoroStateEntry({
    required this.id,
    required this.phase,
    required this.status,
    this.activeSubjectId,
    this.activeEventId,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.currentCycle,
    required this.cyclesBeforeLongBreak,
    this.lastResumedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phase'] = Variable<String>(phase);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || activeSubjectId != null) {
      map['active_subject_id'] = Variable<String>(activeSubjectId);
    }
    if (!nullToAbsent || activeEventId != null) {
      map['active_event_id'] = Variable<String>(activeEventId);
    }
    map['remaining_seconds'] = Variable<int>(remainingSeconds);
    map['total_seconds'] = Variable<int>(totalSeconds);
    map['current_cycle'] = Variable<int>(currentCycle);
    map['cycles_before_long_break'] = Variable<int>(cyclesBeforeLongBreak);
    if (!nullToAbsent || lastResumedAt != null) {
      map['last_resumed_at'] = Variable<DateTime>(lastResumedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PomodoroStateEntriesCompanion toCompanion(bool nullToAbsent) {
    return PomodoroStateEntriesCompanion(
      id: Value(id),
      phase: Value(phase),
      status: Value(status),
      activeSubjectId: activeSubjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeSubjectId),
      activeEventId: activeEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeEventId),
      remainingSeconds: Value(remainingSeconds),
      totalSeconds: Value(totalSeconds),
      currentCycle: Value(currentCycle),
      cyclesBeforeLongBreak: Value(cyclesBeforeLongBreak),
      lastResumedAt: lastResumedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResumedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PomodoroStateEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroStateEntry(
      id: serializer.fromJson<int>(json['id']),
      phase: serializer.fromJson<String>(json['phase']),
      status: serializer.fromJson<String>(json['status']),
      activeSubjectId: serializer.fromJson<String?>(json['activeSubjectId']),
      activeEventId: serializer.fromJson<String?>(json['activeEventId']),
      remainingSeconds: serializer.fromJson<int>(json['remainingSeconds']),
      totalSeconds: serializer.fromJson<int>(json['totalSeconds']),
      currentCycle: serializer.fromJson<int>(json['currentCycle']),
      cyclesBeforeLongBreak: serializer.fromJson<int>(
        json['cyclesBeforeLongBreak'],
      ),
      lastResumedAt: serializer.fromJson<DateTime?>(json['lastResumedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phase': serializer.toJson<String>(phase),
      'status': serializer.toJson<String>(status),
      'activeSubjectId': serializer.toJson<String?>(activeSubjectId),
      'activeEventId': serializer.toJson<String?>(activeEventId),
      'remainingSeconds': serializer.toJson<int>(remainingSeconds),
      'totalSeconds': serializer.toJson<int>(totalSeconds),
      'currentCycle': serializer.toJson<int>(currentCycle),
      'cyclesBeforeLongBreak': serializer.toJson<int>(cyclesBeforeLongBreak),
      'lastResumedAt': serializer.toJson<DateTime?>(lastResumedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PomodoroStateEntry copyWith({
    int? id,
    String? phase,
    String? status,
    Value<String?> activeSubjectId = const Value.absent(),
    Value<String?> activeEventId = const Value.absent(),
    int? remainingSeconds,
    int? totalSeconds,
    int? currentCycle,
    int? cyclesBeforeLongBreak,
    Value<DateTime?> lastResumedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => PomodoroStateEntry(
    id: id ?? this.id,
    phase: phase ?? this.phase,
    status: status ?? this.status,
    activeSubjectId: activeSubjectId.present
        ? activeSubjectId.value
        : this.activeSubjectId,
    activeEventId: activeEventId.present
        ? activeEventId.value
        : this.activeEventId,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    totalSeconds: totalSeconds ?? this.totalSeconds,
    currentCycle: currentCycle ?? this.currentCycle,
    cyclesBeforeLongBreak: cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
    lastResumedAt: lastResumedAt.present
        ? lastResumedAt.value
        : this.lastResumedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PomodoroStateEntry copyWithCompanion(PomodoroStateEntriesCompanion data) {
    return PomodoroStateEntry(
      id: data.id.present ? data.id.value : this.id,
      phase: data.phase.present ? data.phase.value : this.phase,
      status: data.status.present ? data.status.value : this.status,
      activeSubjectId: data.activeSubjectId.present
          ? data.activeSubjectId.value
          : this.activeSubjectId,
      activeEventId: data.activeEventId.present
          ? data.activeEventId.value
          : this.activeEventId,
      remainingSeconds: data.remainingSeconds.present
          ? data.remainingSeconds.value
          : this.remainingSeconds,
      totalSeconds: data.totalSeconds.present
          ? data.totalSeconds.value
          : this.totalSeconds,
      currentCycle: data.currentCycle.present
          ? data.currentCycle.value
          : this.currentCycle,
      cyclesBeforeLongBreak: data.cyclesBeforeLongBreak.present
          ? data.cyclesBeforeLongBreak.value
          : this.cyclesBeforeLongBreak,
      lastResumedAt: data.lastResumedAt.present
          ? data.lastResumedAt.value
          : this.lastResumedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroStateEntry(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('status: $status, ')
          ..write('activeSubjectId: $activeSubjectId, ')
          ..write('activeEventId: $activeEventId, ')
          ..write('remainingSeconds: $remainingSeconds, ')
          ..write('totalSeconds: $totalSeconds, ')
          ..write('currentCycle: $currentCycle, ')
          ..write('cyclesBeforeLongBreak: $cyclesBeforeLongBreak, ')
          ..write('lastResumedAt: $lastResumedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phase,
    status,
    activeSubjectId,
    activeEventId,
    remainingSeconds,
    totalSeconds,
    currentCycle,
    cyclesBeforeLongBreak,
    lastResumedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroStateEntry &&
          other.id == this.id &&
          other.phase == this.phase &&
          other.status == this.status &&
          other.activeSubjectId == this.activeSubjectId &&
          other.activeEventId == this.activeEventId &&
          other.remainingSeconds == this.remainingSeconds &&
          other.totalSeconds == this.totalSeconds &&
          other.currentCycle == this.currentCycle &&
          other.cyclesBeforeLongBreak == this.cyclesBeforeLongBreak &&
          other.lastResumedAt == this.lastResumedAt &&
          other.updatedAt == this.updatedAt);
}

class PomodoroStateEntriesCompanion
    extends UpdateCompanion<PomodoroStateEntry> {
  final Value<int> id;
  final Value<String> phase;
  final Value<String> status;
  final Value<String?> activeSubjectId;
  final Value<String?> activeEventId;
  final Value<int> remainingSeconds;
  final Value<int> totalSeconds;
  final Value<int> currentCycle;
  final Value<int> cyclesBeforeLongBreak;
  final Value<DateTime?> lastResumedAt;
  final Value<DateTime> updatedAt;
  const PomodoroStateEntriesCompanion({
    this.id = const Value.absent(),
    this.phase = const Value.absent(),
    this.status = const Value.absent(),
    this.activeSubjectId = const Value.absent(),
    this.activeEventId = const Value.absent(),
    this.remainingSeconds = const Value.absent(),
    this.totalSeconds = const Value.absent(),
    this.currentCycle = const Value.absent(),
    this.cyclesBeforeLongBreak = const Value.absent(),
    this.lastResumedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PomodoroStateEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.phase = const Value.absent(),
    this.status = const Value.absent(),
    this.activeSubjectId = const Value.absent(),
    this.activeEventId = const Value.absent(),
    this.remainingSeconds = const Value.absent(),
    this.totalSeconds = const Value.absent(),
    this.currentCycle = const Value.absent(),
    this.cyclesBeforeLongBreak = const Value.absent(),
    this.lastResumedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<PomodoroStateEntry> custom({
    Expression<int>? id,
    Expression<String>? phase,
    Expression<String>? status,
    Expression<String>? activeSubjectId,
    Expression<String>? activeEventId,
    Expression<int>? remainingSeconds,
    Expression<int>? totalSeconds,
    Expression<int>? currentCycle,
    Expression<int>? cyclesBeforeLongBreak,
    Expression<DateTime>? lastResumedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phase != null) 'phase': phase,
      if (status != null) 'status': status,
      if (activeSubjectId != null) 'active_subject_id': activeSubjectId,
      if (activeEventId != null) 'active_event_id': activeEventId,
      if (remainingSeconds != null) 'remaining_seconds': remainingSeconds,
      if (totalSeconds != null) 'total_seconds': totalSeconds,
      if (currentCycle != null) 'current_cycle': currentCycle,
      if (cyclesBeforeLongBreak != null)
        'cycles_before_long_break': cyclesBeforeLongBreak,
      if (lastResumedAt != null) 'last_resumed_at': lastResumedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PomodoroStateEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? phase,
    Value<String>? status,
    Value<String?>? activeSubjectId,
    Value<String?>? activeEventId,
    Value<int>? remainingSeconds,
    Value<int>? totalSeconds,
    Value<int>? currentCycle,
    Value<int>? cyclesBeforeLongBreak,
    Value<DateTime?>? lastResumedAt,
    Value<DateTime>? updatedAt,
  }) {
    return PomodoroStateEntriesCompanion(
      id: id ?? this.id,
      phase: phase ?? this.phase,
      status: status ?? this.status,
      activeSubjectId: activeSubjectId ?? this.activeSubjectId,
      activeEventId: activeEventId ?? this.activeEventId,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      currentCycle: currentCycle ?? this.currentCycle,
      cyclesBeforeLongBreak:
          cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
      lastResumedAt: lastResumedAt ?? this.lastResumedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (activeSubjectId.present) {
      map['active_subject_id'] = Variable<String>(activeSubjectId.value);
    }
    if (activeEventId.present) {
      map['active_event_id'] = Variable<String>(activeEventId.value);
    }
    if (remainingSeconds.present) {
      map['remaining_seconds'] = Variable<int>(remainingSeconds.value);
    }
    if (totalSeconds.present) {
      map['total_seconds'] = Variable<int>(totalSeconds.value);
    }
    if (currentCycle.present) {
      map['current_cycle'] = Variable<int>(currentCycle.value);
    }
    if (cyclesBeforeLongBreak.present) {
      map['cycles_before_long_break'] = Variable<int>(
        cyclesBeforeLongBreak.value,
      );
    }
    if (lastResumedAt.present) {
      map['last_resumed_at'] = Variable<DateTime>(lastResumedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroStateEntriesCompanion(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('status: $status, ')
          ..write('activeSubjectId: $activeSubjectId, ')
          ..write('activeEventId: $activeEventId, ')
          ..write('remainingSeconds: $remainingSeconds, ')
          ..write('totalSeconds: $totalSeconds, ')
          ..write('currentCycle: $currentCycle, ')
          ..write('cyclesBeforeLongBreak: $cyclesBeforeLongBreak, ')
          ..write('lastResumedAt: $lastResumedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StudentProfileEntriesTable extends StudentProfileEntries
    with TableInfo<$StudentProfileEntriesTable, StudentProfileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentProfileEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Alejandro Gómez'),
  );
  static const VerificationMeta _degreeNameMeta = const VerificationMeta(
    'degreeName',
  );
  @override
  late final GeneratedColumn<String> degreeName = GeneratedColumn<String>(
    'degree_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Grado en Ing. Informática'),
  );
  static const VerificationMeta _academicPeriodMeta = const VerificationMeta(
    'academicPeriod',
  );
  @override
  late final GeneratedColumn<String> academicPeriod = GeneratedColumn<String>(
    'academic_period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('2024-II'),
  );
  static const VerificationMeta _semesterMeta = const VerificationMeta(
    'semester',
  );
  @override
  late final GeneratedColumn<String> semester = GeneratedColumn<String>(
    'semester',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('4° Semestre'),
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    degreeName,
    academicPeriod,
    semester,
    avatarPath,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_profile_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentProfileEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('degree_name')) {
      context.handle(
        _degreeNameMeta,
        degreeName.isAcceptableOrUnknown(data['degree_name']!, _degreeNameMeta),
      );
    }
    if (data.containsKey('academic_period')) {
      context.handle(
        _academicPeriodMeta,
        academicPeriod.isAcceptableOrUnknown(
          data['academic_period']!,
          _academicPeriodMeta,
        ),
      );
    }
    if (data.containsKey('semester')) {
      context.handle(
        _semesterMeta,
        semester.isAcceptableOrUnknown(data['semester']!, _semesterMeta),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentProfileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentProfileEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      degreeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}degree_name'],
      )!,
      academicPeriod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_period'],
      )!,
      semester: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}semester'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StudentProfileEntriesTable createAlias(String alias) {
    return $StudentProfileEntriesTable(attachedDatabase, alias);
  }
}

class StudentProfileEntry extends DataClass
    implements Insertable<StudentProfileEntry> {
  final int id;
  final String displayName;
  final String degreeName;
  final String academicPeriod;
  final String semester;
  final String? avatarPath;
  final DateTime updatedAt;
  const StudentProfileEntry({
    required this.id,
    required this.displayName,
    required this.degreeName,
    required this.academicPeriod,
    required this.semester,
    this.avatarPath,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['degree_name'] = Variable<String>(degreeName);
    map['academic_period'] = Variable<String>(academicPeriod);
    map['semester'] = Variable<String>(semester);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudentProfileEntriesCompanion toCompanion(bool nullToAbsent) {
    return StudentProfileEntriesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      degreeName: Value(degreeName),
      academicPeriod: Value(academicPeriod),
      semester: Value(semester),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudentProfileEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentProfileEntry(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      degreeName: serializer.fromJson<String>(json['degreeName']),
      academicPeriod: serializer.fromJson<String>(json['academicPeriod']),
      semester: serializer.fromJson<String>(json['semester']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'degreeName': serializer.toJson<String>(degreeName),
      'academicPeriod': serializer.toJson<String>(academicPeriod),
      'semester': serializer.toJson<String>(semester),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudentProfileEntry copyWith({
    int? id,
    String? displayName,
    String? degreeName,
    String? academicPeriod,
    String? semester,
    Value<String?> avatarPath = const Value.absent(),
    DateTime? updatedAt,
  }) => StudentProfileEntry(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    degreeName: degreeName ?? this.degreeName,
    academicPeriod: academicPeriod ?? this.academicPeriod,
    semester: semester ?? this.semester,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StudentProfileEntry copyWithCompanion(StudentProfileEntriesCompanion data) {
    return StudentProfileEntry(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      degreeName: data.degreeName.present
          ? data.degreeName.value
          : this.degreeName,
      academicPeriod: data.academicPeriod.present
          ? data.academicPeriod.value
          : this.academicPeriod,
      semester: data.semester.present ? data.semester.value : this.semester,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfileEntry(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('degreeName: $degreeName, ')
          ..write('academicPeriod: $academicPeriod, ')
          ..write('semester: $semester, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    degreeName,
    academicPeriod,
    semester,
    avatarPath,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentProfileEntry &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.degreeName == this.degreeName &&
          other.academicPeriod == this.academicPeriod &&
          other.semester == this.semester &&
          other.avatarPath == this.avatarPath &&
          other.updatedAt == this.updatedAt);
}

class StudentProfileEntriesCompanion
    extends UpdateCompanion<StudentProfileEntry> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String> degreeName;
  final Value<String> academicPeriod;
  final Value<String> semester;
  final Value<String?> avatarPath;
  final Value<DateTime> updatedAt;
  const StudentProfileEntriesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.degreeName = const Value.absent(),
    this.academicPeriod = const Value.absent(),
    this.semester = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StudentProfileEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.degreeName = const Value.absent(),
    this.academicPeriod = const Value.absent(),
    this.semester = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<StudentProfileEntry> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? degreeName,
    Expression<String>? academicPeriod,
    Expression<String>? semester,
    Expression<String>? avatarPath,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (degreeName != null) 'degree_name': degreeName,
      if (academicPeriod != null) 'academic_period': academicPeriod,
      if (semester != null) 'semester': semester,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StudentProfileEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? displayName,
    Value<String>? degreeName,
    Value<String>? academicPeriod,
    Value<String>? semester,
    Value<String?>? avatarPath,
    Value<DateTime>? updatedAt,
  }) {
    return StudentProfileEntriesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      degreeName: degreeName ?? this.degreeName,
      academicPeriod: academicPeriod ?? this.academicPeriod,
      semester: semester ?? this.semester,
      avatarPath: avatarPath ?? this.avatarPath,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (degreeName.present) {
      map['degree_name'] = Variable<String>(degreeName.value);
    }
    if (academicPeriod.present) {
      map['academic_period'] = Variable<String>(academicPeriod.value);
    }
    if (semester.present) {
      map['semester'] = Variable<String>(semester.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfileEntriesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('degreeName: $degreeName, ')
          ..write('academicPeriod: $academicPeriod, ')
          ..write('semester: $semester, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $AcademicEventsTable academicEvents = $AcademicEventsTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $PomodoroSettingsEntriesTable pomodoroSettingsEntries =
      $PomodoroSettingsEntriesTable(this);
  late final $PomodoroStateEntriesTable pomodoroStateEntries =
      $PomodoroStateEntriesTable(this);
  late final $StudentProfileEntriesTable studentProfileEntries =
      $StudentProfileEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjects,
    academicEvents,
    focusSessions,
    pomodoroSettingsEntries,
    pomodoroStateEntries,
    studentProfileEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subjects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('academic_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subjects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'academic_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_sessions', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      required String id,
      required String name,
      Value<String> code,
      Value<String> period,
      Value<String> iconKey,
      required int colorValue,
      Value<bool> isArchived,
      Value<int> totalStudySeconds,
      Value<DateTime?> lastStudiedAt,
      Value<int> completedPomodoros,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> code,
      Value<String> period,
      Value<String> iconKey,
      Value<int> colorValue,
      Value<bool> isArchived,
      Value<int> totalStudySeconds,
      Value<DateTime?> lastStudiedAt,
      Value<int> completedPomodoros,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AcademicEventsTable, List<AcademicEvent>>
  _academicEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.academicEvents,
    aliasName: $_aliasNameGenerator(
      db.subjects.id,
      db.academicEvents.subjectId,
    ),
  );

  $$AcademicEventsTableProcessedTableManager get academicEventsRefs {
    final manager = $$AcademicEventsTableTableManager(
      $_db,
      $_db.academicEvents,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_academicEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.focusSessions.subjectId),
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalStudySeconds => $composableBuilder(
    column: $table.totalStudySeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastStudiedAt => $composableBuilder(
    column: $table.lastStudiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedPomodoros => $composableBuilder(
    column: $table.completedPomodoros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> academicEventsRefs(
    Expression<bool> Function($$AcademicEventsTableFilterComposer f) f,
  ) {
    final $$AcademicEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.academicEvents,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AcademicEventsTableFilterComposer(
            $db: $db,
            $table: $db.academicEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalStudySeconds => $composableBuilder(
    column: $table.totalStudySeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastStudiedAt => $composableBuilder(
    column: $table.lastStudiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedPomodoros => $composableBuilder(
    column: $table.completedPomodoros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalStudySeconds => $composableBuilder(
    column: $table.totalStudySeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastStudiedAt => $composableBuilder(
    column: $table.lastStudiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedPomodoros => $composableBuilder(
    column: $table.completedPomodoros,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> academicEventsRefs<T extends Object>(
    Expression<T> Function($$AcademicEventsTableAnnotationComposer a) f,
  ) {
    final $$AcademicEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.academicEvents,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AcademicEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.academicEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, $$SubjectsTableReferences),
          Subject,
          PrefetchHooks Function({
            bool academicEventsRefs,
            bool focusSessionsRefs,
          })
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> totalStudySeconds = const Value.absent(),
                Value<DateTime?> lastStudiedAt = const Value.absent(),
                Value<int> completedPomodoros = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                name: name,
                code: code,
                period: period,
                iconKey: iconKey,
                colorValue: colorValue,
                isArchived: isArchived,
                totalStudySeconds: totalStudySeconds,
                lastStudiedAt: lastStudiedAt,
                completedPomodoros: completedPomodoros,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> code = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                required int colorValue,
                Value<bool> isArchived = const Value.absent(),
                Value<int> totalStudySeconds = const Value.absent(),
                Value<DateTime?> lastStudiedAt = const Value.absent(),
                Value<int> completedPomodoros = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                name: name,
                code: code,
                period: period,
                iconKey: iconKey,
                colorValue: colorValue,
                isArchived: isArchived,
                totalStudySeconds: totalStudySeconds,
                lastStudiedAt: lastStudiedAt,
                completedPomodoros: completedPomodoros,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({academicEventsRefs = false, focusSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (academicEventsRefs) db.academicEvents,
                    if (focusSessionsRefs) db.focusSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (academicEventsRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          AcademicEvent
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._academicEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).academicEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (focusSessionsRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          FocusSession
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, $$SubjectsTableReferences),
      Subject,
      PrefetchHooks Function({bool academicEventsRefs, bool focusSessionsRefs})
    >;
typedef $$AcademicEventsTableCreateCompanionBuilder =
    AcademicEventsCompanion Function({
      required String id,
      required String subjectId,
      required String title,
      required String type,
      Value<String> description,
      required DateTime dueAt,
      Value<bool> hasDueTime,
      Value<int> targetPomodoros,
      Value<int> completedPomodoros,
      Value<bool> isCompleted,
      Value<int> academicWeight,
      Value<bool> isPriority,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AcademicEventsTableUpdateCompanionBuilder =
    AcademicEventsCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String> title,
      Value<String> type,
      Value<String> description,
      Value<DateTime> dueAt,
      Value<bool> hasDueTime,
      Value<int> targetPomodoros,
      Value<int> completedPomodoros,
      Value<bool> isCompleted,
      Value<int> academicWeight,
      Value<bool> isPriority,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AcademicEventsTableReferences
    extends BaseReferences<_$AppDatabase, $AcademicEventsTable, AcademicEvent> {
  $$AcademicEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.academicEvents.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: $_aliasNameGenerator(
      db.academicEvents.id,
      db.focusSessions.academicEventId,
    ),
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager($_db, $_db.focusSessions)
        .filter(
          (f) => f.academicEventId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AcademicEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AcademicEventsTable> {
  $$AcademicEventsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasDueTime => $composableBuilder(
    column: $table.hasDueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPomodoros => $composableBuilder(
    column: $table.targetPomodoros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedPomodoros => $composableBuilder(
    column: $table.completedPomodoros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get academicWeight => $composableBuilder(
    column: $table.academicWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPriority => $composableBuilder(
    column: $table.isPriority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.academicEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AcademicEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AcademicEventsTable> {
  $$AcademicEventsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasDueTime => $composableBuilder(
    column: $table.hasDueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPomodoros => $composableBuilder(
    column: $table.targetPomodoros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedPomodoros => $composableBuilder(
    column: $table.completedPomodoros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get academicWeight => $composableBuilder(
    column: $table.academicWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPriority => $composableBuilder(
    column: $table.isPriority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AcademicEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AcademicEventsTable> {
  $$AcademicEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get hasDueTime => $composableBuilder(
    column: $table.hasDueTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetPomodoros => $composableBuilder(
    column: $table.targetPomodoros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedPomodoros => $composableBuilder(
    column: $table.completedPomodoros,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get academicWeight => $composableBuilder(
    column: $table.academicWeight,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPriority => $composableBuilder(
    column: $table.isPriority,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.academicEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AcademicEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AcademicEventsTable,
          AcademicEvent,
          $$AcademicEventsTableFilterComposer,
          $$AcademicEventsTableOrderingComposer,
          $$AcademicEventsTableAnnotationComposer,
          $$AcademicEventsTableCreateCompanionBuilder,
          $$AcademicEventsTableUpdateCompanionBuilder,
          (AcademicEvent, $$AcademicEventsTableReferences),
          AcademicEvent,
          PrefetchHooks Function({bool subjectId, bool focusSessionsRefs})
        > {
  $$AcademicEventsTableTableManager(
    _$AppDatabase db,
    $AcademicEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AcademicEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AcademicEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AcademicEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<bool> hasDueTime = const Value.absent(),
                Value<int> targetPomodoros = const Value.absent(),
                Value<int> completedPomodoros = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> academicWeight = const Value.absent(),
                Value<bool> isPriority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AcademicEventsCompanion(
                id: id,
                subjectId: subjectId,
                title: title,
                type: type,
                description: description,
                dueAt: dueAt,
                hasDueTime: hasDueTime,
                targetPomodoros: targetPomodoros,
                completedPomodoros: completedPomodoros,
                isCompleted: isCompleted,
                academicWeight: academicWeight,
                isPriority: isPriority,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required String title,
                required String type,
                Value<String> description = const Value.absent(),
                required DateTime dueAt,
                Value<bool> hasDueTime = const Value.absent(),
                Value<int> targetPomodoros = const Value.absent(),
                Value<int> completedPomodoros = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> academicWeight = const Value.absent(),
                Value<bool> isPriority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AcademicEventsCompanion.insert(
                id: id,
                subjectId: subjectId,
                title: title,
                type: type,
                description: description,
                dueAt: dueAt,
                hasDueTime: hasDueTime,
                targetPomodoros: targetPomodoros,
                completedPomodoros: completedPomodoros,
                isCompleted: isCompleted,
                academicWeight: academicWeight,
                isPriority: isPriority,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AcademicEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({subjectId = false, focusSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusSessionsRefs) db.focusSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable:
                                        $$AcademicEventsTableReferences
                                            ._subjectIdTable(db),
                                    referencedColumn:
                                        $$AcademicEventsTableReferences
                                            ._subjectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (focusSessionsRefs)
                        await $_getPrefetchedData<
                          AcademicEvent,
                          $AcademicEventsTable,
                          FocusSession
                        >(
                          currentTable: table,
                          referencedTable: $$AcademicEventsTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AcademicEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.academicEventId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AcademicEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AcademicEventsTable,
      AcademicEvent,
      $$AcademicEventsTableFilterComposer,
      $$AcademicEventsTableOrderingComposer,
      $$AcademicEventsTableAnnotationComposer,
      $$AcademicEventsTableCreateCompanionBuilder,
      $$AcademicEventsTableUpdateCompanionBuilder,
      (AcademicEvent, $$AcademicEventsTableReferences),
      AcademicEvent,
      PrefetchHooks Function({bool subjectId, bool focusSessionsRefs})
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<String?> subjectId,
      Value<String?> academicEventId,
      required DateTime startedAt,
      required DateTime completedAt,
      required int durationSeconds,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<String?> subjectId,
      Value<String?> academicEventId,
      Value<DateTime> startedAt,
      Value<DateTime> completedAt,
      Value<int> durationSeconds,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$FocusSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession> {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.focusSessions.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager? get subjectId {
    final $_column = $_itemColumn<String>('subject_id');
    if ($_column == null) return null;
    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AcademicEventsTable _academicEventIdTable(_$AppDatabase db) =>
      db.academicEvents.createAlias(
        $_aliasNameGenerator(
          db.focusSessions.academicEventId,
          db.academicEvents.id,
        ),
      );

  $$AcademicEventsTableProcessedTableManager? get academicEventId {
    final $_column = $_itemColumn<String>('academic_event_id');
    if ($_column == null) return null;
    final manager = $$AcademicEventsTableTableManager(
      $_db,
      $_db.academicEvents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_academicEventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AcademicEventsTableFilterComposer get academicEventId {
    final $$AcademicEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.academicEventId,
      referencedTable: $db.academicEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AcademicEventsTableFilterComposer(
            $db: $db,
            $table: $db.academicEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AcademicEventsTableOrderingComposer get academicEventId {
    final $$AcademicEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.academicEventId,
      referencedTable: $db.academicEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AcademicEventsTableOrderingComposer(
            $db: $db,
            $table: $db.academicEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AcademicEventsTableAnnotationComposer get academicEventId {
    final $$AcademicEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.academicEventId,
      referencedTable: $db.academicEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AcademicEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.academicEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSession, $$FocusSessionsTableReferences),
          FocusSession,
          PrefetchHooks Function({bool subjectId, bool academicEventId})
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                Value<String?> academicEventId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                subjectId: subjectId,
                academicEventId: academicEventId,
                startedAt: startedAt,
                completedAt: completedAt,
                durationSeconds: durationSeconds,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> subjectId = const Value.absent(),
                Value<String?> academicEventId = const Value.absent(),
                required DateTime startedAt,
                required DateTime completedAt,
                required int durationSeconds,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                subjectId: subjectId,
                academicEventId: academicEventId,
                startedAt: startedAt,
                completedAt: completedAt,
                durationSeconds: durationSeconds,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({subjectId = false, academicEventId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable:
                                        $$FocusSessionsTableReferences
                                            ._subjectIdTable(db),
                                    referencedColumn:
                                        $$FocusSessionsTableReferences
                                            ._subjectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (academicEventId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.academicEventId,
                                    referencedTable:
                                        $$FocusSessionsTableReferences
                                            ._academicEventIdTable(db),
                                    referencedColumn:
                                        $$FocusSessionsTableReferences
                                            ._academicEventIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSession, $$FocusSessionsTableReferences),
      FocusSession,
      PrefetchHooks Function({bool subjectId, bool academicEventId})
    >;
typedef $$PomodoroSettingsEntriesTableCreateCompanionBuilder =
    PomodoroSettingsEntriesCompanion Function({
      Value<int> id,
      Value<int> focusMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> cyclesBeforeLongBreak,
      Value<bool> autoStartBreaks,
      Value<bool> autoStartFocus,
      Value<bool> preventScreenLock,
      Value<int> dailyGoalHours,
      Value<String> completionSound,
      Value<String> themePreference,
      Value<bool> use24HourFormat,
      Value<String> weekStartDay,
      Value<bool> notifyUnattendedSubjects,
      Value<int> unattendedDaysThreshold,
      Value<DateTime> updatedAt,
    });
typedef $$PomodoroSettingsEntriesTableUpdateCompanionBuilder =
    PomodoroSettingsEntriesCompanion Function({
      Value<int> id,
      Value<int> focusMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> cyclesBeforeLongBreak,
      Value<bool> autoStartBreaks,
      Value<bool> autoStartFocus,
      Value<bool> preventScreenLock,
      Value<int> dailyGoalHours,
      Value<String> completionSound,
      Value<String> themePreference,
      Value<bool> use24HourFormat,
      Value<String> weekStartDay,
      Value<bool> notifyUnattendedSubjects,
      Value<int> unattendedDaysThreshold,
      Value<DateTime> updatedAt,
    });

class $$PomodoroSettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroSettingsEntriesTable> {
  $$PomodoroSettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cyclesBeforeLongBreak => $composableBuilder(
    column: $table.cyclesBeforeLongBreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartBreaks => $composableBuilder(
    column: $table.autoStartBreaks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get preventScreenLock => $composableBuilder(
    column: $table.preventScreenLock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalHours => $composableBuilder(
    column: $table.dailyGoalHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionSound => $composableBuilder(
    column: $table.completionSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get use24HourFormat => $composableBuilder(
    column: $table.use24HourFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekStartDay => $composableBuilder(
    column: $table.weekStartDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyUnattendedSubjects => $composableBuilder(
    column: $table.notifyUnattendedSubjects,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unattendedDaysThreshold => $composableBuilder(
    column: $table.unattendedDaysThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroSettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroSettingsEntriesTable> {
  $$PomodoroSettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cyclesBeforeLongBreak => $composableBuilder(
    column: $table.cyclesBeforeLongBreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartBreaks => $composableBuilder(
    column: $table.autoStartBreaks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get preventScreenLock => $composableBuilder(
    column: $table.preventScreenLock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalHours => $composableBuilder(
    column: $table.dailyGoalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionSound => $composableBuilder(
    column: $table.completionSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get use24HourFormat => $composableBuilder(
    column: $table.use24HourFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekStartDay => $composableBuilder(
    column: $table.weekStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyUnattendedSubjects => $composableBuilder(
    column: $table.notifyUnattendedSubjects,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unattendedDaysThreshold => $composableBuilder(
    column: $table.unattendedDaysThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroSettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroSettingsEntriesTable> {
  $$PomodoroSettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cyclesBeforeLongBreak => $composableBuilder(
    column: $table.cyclesBeforeLongBreak,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartBreaks => $composableBuilder(
    column: $table.autoStartBreaks,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get preventScreenLock => $composableBuilder(
    column: $table.preventScreenLock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyGoalHours => $composableBuilder(
    column: $table.dailyGoalHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completionSound => $composableBuilder(
    column: $table.completionSound,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get use24HourFormat => $composableBuilder(
    column: $table.use24HourFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekStartDay => $composableBuilder(
    column: $table.weekStartDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyUnattendedSubjects => $composableBuilder(
    column: $table.notifyUnattendedSubjects,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unattendedDaysThreshold => $composableBuilder(
    column: $table.unattendedDaysThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PomodoroSettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroSettingsEntriesTable,
          PomodoroSettingsEntry,
          $$PomodoroSettingsEntriesTableFilterComposer,
          $$PomodoroSettingsEntriesTableOrderingComposer,
          $$PomodoroSettingsEntriesTableAnnotationComposer,
          $$PomodoroSettingsEntriesTableCreateCompanionBuilder,
          $$PomodoroSettingsEntriesTableUpdateCompanionBuilder,
          (
            PomodoroSettingsEntry,
            BaseReferences<
              _$AppDatabase,
              $PomodoroSettingsEntriesTable,
              PomodoroSettingsEntry
            >,
          ),
          PomodoroSettingsEntry,
          PrefetchHooks Function()
        > {
  $$PomodoroSettingsEntriesTableTableManager(
    _$AppDatabase db,
    $PomodoroSettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroSettingsEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PomodoroSettingsEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PomodoroSettingsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> focusMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> cyclesBeforeLongBreak = const Value.absent(),
                Value<bool> autoStartBreaks = const Value.absent(),
                Value<bool> autoStartFocus = const Value.absent(),
                Value<bool> preventScreenLock = const Value.absent(),
                Value<int> dailyGoalHours = const Value.absent(),
                Value<String> completionSound = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<bool> use24HourFormat = const Value.absent(),
                Value<String> weekStartDay = const Value.absent(),
                Value<bool> notifyUnattendedSubjects = const Value.absent(),
                Value<int> unattendedDaysThreshold = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PomodoroSettingsEntriesCompanion(
                id: id,
                focusMinutes: focusMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                cyclesBeforeLongBreak: cyclesBeforeLongBreak,
                autoStartBreaks: autoStartBreaks,
                autoStartFocus: autoStartFocus,
                preventScreenLock: preventScreenLock,
                dailyGoalHours: dailyGoalHours,
                completionSound: completionSound,
                themePreference: themePreference,
                use24HourFormat: use24HourFormat,
                weekStartDay: weekStartDay,
                notifyUnattendedSubjects: notifyUnattendedSubjects,
                unattendedDaysThreshold: unattendedDaysThreshold,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> focusMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> cyclesBeforeLongBreak = const Value.absent(),
                Value<bool> autoStartBreaks = const Value.absent(),
                Value<bool> autoStartFocus = const Value.absent(),
                Value<bool> preventScreenLock = const Value.absent(),
                Value<int> dailyGoalHours = const Value.absent(),
                Value<String> completionSound = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<bool> use24HourFormat = const Value.absent(),
                Value<String> weekStartDay = const Value.absent(),
                Value<bool> notifyUnattendedSubjects = const Value.absent(),
                Value<int> unattendedDaysThreshold = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PomodoroSettingsEntriesCompanion.insert(
                id: id,
                focusMinutes: focusMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                cyclesBeforeLongBreak: cyclesBeforeLongBreak,
                autoStartBreaks: autoStartBreaks,
                autoStartFocus: autoStartFocus,
                preventScreenLock: preventScreenLock,
                dailyGoalHours: dailyGoalHours,
                completionSound: completionSound,
                themePreference: themePreference,
                use24HourFormat: use24HourFormat,
                weekStartDay: weekStartDay,
                notifyUnattendedSubjects: notifyUnattendedSubjects,
                unattendedDaysThreshold: unattendedDaysThreshold,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroSettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroSettingsEntriesTable,
      PomodoroSettingsEntry,
      $$PomodoroSettingsEntriesTableFilterComposer,
      $$PomodoroSettingsEntriesTableOrderingComposer,
      $$PomodoroSettingsEntriesTableAnnotationComposer,
      $$PomodoroSettingsEntriesTableCreateCompanionBuilder,
      $$PomodoroSettingsEntriesTableUpdateCompanionBuilder,
      (
        PomodoroSettingsEntry,
        BaseReferences<
          _$AppDatabase,
          $PomodoroSettingsEntriesTable,
          PomodoroSettingsEntry
        >,
      ),
      PomodoroSettingsEntry,
      PrefetchHooks Function()
    >;
typedef $$PomodoroStateEntriesTableCreateCompanionBuilder =
    PomodoroStateEntriesCompanion Function({
      Value<int> id,
      Value<String> phase,
      Value<String> status,
      Value<String?> activeSubjectId,
      Value<String?> activeEventId,
      Value<int> remainingSeconds,
      Value<int> totalSeconds,
      Value<int> currentCycle,
      Value<int> cyclesBeforeLongBreak,
      Value<DateTime?> lastResumedAt,
      Value<DateTime> updatedAt,
    });
typedef $$PomodoroStateEntriesTableUpdateCompanionBuilder =
    PomodoroStateEntriesCompanion Function({
      Value<int> id,
      Value<String> phase,
      Value<String> status,
      Value<String?> activeSubjectId,
      Value<String?> activeEventId,
      Value<int> remainingSeconds,
      Value<int> totalSeconds,
      Value<int> currentCycle,
      Value<int> cyclesBeforeLongBreak,
      Value<DateTime?> lastResumedAt,
      Value<DateTime> updatedAt,
    });

class $$PomodoroStateEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroStateEntriesTable> {
  $$PomodoroStateEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeSubjectId => $composableBuilder(
    column: $table.activeSubjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeEventId => $composableBuilder(
    column: $table.activeEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSeconds => $composableBuilder(
    column: $table.totalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCycle => $composableBuilder(
    column: $table.currentCycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cyclesBeforeLongBreak => $composableBuilder(
    column: $table.cyclesBeforeLongBreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastResumedAt => $composableBuilder(
    column: $table.lastResumedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroStateEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroStateEntriesTable> {
  $$PomodoroStateEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeSubjectId => $composableBuilder(
    column: $table.activeSubjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeEventId => $composableBuilder(
    column: $table.activeEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSeconds => $composableBuilder(
    column: $table.totalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCycle => $composableBuilder(
    column: $table.currentCycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cyclesBeforeLongBreak => $composableBuilder(
    column: $table.cyclesBeforeLongBreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastResumedAt => $composableBuilder(
    column: $table.lastResumedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroStateEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroStateEntriesTable> {
  $$PomodoroStateEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get activeSubjectId => $composableBuilder(
    column: $table.activeSubjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeEventId => $composableBuilder(
    column: $table.activeEventId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSeconds => $composableBuilder(
    column: $table.totalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCycle => $composableBuilder(
    column: $table.currentCycle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cyclesBeforeLongBreak => $composableBuilder(
    column: $table.cyclesBeforeLongBreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastResumedAt => $composableBuilder(
    column: $table.lastResumedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PomodoroStateEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroStateEntriesTable,
          PomodoroStateEntry,
          $$PomodoroStateEntriesTableFilterComposer,
          $$PomodoroStateEntriesTableOrderingComposer,
          $$PomodoroStateEntriesTableAnnotationComposer,
          $$PomodoroStateEntriesTableCreateCompanionBuilder,
          $$PomodoroStateEntriesTableUpdateCompanionBuilder,
          (
            PomodoroStateEntry,
            BaseReferences<
              _$AppDatabase,
              $PomodoroStateEntriesTable,
              PomodoroStateEntry
            >,
          ),
          PomodoroStateEntry,
          PrefetchHooks Function()
        > {
  $$PomodoroStateEntriesTableTableManager(
    _$AppDatabase db,
    $PomodoroStateEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroStateEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PomodoroStateEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PomodoroStateEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> activeSubjectId = const Value.absent(),
                Value<String?> activeEventId = const Value.absent(),
                Value<int> remainingSeconds = const Value.absent(),
                Value<int> totalSeconds = const Value.absent(),
                Value<int> currentCycle = const Value.absent(),
                Value<int> cyclesBeforeLongBreak = const Value.absent(),
                Value<DateTime?> lastResumedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PomodoroStateEntriesCompanion(
                id: id,
                phase: phase,
                status: status,
                activeSubjectId: activeSubjectId,
                activeEventId: activeEventId,
                remainingSeconds: remainingSeconds,
                totalSeconds: totalSeconds,
                currentCycle: currentCycle,
                cyclesBeforeLongBreak: cyclesBeforeLongBreak,
                lastResumedAt: lastResumedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> activeSubjectId = const Value.absent(),
                Value<String?> activeEventId = const Value.absent(),
                Value<int> remainingSeconds = const Value.absent(),
                Value<int> totalSeconds = const Value.absent(),
                Value<int> currentCycle = const Value.absent(),
                Value<int> cyclesBeforeLongBreak = const Value.absent(),
                Value<DateTime?> lastResumedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PomodoroStateEntriesCompanion.insert(
                id: id,
                phase: phase,
                status: status,
                activeSubjectId: activeSubjectId,
                activeEventId: activeEventId,
                remainingSeconds: remainingSeconds,
                totalSeconds: totalSeconds,
                currentCycle: currentCycle,
                cyclesBeforeLongBreak: cyclesBeforeLongBreak,
                lastResumedAt: lastResumedAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroStateEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroStateEntriesTable,
      PomodoroStateEntry,
      $$PomodoroStateEntriesTableFilterComposer,
      $$PomodoroStateEntriesTableOrderingComposer,
      $$PomodoroStateEntriesTableAnnotationComposer,
      $$PomodoroStateEntriesTableCreateCompanionBuilder,
      $$PomodoroStateEntriesTableUpdateCompanionBuilder,
      (
        PomodoroStateEntry,
        BaseReferences<
          _$AppDatabase,
          $PomodoroStateEntriesTable,
          PomodoroStateEntry
        >,
      ),
      PomodoroStateEntry,
      PrefetchHooks Function()
    >;
typedef $$StudentProfileEntriesTableCreateCompanionBuilder =
    StudentProfileEntriesCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String> degreeName,
      Value<String> academicPeriod,
      Value<String> semester,
      Value<String?> avatarPath,
      Value<DateTime> updatedAt,
    });
typedef $$StudentProfileEntriesTableUpdateCompanionBuilder =
    StudentProfileEntriesCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String> degreeName,
      Value<String> academicPeriod,
      Value<String> semester,
      Value<String?> avatarPath,
      Value<DateTime> updatedAt,
    });

class $$StudentProfileEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $StudentProfileEntriesTable> {
  $$StudentProfileEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get degreeName => $composableBuilder(
    column: $table.degreeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicPeriod => $composableBuilder(
    column: $table.academicPeriod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentProfileEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentProfileEntriesTable> {
  $$StudentProfileEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get degreeName => $composableBuilder(
    column: $table.degreeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicPeriod => $composableBuilder(
    column: $table.academicPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentProfileEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentProfileEntriesTable> {
  $$StudentProfileEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get degreeName => $composableBuilder(
    column: $table.degreeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get academicPeriod => $composableBuilder(
    column: $table.academicPeriod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get semester =>
      $composableBuilder(column: $table.semester, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StudentProfileEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentProfileEntriesTable,
          StudentProfileEntry,
          $$StudentProfileEntriesTableFilterComposer,
          $$StudentProfileEntriesTableOrderingComposer,
          $$StudentProfileEntriesTableAnnotationComposer,
          $$StudentProfileEntriesTableCreateCompanionBuilder,
          $$StudentProfileEntriesTableUpdateCompanionBuilder,
          (
            StudentProfileEntry,
            BaseReferences<
              _$AppDatabase,
              $StudentProfileEntriesTable,
              StudentProfileEntry
            >,
          ),
          StudentProfileEntry,
          PrefetchHooks Function()
        > {
  $$StudentProfileEntriesTableTableManager(
    _$AppDatabase db,
    $StudentProfileEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentProfileEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StudentProfileEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StudentProfileEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> degreeName = const Value.absent(),
                Value<String> academicPeriod = const Value.absent(),
                Value<String> semester = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => StudentProfileEntriesCompanion(
                id: id,
                displayName: displayName,
                degreeName: degreeName,
                academicPeriod: academicPeriod,
                semester: semester,
                avatarPath: avatarPath,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> degreeName = const Value.absent(),
                Value<String> academicPeriod = const Value.absent(),
                Value<String> semester = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => StudentProfileEntriesCompanion.insert(
                id: id,
                displayName: displayName,
                degreeName: degreeName,
                academicPeriod: academicPeriod,
                semester: semester,
                avatarPath: avatarPath,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentProfileEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentProfileEntriesTable,
      StudentProfileEntry,
      $$StudentProfileEntriesTableFilterComposer,
      $$StudentProfileEntriesTableOrderingComposer,
      $$StudentProfileEntriesTableAnnotationComposer,
      $$StudentProfileEntriesTableCreateCompanionBuilder,
      $$StudentProfileEntriesTableUpdateCompanionBuilder,
      (
        StudentProfileEntry,
        BaseReferences<
          _$AppDatabase,
          $StudentProfileEntriesTable,
          StudentProfileEntry
        >,
      ),
      StudentProfileEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$AcademicEventsTableTableManager get academicEvents =>
      $$AcademicEventsTableTableManager(_db, _db.academicEvents);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$PomodoroSettingsEntriesTableTableManager get pomodoroSettingsEntries =>
      $$PomodoroSettingsEntriesTableTableManager(
        _db,
        _db.pomodoroSettingsEntries,
      );
  $$PomodoroStateEntriesTableTableManager get pomodoroStateEntries =>
      $$PomodoroStateEntriesTableTableManager(_db, _db.pomodoroStateEntries);
  $$StudentProfileEntriesTableTableManager get studentProfileEntries =>
      $$StudentProfileEntriesTableTableManager(_db, _db.studentProfileEntries);
}
