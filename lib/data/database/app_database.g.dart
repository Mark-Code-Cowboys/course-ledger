// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoursesTable extends Courses with TableInfo<$CoursesTable, Course> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('US'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CourseHoles, String> holes =
      GeneratedColumn<String>(
        'holes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CourseHoles>($CoursesTable.$converterholes);
  static const VerificationMeta _parMeta = const VerificationMeta('par');
  @override
  late final GeneratedColumn<int> par = GeneratedColumn<int>(
    'par',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CourseKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CourseKind>($CoursesTable.$converterkind);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(1, 5),
    type: DriftSqlType.int,
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
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
    name,
    city,
    state,
    country,
    holes,
    par,
    kind,
    rating,
    notes,
    lat,
    lng,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Course> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('par')) {
      context.handle(
        _parMeta,
        par.isAcceptableOrUnknown(data['par']!, _parMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
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
  Course map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Course(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      holes: $CoursesTable.$converterholes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}holes'],
        )!,
      ),
      par: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}par'],
      ),
      kind: $CoursesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CoursesTable createAlias(String alias) {
    return $CoursesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CourseHoles, String, String> $converterholes =
      const EnumNameConverter<CourseHoles>(CourseHoles.values);
  static JsonTypeConverter2<CourseKind, String, String> $converterkind =
      const EnumNameConverter<CourseKind>(CourseKind.values);
}

class Course extends DataClass implements Insertable<Course> {
  final int id;
  final String name;
  final String? city;
  final String? state;
  final String country;
  final CourseHoles holes;
  final int? par;
  final CourseKind kind;
  final int? rating;
  final String? notes;
  final double? lat;
  final double? lng;
  final DateTime createdAt;
  const Course({
    required this.id,
    required this.name,
    this.city,
    this.state,
    required this.country,
    required this.holes,
    this.par,
    required this.kind,
    this.rating,
    this.notes,
    this.lat,
    this.lng,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    map['country'] = Variable<String>(country);
    {
      map['holes'] = Variable<String>(
        $CoursesTable.$converterholes.toSql(holes),
      );
    }
    if (!nullToAbsent || par != null) {
      map['par'] = Variable<int>(par);
    }
    {
      map['kind'] = Variable<String>($CoursesTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CoursesCompanion toCompanion(bool nullToAbsent) {
    return CoursesCompanion(
      id: Value(id),
      name: Value(name),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      country: Value(country),
      holes: Value(holes),
      par: par == null && nullToAbsent ? const Value.absent() : Value(par),
      kind: Value(kind),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      createdAt: Value(createdAt),
    );
  }

  factory Course.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Course(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      country: serializer.fromJson<String>(json['country']),
      holes: $CoursesTable.$converterholes.fromJson(
        serializer.fromJson<String>(json['holes']),
      ),
      par: serializer.fromJson<int?>(json['par']),
      kind: $CoursesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      rating: serializer.fromJson<int?>(json['rating']),
      notes: serializer.fromJson<String?>(json['notes']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'country': serializer.toJson<String>(country),
      'holes': serializer.toJson<String>(
        $CoursesTable.$converterholes.toJson(holes),
      ),
      'par': serializer.toJson<int?>(par),
      'kind': serializer.toJson<String>(
        $CoursesTable.$converterkind.toJson(kind),
      ),
      'rating': serializer.toJson<int?>(rating),
      'notes': serializer.toJson<String?>(notes),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Course copyWith({
    int? id,
    String? name,
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    String? country,
    CourseHoles? holes,
    Value<int?> par = const Value.absent(),
    CourseKind? kind,
    Value<int?> rating = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    DateTime? createdAt,
  }) => Course(
    id: id ?? this.id,
    name: name ?? this.name,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    country: country ?? this.country,
    holes: holes ?? this.holes,
    par: par.present ? par.value : this.par,
    kind: kind ?? this.kind,
    rating: rating.present ? rating.value : this.rating,
    notes: notes.present ? notes.value : this.notes,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    createdAt: createdAt ?? this.createdAt,
  );
  Course copyWithCompanion(CoursesCompanion data) {
    return Course(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      country: data.country.present ? data.country.value : this.country,
      holes: data.holes.present ? data.holes.value : this.holes,
      par: data.par.present ? data.par.value : this.par,
      kind: data.kind.present ? data.kind.value : this.kind,
      rating: data.rating.present ? data.rating.value : this.rating,
      notes: data.notes.present ? data.notes.value : this.notes,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Course(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('country: $country, ')
          ..write('holes: $holes, ')
          ..write('par: $par, ')
          ..write('kind: $kind, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    city,
    state,
    country,
    holes,
    par,
    kind,
    rating,
    notes,
    lat,
    lng,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Course &&
          other.id == this.id &&
          other.name == this.name &&
          other.city == this.city &&
          other.state == this.state &&
          other.country == this.country &&
          other.holes == this.holes &&
          other.par == this.par &&
          other.kind == this.kind &&
          other.rating == this.rating &&
          other.notes == this.notes &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.createdAt == this.createdAt);
}

class CoursesCompanion extends UpdateCompanion<Course> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String> country;
  final Value<CourseHoles> holes;
  final Value<int?> par;
  final Value<CourseKind> kind;
  final Value<int?> rating;
  final Value<String?> notes;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<DateTime> createdAt;
  const CoursesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.country = const Value.absent(),
    this.holes = const Value.absent(),
    this.par = const Value.absent(),
    this.kind = const Value.absent(),
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CoursesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.country = const Value.absent(),
    required CourseHoles holes,
    this.par = const Value.absent(),
    required CourseKind kind,
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       holes = Value(holes),
       kind = Value(kind);
  static Insertable<Course> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? country,
    Expression<String>? holes,
    Expression<int>? par,
    Expression<String>? kind,
    Expression<int>? rating,
    Expression<String>? notes,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (holes != null) 'holes': holes,
      if (par != null) 'par': par,
      if (kind != null) 'kind': kind,
      if (rating != null) 'rating': rating,
      if (notes != null) 'notes': notes,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CoursesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? city,
    Value<String?>? state,
    Value<String>? country,
    Value<CourseHoles>? holes,
    Value<int?>? par,
    Value<CourseKind>? kind,
    Value<int?>? rating,
    Value<String?>? notes,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<DateTime>? createdAt,
  }) {
    return CoursesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      holes: holes ?? this.holes,
      par: par ?? this.par,
      kind: kind ?? this.kind,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (holes.present) {
      map['holes'] = Variable<String>(
        $CoursesTable.$converterholes.toSql(holes.value),
      );
    }
    if (par.present) {
      map['par'] = Variable<int>(par.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CoursesTable.$converterkind.toSql(kind.value),
      );
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('country: $country, ')
          ..write('holes: $holes, ')
          ..write('par: $par, ')
          ..write('kind: $kind, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoundsTable extends Rounds with TableInfo<$RoundsTable, Round> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courses (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HolesPlayed, String> holesPlayed =
      GeneratedColumn<String>(
        'holes_played',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HolesPlayed>($RoundsTable.$converterholesPlayed);
  static const VerificationMeta _teesMeta = const VerificationMeta('tees');
  @override
  late final GeneratedColumn<String> tees = GeneratedColumn<String>(
    'tees',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalkedOrCart?, String>
  walkedOrCart = GeneratedColumn<String>(
    'walked_or_cart',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<WalkedOrCart?>($RoundsTable.$converterwalkedOrCartn);
  static const VerificationMeta _partnersMeta = const VerificationMeta(
    'partners',
  );
  @override
  late final GeneratedColumn<String> partners = GeneratedColumn<String>(
    'partners',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _weatherMeta = const VerificationMeta(
    'weather',
  );
  @override
  late final GeneratedColumn<String> weather = GeneratedColumn<String>(
    'weather',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(1, 5),
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    date,
    totalScore,
    holesPlayed,
    tees,
    walkedOrCart,
    partners,
    weather,
    rating,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Round> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('tees')) {
      context.handle(
        _teesMeta,
        tees.isAcceptableOrUnknown(data['tees']!, _teesMeta),
      );
    }
    if (data.containsKey('partners')) {
      context.handle(
        _partnersMeta,
        partners.isAcceptableOrUnknown(data['partners']!, _partnersMeta),
      );
    }
    if (data.containsKey('weather')) {
      context.handle(
        _weatherMeta,
        weather.isAcceptableOrUnknown(data['weather']!, _weatherMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Round map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Round(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}course_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      ),
      holesPlayed: $RoundsTable.$converterholesPlayed.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}holes_played'],
        )!,
      ),
      tees: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tees'],
      ),
      walkedOrCart: $RoundsTable.$converterwalkedOrCartn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}walked_or_cart'],
        ),
      ),
      partners: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}partners'],
      )!,
      weather: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $RoundsTable createAlias(String alias) {
    return $RoundsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HolesPlayed, String, String> $converterholesPlayed =
      const EnumNameConverter<HolesPlayed>(HolesPlayed.values);
  static JsonTypeConverter2<WalkedOrCart, String, String>
  $converterwalkedOrCart = const EnumNameConverter<WalkedOrCart>(
    WalkedOrCart.values,
  );
  static JsonTypeConverter2<WalkedOrCart?, String?, String?>
  $converterwalkedOrCartn = JsonTypeConverter2.asNullable(
    $converterwalkedOrCart,
  );
}

class Round extends DataClass implements Insertable<Round> {
  final int id;
  final int courseId;
  final DateTime date;
  final int? totalScore;
  final HolesPlayed holesPlayed;
  final String? tees;
  final WalkedOrCart? walkedOrCart;
  final String partners;
  final String? weather;
  final int? rating;
  final String? notes;
  const Round({
    required this.id,
    required this.courseId,
    required this.date,
    this.totalScore,
    required this.holesPlayed,
    this.tees,
    this.walkedOrCart,
    required this.partners,
    this.weather,
    this.rating,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['course_id'] = Variable<int>(courseId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || totalScore != null) {
      map['total_score'] = Variable<int>(totalScore);
    }
    {
      map['holes_played'] = Variable<String>(
        $RoundsTable.$converterholesPlayed.toSql(holesPlayed),
      );
    }
    if (!nullToAbsent || tees != null) {
      map['tees'] = Variable<String>(tees);
    }
    if (!nullToAbsent || walkedOrCart != null) {
      map['walked_or_cart'] = Variable<String>(
        $RoundsTable.$converterwalkedOrCartn.toSql(walkedOrCart),
      );
    }
    map['partners'] = Variable<String>(partners);
    if (!nullToAbsent || weather != null) {
      map['weather'] = Variable<String>(weather);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  RoundsCompanion toCompanion(bool nullToAbsent) {
    return RoundsCompanion(
      id: Value(id),
      courseId: Value(courseId),
      date: Value(date),
      totalScore: totalScore == null && nullToAbsent
          ? const Value.absent()
          : Value(totalScore),
      holesPlayed: Value(holesPlayed),
      tees: tees == null && nullToAbsent ? const Value.absent() : Value(tees),
      walkedOrCart: walkedOrCart == null && nullToAbsent
          ? const Value.absent()
          : Value(walkedOrCart),
      partners: Value(partners),
      weather: weather == null && nullToAbsent
          ? const Value.absent()
          : Value(weather),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Round.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Round(
      id: serializer.fromJson<int>(json['id']),
      courseId: serializer.fromJson<int>(json['courseId']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalScore: serializer.fromJson<int?>(json['totalScore']),
      holesPlayed: $RoundsTable.$converterholesPlayed.fromJson(
        serializer.fromJson<String>(json['holesPlayed']),
      ),
      tees: serializer.fromJson<String?>(json['tees']),
      walkedOrCart: $RoundsTable.$converterwalkedOrCartn.fromJson(
        serializer.fromJson<String?>(json['walkedOrCart']),
      ),
      partners: serializer.fromJson<String>(json['partners']),
      weather: serializer.fromJson<String?>(json['weather']),
      rating: serializer.fromJson<int?>(json['rating']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'courseId': serializer.toJson<int>(courseId),
      'date': serializer.toJson<DateTime>(date),
      'totalScore': serializer.toJson<int?>(totalScore),
      'holesPlayed': serializer.toJson<String>(
        $RoundsTable.$converterholesPlayed.toJson(holesPlayed),
      ),
      'tees': serializer.toJson<String?>(tees),
      'walkedOrCart': serializer.toJson<String?>(
        $RoundsTable.$converterwalkedOrCartn.toJson(walkedOrCart),
      ),
      'partners': serializer.toJson<String>(partners),
      'weather': serializer.toJson<String?>(weather),
      'rating': serializer.toJson<int?>(rating),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Round copyWith({
    int? id,
    int? courseId,
    DateTime? date,
    Value<int?> totalScore = const Value.absent(),
    HolesPlayed? holesPlayed,
    Value<String?> tees = const Value.absent(),
    Value<WalkedOrCart?> walkedOrCart = const Value.absent(),
    String? partners,
    Value<String?> weather = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Round(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    date: date ?? this.date,
    totalScore: totalScore.present ? totalScore.value : this.totalScore,
    holesPlayed: holesPlayed ?? this.holesPlayed,
    tees: tees.present ? tees.value : this.tees,
    walkedOrCart: walkedOrCart.present ? walkedOrCart.value : this.walkedOrCart,
    partners: partners ?? this.partners,
    weather: weather.present ? weather.value : this.weather,
    rating: rating.present ? rating.value : this.rating,
    notes: notes.present ? notes.value : this.notes,
  );
  Round copyWithCompanion(RoundsCompanion data) {
    return Round(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      date: data.date.present ? data.date.value : this.date,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      holesPlayed: data.holesPlayed.present
          ? data.holesPlayed.value
          : this.holesPlayed,
      tees: data.tees.present ? data.tees.value : this.tees,
      walkedOrCart: data.walkedOrCart.present
          ? data.walkedOrCart.value
          : this.walkedOrCart,
      partners: data.partners.present ? data.partners.value : this.partners,
      weather: data.weather.present ? data.weather.value : this.weather,
      rating: data.rating.present ? data.rating.value : this.rating,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Round(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('date: $date, ')
          ..write('totalScore: $totalScore, ')
          ..write('holesPlayed: $holesPlayed, ')
          ..write('tees: $tees, ')
          ..write('walkedOrCart: $walkedOrCart, ')
          ..write('partners: $partners, ')
          ..write('weather: $weather, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    date,
    totalScore,
    holesPlayed,
    tees,
    walkedOrCart,
    partners,
    weather,
    rating,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Round &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.date == this.date &&
          other.totalScore == this.totalScore &&
          other.holesPlayed == this.holesPlayed &&
          other.tees == this.tees &&
          other.walkedOrCart == this.walkedOrCart &&
          other.partners == this.partners &&
          other.weather == this.weather &&
          other.rating == this.rating &&
          other.notes == this.notes);
}

class RoundsCompanion extends UpdateCompanion<Round> {
  final Value<int> id;
  final Value<int> courseId;
  final Value<DateTime> date;
  final Value<int?> totalScore;
  final Value<HolesPlayed> holesPlayed;
  final Value<String?> tees;
  final Value<WalkedOrCart?> walkedOrCart;
  final Value<String> partners;
  final Value<String?> weather;
  final Value<int?> rating;
  final Value<String?> notes;
  const RoundsCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.date = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.holesPlayed = const Value.absent(),
    this.tees = const Value.absent(),
    this.walkedOrCart = const Value.absent(),
    this.partners = const Value.absent(),
    this.weather = const Value.absent(),
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
  });
  RoundsCompanion.insert({
    this.id = const Value.absent(),
    required int courseId,
    required DateTime date,
    this.totalScore = const Value.absent(),
    required HolesPlayed holesPlayed,
    this.tees = const Value.absent(),
    this.walkedOrCart = const Value.absent(),
    this.partners = const Value.absent(),
    this.weather = const Value.absent(),
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
  }) : courseId = Value(courseId),
       date = Value(date),
       holesPlayed = Value(holesPlayed);
  static Insertable<Round> custom({
    Expression<int>? id,
    Expression<int>? courseId,
    Expression<DateTime>? date,
    Expression<int>? totalScore,
    Expression<String>? holesPlayed,
    Expression<String>? tees,
    Expression<String>? walkedOrCart,
    Expression<String>? partners,
    Expression<String>? weather,
    Expression<int>? rating,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (date != null) 'date': date,
      if (totalScore != null) 'total_score': totalScore,
      if (holesPlayed != null) 'holes_played': holesPlayed,
      if (tees != null) 'tees': tees,
      if (walkedOrCart != null) 'walked_or_cart': walkedOrCart,
      if (partners != null) 'partners': partners,
      if (weather != null) 'weather': weather,
      if (rating != null) 'rating': rating,
      if (notes != null) 'notes': notes,
    });
  }

  RoundsCompanion copyWith({
    Value<int>? id,
    Value<int>? courseId,
    Value<DateTime>? date,
    Value<int?>? totalScore,
    Value<HolesPlayed>? holesPlayed,
    Value<String?>? tees,
    Value<WalkedOrCart?>? walkedOrCart,
    Value<String>? partners,
    Value<String?>? weather,
    Value<int?>? rating,
    Value<String?>? notes,
  }) {
    return RoundsCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      date: date ?? this.date,
      totalScore: totalScore ?? this.totalScore,
      holesPlayed: holesPlayed ?? this.holesPlayed,
      tees: tees ?? this.tees,
      walkedOrCart: walkedOrCart ?? this.walkedOrCart,
      partners: partners ?? this.partners,
      weather: weather ?? this.weather,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (holesPlayed.present) {
      map['holes_played'] = Variable<String>(
        $RoundsTable.$converterholesPlayed.toSql(holesPlayed.value),
      );
    }
    if (tees.present) {
      map['tees'] = Variable<String>(tees.value);
    }
    if (walkedOrCart.present) {
      map['walked_or_cart'] = Variable<String>(
        $RoundsTable.$converterwalkedOrCartn.toSql(walkedOrCart.value),
      );
    }
    if (partners.present) {
      map['partners'] = Variable<String>(partners.value);
    }
    if (weather.present) {
      map['weather'] = Variable<String>(weather.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundsCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('date: $date, ')
          ..write('totalScore: $totalScore, ')
          ..write('holesPlayed: $holesPlayed, ')
          ..write('tees: $tees, ')
          ..write('walkedOrCart: $walkedOrCart, ')
          ..write('partners: $partners, ')
          ..write('weather: $weather, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $RoundPhotosTable extends RoundPhotos
    with TableInfo<$RoundPhotosTable, RoundPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roundIdMeta = const VerificationMeta(
    'roundId',
  );
  @override
  late final GeneratedColumn<int> roundId = GeneratedColumn<int>(
    'round_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rounds (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, roundId, path, caption];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'round_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoundPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('round_id')) {
      context.handle(
        _roundIdMeta,
        roundId.isAcceptableOrUnknown(data['round_id']!, _roundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roundIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoundPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoundPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
    );
  }

  @override
  $RoundPhotosTable createAlias(String alias) {
    return $RoundPhotosTable(attachedDatabase, alias);
  }
}

class RoundPhoto extends DataClass implements Insertable<RoundPhoto> {
  final int id;
  final int roundId;
  final String path;
  final String? caption;
  const RoundPhoto({
    required this.id,
    required this.roundId,
    required this.path,
    this.caption,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['round_id'] = Variable<int>(roundId);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    return map;
  }

  RoundPhotosCompanion toCompanion(bool nullToAbsent) {
    return RoundPhotosCompanion(
      id: Value(id),
      roundId: Value(roundId),
      path: Value(path),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
    );
  }

  factory RoundPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoundPhoto(
      id: serializer.fromJson<int>(json['id']),
      roundId: serializer.fromJson<int>(json['roundId']),
      path: serializer.fromJson<String>(json['path']),
      caption: serializer.fromJson<String?>(json['caption']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roundId': serializer.toJson<int>(roundId),
      'path': serializer.toJson<String>(path),
      'caption': serializer.toJson<String?>(caption),
    };
  }

  RoundPhoto copyWith({
    int? id,
    int? roundId,
    String? path,
    Value<String?> caption = const Value.absent(),
  }) => RoundPhoto(
    id: id ?? this.id,
    roundId: roundId ?? this.roundId,
    path: path ?? this.path,
    caption: caption.present ? caption.value : this.caption,
  );
  RoundPhoto copyWithCompanion(RoundPhotosCompanion data) {
    return RoundPhoto(
      id: data.id.present ? data.id.value : this.id,
      roundId: data.roundId.present ? data.roundId.value : this.roundId,
      path: data.path.present ? data.path.value : this.path,
      caption: data.caption.present ? data.caption.value : this.caption,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoundPhoto(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('path: $path, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, roundId, path, caption);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoundPhoto &&
          other.id == this.id &&
          other.roundId == this.roundId &&
          other.path == this.path &&
          other.caption == this.caption);
}

class RoundPhotosCompanion extends UpdateCompanion<RoundPhoto> {
  final Value<int> id;
  final Value<int> roundId;
  final Value<String> path;
  final Value<String?> caption;
  const RoundPhotosCompanion({
    this.id = const Value.absent(),
    this.roundId = const Value.absent(),
    this.path = const Value.absent(),
    this.caption = const Value.absent(),
  });
  RoundPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int roundId,
    required String path,
    this.caption = const Value.absent(),
  }) : roundId = Value(roundId),
       path = Value(path);
  static Insertable<RoundPhoto> custom({
    Expression<int>? id,
    Expression<int>? roundId,
    Expression<String>? path,
    Expression<String>? caption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roundId != null) 'round_id': roundId,
      if (path != null) 'path': path,
      if (caption != null) 'caption': caption,
    });
  }

  RoundPhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? roundId,
    Value<String>? path,
    Value<String?>? caption,
  }) {
    return RoundPhotosCompanion(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      path: path ?? this.path,
      caption: caption ?? this.caption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roundId.present) {
      map['round_id'] = Variable<int>(roundId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundPhotosCompanion(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('path: $path, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }
}

class $BucketListTable extends BucketList
    with TableInfo<$BucketListTable, BucketItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BucketListTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
    'course_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courses (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _freeTextMeta = const VerificationMeta(
    'freeText',
  );
  @override
  late final GeneratedColumn<String> freeText = GeneratedColumn<String>(
    'free_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneRoundIdMeta = const VerificationMeta(
    'doneRoundId',
  );
  @override
  late final GeneratedColumn<int> doneRoundId = GeneratedColumn<int>(
    'done_round_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rounds (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    freeText,
    done,
    doneRoundId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bucket_list';
  @override
  VerificationContext validateIntegrity(
    Insertable<BucketItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    }
    if (data.containsKey('free_text')) {
      context.handle(
        _freeTextMeta,
        freeText.isAcceptableOrUnknown(data['free_text']!, _freeTextMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('done_round_id')) {
      context.handle(
        _doneRoundIdMeta,
        doneRoundId.isAcceptableOrUnknown(
          data['done_round_id']!,
          _doneRoundIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BucketItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BucketItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}course_id'],
      ),
      freeText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}free_text'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      doneRoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_round_id'],
      ),
    );
  }

  @override
  $BucketListTable createAlias(String alias) {
    return $BucketListTable(attachedDatabase, alias);
  }
}

class BucketItem extends DataClass implements Insertable<BucketItem> {
  final int id;
  final int? courseId;
  final String? freeText;
  final bool done;
  final int? doneRoundId;
  const BucketItem({
    required this.id,
    this.courseId,
    this.freeText,
    required this.done,
    this.doneRoundId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || courseId != null) {
      map['course_id'] = Variable<int>(courseId);
    }
    if (!nullToAbsent || freeText != null) {
      map['free_text'] = Variable<String>(freeText);
    }
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || doneRoundId != null) {
      map['done_round_id'] = Variable<int>(doneRoundId);
    }
    return map;
  }

  BucketListCompanion toCompanion(bool nullToAbsent) {
    return BucketListCompanion(
      id: Value(id),
      courseId: courseId == null && nullToAbsent
          ? const Value.absent()
          : Value(courseId),
      freeText: freeText == null && nullToAbsent
          ? const Value.absent()
          : Value(freeText),
      done: Value(done),
      doneRoundId: doneRoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(doneRoundId),
    );
  }

  factory BucketItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BucketItem(
      id: serializer.fromJson<int>(json['id']),
      courseId: serializer.fromJson<int?>(json['courseId']),
      freeText: serializer.fromJson<String?>(json['freeText']),
      done: serializer.fromJson<bool>(json['done']),
      doneRoundId: serializer.fromJson<int?>(json['doneRoundId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'courseId': serializer.toJson<int?>(courseId),
      'freeText': serializer.toJson<String?>(freeText),
      'done': serializer.toJson<bool>(done),
      'doneRoundId': serializer.toJson<int?>(doneRoundId),
    };
  }

  BucketItem copyWith({
    int? id,
    Value<int?> courseId = const Value.absent(),
    Value<String?> freeText = const Value.absent(),
    bool? done,
    Value<int?> doneRoundId = const Value.absent(),
  }) => BucketItem(
    id: id ?? this.id,
    courseId: courseId.present ? courseId.value : this.courseId,
    freeText: freeText.present ? freeText.value : this.freeText,
    done: done ?? this.done,
    doneRoundId: doneRoundId.present ? doneRoundId.value : this.doneRoundId,
  );
  BucketItem copyWithCompanion(BucketListCompanion data) {
    return BucketItem(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      freeText: data.freeText.present ? data.freeText.value : this.freeText,
      done: data.done.present ? data.done.value : this.done,
      doneRoundId: data.doneRoundId.present
          ? data.doneRoundId.value
          : this.doneRoundId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BucketItem(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('freeText: $freeText, ')
          ..write('done: $done, ')
          ..write('doneRoundId: $doneRoundId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, freeText, done, doneRoundId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BucketItem &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.freeText == this.freeText &&
          other.done == this.done &&
          other.doneRoundId == this.doneRoundId);
}

class BucketListCompanion extends UpdateCompanion<BucketItem> {
  final Value<int> id;
  final Value<int?> courseId;
  final Value<String?> freeText;
  final Value<bool> done;
  final Value<int?> doneRoundId;
  const BucketListCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.freeText = const Value.absent(),
    this.done = const Value.absent(),
    this.doneRoundId = const Value.absent(),
  });
  BucketListCompanion.insert({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.freeText = const Value.absent(),
    this.done = const Value.absent(),
    this.doneRoundId = const Value.absent(),
  });
  static Insertable<BucketItem> custom({
    Expression<int>? id,
    Expression<int>? courseId,
    Expression<String>? freeText,
    Expression<bool>? done,
    Expression<int>? doneRoundId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (freeText != null) 'free_text': freeText,
      if (done != null) 'done': done,
      if (doneRoundId != null) 'done_round_id': doneRoundId,
    });
  }

  BucketListCompanion copyWith({
    Value<int>? id,
    Value<int?>? courseId,
    Value<String?>? freeText,
    Value<bool>? done,
    Value<int?>? doneRoundId,
  }) {
    return BucketListCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      freeText: freeText ?? this.freeText,
      done: done ?? this.done,
      doneRoundId: doneRoundId ?? this.doneRoundId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (freeText.present) {
      map['free_text'] = Variable<String>(freeText.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (doneRoundId.present) {
      map['done_round_id'] = Variable<int>(doneRoundId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BucketListCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('freeText: $freeText, ')
          ..write('done: $done, ')
          ..write('doneRoundId: $doneRoundId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoursesTable courses = $CoursesTable(this);
  late final $RoundsTable rounds = $RoundsTable(this);
  late final $RoundPhotosTable roundPhotos = $RoundPhotosTable(this);
  late final $BucketListTable bucketList = $BucketListTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    courses,
    rounds,
    roundPhotos,
    bucketList,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'courses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rounds', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rounds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('round_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'courses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bucket_list', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rounds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bucket_list', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$CoursesTableCreateCompanionBuilder =
    CoursesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> city,
      Value<String?> state,
      Value<String> country,
      required CourseHoles holes,
      Value<int?> par,
      required CourseKind kind,
      Value<int?> rating,
      Value<String?> notes,
      Value<double?> lat,
      Value<double?> lng,
      Value<DateTime> createdAt,
    });
typedef $$CoursesTableUpdateCompanionBuilder =
    CoursesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> city,
      Value<String?> state,
      Value<String> country,
      Value<CourseHoles> holes,
      Value<int?> par,
      Value<CourseKind> kind,
      Value<int?> rating,
      Value<String?> notes,
      Value<double?> lat,
      Value<double?> lng,
      Value<DateTime> createdAt,
    });

final class $$CoursesTableReferences
    extends BaseReferences<_$AppDatabase, $CoursesTable, Course> {
  $$CoursesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoundsTable, List<Round>> _roundsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rounds,
    aliasName: 'courses__id__rounds__course_id',
  );

  $$RoundsTableProcessedTableManager get roundsRefs {
    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.courseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roundsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BucketListTable, List<BucketItem>>
  _bucketListRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bucketList,
    aliasName: 'courses__id__bucket_list__course_id',
  );

  $$BucketListTableProcessedTableManager get bucketListRefs {
    final manager = $$BucketListTableTableManager(
      $_db,
      $_db.bucketList,
    ).filter((f) => f.courseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bucketListRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CoursesTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CourseHoles, CourseHoles, String> get holes =>
      $composableBuilder(
        column: $table.holes,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get par => $composableBuilder(
    column: $table.par,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CourseKind, CourseKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> roundsRefs(
    Expression<bool> Function($$RoundsTableFilterComposer f) f,
  ) {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bucketListRefs(
    Expression<bool> Function($$BucketListTableFilterComposer f) f,
  ) {
    final $$BucketListTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bucketList,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketListTableFilterComposer(
            $db: $db,
            $table: $db.bucketList,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holes => $composableBuilder(
    column: $table.holes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get par => $composableBuilder(
    column: $table.par,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CourseHoles, String> get holes =>
      $composableBuilder(column: $table.holes, builder: (column) => column);

  GeneratedColumn<int> get par =>
      $composableBuilder(column: $table.par, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CourseKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> roundsRefs<T extends Object>(
    Expression<T> Function($$RoundsTableAnnotationComposer a) f,
  ) {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bucketListRefs<T extends Object>(
    Expression<T> Function($$BucketListTableAnnotationComposer a) f,
  ) {
    final $$BucketListTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bucketList,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketListTableAnnotationComposer(
            $db: $db,
            $table: $db.bucketList,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoursesTable,
          Course,
          $$CoursesTableFilterComposer,
          $$CoursesTableOrderingComposer,
          $$CoursesTableAnnotationComposer,
          $$CoursesTableCreateCompanionBuilder,
          $$CoursesTableUpdateCompanionBuilder,
          (Course, $$CoursesTableReferences),
          Course,
          PrefetchHooks Function({bool roundsRefs, bool bucketListRefs})
        > {
  $$CoursesTableTableManager(_$AppDatabase db, $CoursesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<CourseHoles> holes = const Value.absent(),
                Value<int?> par = const Value.absent(),
                Value<CourseKind> kind = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CoursesCompanion(
                id: id,
                name: name,
                city: city,
                state: state,
                country: country,
                holes: holes,
                par: par,
                kind: kind,
                rating: rating,
                notes: notes,
                lat: lat,
                lng: lng,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String> country = const Value.absent(),
                required CourseHoles holes,
                Value<int?> par = const Value.absent(),
                required CourseKind kind,
                Value<int?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CoursesCompanion.insert(
                id: id,
                name: name,
                city: city,
                state: state,
                country: country,
                holes: holes,
                par: par,
                kind: kind,
                rating: rating,
                notes: notes,
                lat: lat,
                lng: lng,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoursesTable, Course>(table),
                  $$CoursesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({roundsRefs = false, bucketListRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (roundsRefs) db.rounds,
                    if (bucketListRefs) db.bucketList,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (roundsRefs)
                        await $_getPrefetchedData<Course, $CoursesTable, Round>(
                          currentTable: table,
                          referencedTable: $$CoursesTableReferences
                              ._roundsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).roundsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.courseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bucketListRefs)
                        await $_getPrefetchedData<
                          Course,
                          $CoursesTable,
                          BucketItem
                        >(
                          currentTable: table,
                          referencedTable: $$CoursesTableReferences
                              ._bucketListRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).bucketListRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.courseId == item.id,
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

typedef $$CoursesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoursesTable,
      Course,
      $$CoursesTableFilterComposer,
      $$CoursesTableOrderingComposer,
      $$CoursesTableAnnotationComposer,
      $$CoursesTableCreateCompanionBuilder,
      $$CoursesTableUpdateCompanionBuilder,
      (Course, $$CoursesTableReferences),
      Course,
      PrefetchHooks Function({bool roundsRefs, bool bucketListRefs})
    >;
typedef $$RoundsTableCreateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      required int courseId,
      required DateTime date,
      Value<int?> totalScore,
      required HolesPlayed holesPlayed,
      Value<String?> tees,
      Value<WalkedOrCart?> walkedOrCart,
      Value<String> partners,
      Value<String?> weather,
      Value<int?> rating,
      Value<String?> notes,
    });
typedef $$RoundsTableUpdateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      Value<int> courseId,
      Value<DateTime> date,
      Value<int?> totalScore,
      Value<HolesPlayed> holesPlayed,
      Value<String?> tees,
      Value<WalkedOrCart?> walkedOrCart,
      Value<String> partners,
      Value<String?> weather,
      Value<int?> rating,
      Value<String?> notes,
    });

final class $$RoundsTableReferences
    extends BaseReferences<_$AppDatabase, $RoundsTable, Round> {
  $$RoundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CoursesTable _courseIdTable(_$AppDatabase db) =>
      db.courses.createAlias('rounds__course_id__courses__id');

  $$CoursesTableProcessedTableManager get courseId {
    final $_column = $_itemColumn<int>('course_id')!;

    final manager = $$CoursesTableTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RoundPhotosTable, List<RoundPhoto>>
  _roundPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roundPhotos,
    aliasName: 'rounds__id__round_photos__round_id',
  );

  $$RoundPhotosTableProcessedTableManager get roundPhotosRefs {
    final manager = $$RoundPhotosTableTableManager(
      $_db,
      $_db.roundPhotos,
    ).filter((f) => f.roundId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roundPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BucketListTable, List<BucketItem>>
  _bucketListRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bucketList,
    aliasName: 'rounds__id__bucket_list__done_round_id',
  );

  $$BucketListTableProcessedTableManager get bucketListRefs {
    final manager = $$BucketListTableTableManager(
      $_db,
      $_db.bucketList,
    ).filter((f) => f.doneRoundId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bucketListRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoundsTableFilterComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HolesPlayed, HolesPlayed, String>
  get holesPlayed => $composableBuilder(
    column: $table.holesPlayed,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get tees => $composableBuilder(
    column: $table.tees,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WalkedOrCart?, WalkedOrCart, String>
  get walkedOrCart => $composableBuilder(
    column: $table.walkedOrCart,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get partners => $composableBuilder(
    column: $table.partners,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$CoursesTableFilterComposer get courseId {
    final $$CoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> roundPhotosRefs(
    Expression<bool> Function($$RoundPhotosTableFilterComposer f) f,
  ) {
    final $$RoundPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roundPhotos,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundPhotosTableFilterComposer(
            $db: $db,
            $table: $db.roundPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bucketListRefs(
    Expression<bool> Function($$BucketListTableFilterComposer f) f,
  ) {
    final $$BucketListTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bucketList,
      getReferencedColumn: (t) => t.doneRoundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketListTableFilterComposer(
            $db: $db,
            $table: $db.bucketList,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holesPlayed => $composableBuilder(
    column: $table.holesPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tees => $composableBuilder(
    column: $table.tees,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get walkedOrCart => $composableBuilder(
    column: $table.walkedOrCart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partners => $composableBuilder(
    column: $table.partners,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CoursesTableOrderingComposer get courseId {
    final $$CoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HolesPlayed, String> get holesPlayed =>
      $composableBuilder(
        column: $table.holesPlayed,
        builder: (column) => column,
      );

  GeneratedColumn<String> get tees =>
      $composableBuilder(column: $table.tees, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalkedOrCart?, String> get walkedOrCart =>
      $composableBuilder(
        column: $table.walkedOrCart,
        builder: (column) => column,
      );

  GeneratedColumn<String> get partners =>
      $composableBuilder(column: $table.partners, builder: (column) => column);

  GeneratedColumn<String> get weather =>
      $composableBuilder(column: $table.weather, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$CoursesTableAnnotationComposer get courseId {
    final $$CoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> roundPhotosRefs<T extends Object>(
    Expression<T> Function($$RoundPhotosTableAnnotationComposer a) f,
  ) {
    final $$RoundPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roundPhotos,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.roundPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bucketListRefs<T extends Object>(
    Expression<T> Function($$BucketListTableAnnotationComposer a) f,
  ) {
    final $$BucketListTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bucketList,
      getReferencedColumn: (t) => t.doneRoundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketListTableAnnotationComposer(
            $db: $db,
            $table: $db.bucketList,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundsTable,
          Round,
          $$RoundsTableFilterComposer,
          $$RoundsTableOrderingComposer,
          $$RoundsTableAnnotationComposer,
          $$RoundsTableCreateCompanionBuilder,
          $$RoundsTableUpdateCompanionBuilder,
          (Round, $$RoundsTableReferences),
          Round,
          PrefetchHooks Function({
            bool courseId,
            bool roundPhotosRefs,
            bool bucketListRefs,
          })
        > {
  $$RoundsTableTableManager(_$AppDatabase db, $RoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> courseId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> totalScore = const Value.absent(),
                Value<HolesPlayed> holesPlayed = const Value.absent(),
                Value<String?> tees = const Value.absent(),
                Value<WalkedOrCart?> walkedOrCart = const Value.absent(),
                Value<String> partners = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => RoundsCompanion(
                id: id,
                courseId: courseId,
                date: date,
                totalScore: totalScore,
                holesPlayed: holesPlayed,
                tees: tees,
                walkedOrCart: walkedOrCart,
                partners: partners,
                weather: weather,
                rating: rating,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int courseId,
                required DateTime date,
                Value<int?> totalScore = const Value.absent(),
                required HolesPlayed holesPlayed,
                Value<String?> tees = const Value.absent(),
                Value<WalkedOrCart?> walkedOrCart = const Value.absent(),
                Value<String> partners = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => RoundsCompanion.insert(
                id: id,
                courseId: courseId,
                date: date,
                totalScore: totalScore,
                holesPlayed: holesPlayed,
                tees: tees,
                walkedOrCart: walkedOrCart,
                partners: partners,
                weather: weather,
                rating: rating,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoundsTable, Round>(table),
                  $$RoundsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                courseId = false,
                roundPhotosRefs = false,
                bucketListRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (roundPhotosRefs) db.roundPhotos,
                    if (bucketListRefs) db.bucketList,
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
                        if (courseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.courseId,
                                    referencedTable: $$RoundsTableReferences
                                        ._courseIdTable(db),
                                    referencedColumn: $$RoundsTableReferences
                                        ._courseIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (roundPhotosRefs)
                        await $_getPrefetchedData<
                          Round,
                          $RoundsTable,
                          RoundPhoto
                        >(
                          currentTable: table,
                          referencedTable: $$RoundsTableReferences
                              ._roundPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoundsTableReferences(
                                db,
                                table,
                                p0,
                              ).roundPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roundId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bucketListRefs)
                        await $_getPrefetchedData<
                          Round,
                          $RoundsTable,
                          BucketItem
                        >(
                          currentTable: table,
                          referencedTable: $$RoundsTableReferences
                              ._bucketListRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoundsTableReferences(
                                db,
                                table,
                                p0,
                              ).bucketListRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.doneRoundId == item.id,
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

typedef $$RoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundsTable,
      Round,
      $$RoundsTableFilterComposer,
      $$RoundsTableOrderingComposer,
      $$RoundsTableAnnotationComposer,
      $$RoundsTableCreateCompanionBuilder,
      $$RoundsTableUpdateCompanionBuilder,
      (Round, $$RoundsTableReferences),
      Round,
      PrefetchHooks Function({
        bool courseId,
        bool roundPhotosRefs,
        bool bucketListRefs,
      })
    >;
typedef $$RoundPhotosTableCreateCompanionBuilder =
    RoundPhotosCompanion Function({
      Value<int> id,
      required int roundId,
      required String path,
      Value<String?> caption,
    });
typedef $$RoundPhotosTableUpdateCompanionBuilder =
    RoundPhotosCompanion Function({
      Value<int> id,
      Value<int> roundId,
      Value<String> path,
      Value<String?> caption,
    });

final class $$RoundPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $RoundPhotosTable, RoundPhoto> {
  $$RoundPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoundsTable _roundIdTable(_$AppDatabase db) =>
      db.rounds.createAlias('round_photos__round_id__rounds__id');

  $$RoundsTableProcessedTableManager get roundId {
    final $_column = $_itemColumn<int>('round_id')!;

    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoundPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $RoundPhotosTable> {
  $$RoundPhotosTableFilterComposer({
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

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  $$RoundsTableFilterComposer get roundId {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundPhotosTable> {
  $$RoundPhotosTableOrderingComposer({
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

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoundsTableOrderingComposer get roundId {
    final $$RoundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableOrderingComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundPhotosTable> {
  $$RoundPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  $$RoundsTableAnnotationComposer get roundId {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundPhotosTable,
          RoundPhoto,
          $$RoundPhotosTableFilterComposer,
          $$RoundPhotosTableOrderingComposer,
          $$RoundPhotosTableAnnotationComposer,
          $$RoundPhotosTableCreateCompanionBuilder,
          $$RoundPhotosTableUpdateCompanionBuilder,
          (RoundPhoto, $$RoundPhotosTableReferences),
          RoundPhoto,
          PrefetchHooks Function({bool roundId})
        > {
  $$RoundPhotosTableTableManager(_$AppDatabase db, $RoundPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roundId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> caption = const Value.absent(),
              }) => RoundPhotosCompanion(
                id: id,
                roundId: roundId,
                path: path,
                caption: caption,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roundId,
                required String path,
                Value<String?> caption = const Value.absent(),
              }) => RoundPhotosCompanion.insert(
                id: id,
                roundId: roundId,
                path: path,
                caption: caption,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoundPhotosTable, RoundPhoto>(table),
                  $$RoundPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roundId = false}) {
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
                    if (roundId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.roundId,
                                referencedTable: $$RoundPhotosTableReferences
                                    ._roundIdTable(db),
                                referencedColumn: $$RoundPhotosTableReferences
                                    ._roundIdTable(db)
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

typedef $$RoundPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundPhotosTable,
      RoundPhoto,
      $$RoundPhotosTableFilterComposer,
      $$RoundPhotosTableOrderingComposer,
      $$RoundPhotosTableAnnotationComposer,
      $$RoundPhotosTableCreateCompanionBuilder,
      $$RoundPhotosTableUpdateCompanionBuilder,
      (RoundPhoto, $$RoundPhotosTableReferences),
      RoundPhoto,
      PrefetchHooks Function({bool roundId})
    >;
typedef $$BucketListTableCreateCompanionBuilder =
    BucketListCompanion Function({
      Value<int> id,
      Value<int?> courseId,
      Value<String?> freeText,
      Value<bool> done,
      Value<int?> doneRoundId,
    });
typedef $$BucketListTableUpdateCompanionBuilder =
    BucketListCompanion Function({
      Value<int> id,
      Value<int?> courseId,
      Value<String?> freeText,
      Value<bool> done,
      Value<int?> doneRoundId,
    });

final class $$BucketListTableReferences
    extends BaseReferences<_$AppDatabase, $BucketListTable, BucketItem> {
  $$BucketListTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CoursesTable _courseIdTable(_$AppDatabase db) =>
      db.courses.createAlias('bucket_list__course_id__courses__id');

  $$CoursesTableProcessedTableManager? get courseId {
    final $_column = $_itemColumn<int>('course_id');
    if ($_column == null) return null;
    final manager = $$CoursesTableTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RoundsTable _doneRoundIdTable(_$AppDatabase db) =>
      db.rounds.createAlias('bucket_list__done_round_id__rounds__id');

  $$RoundsTableProcessedTableManager? get doneRoundId {
    final $_column = $_itemColumn<int>('done_round_id');
    if ($_column == null) return null;
    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_doneRoundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BucketListTableFilterComposer
    extends Composer<_$AppDatabase, $BucketListTable> {
  $$BucketListTableFilterComposer({
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

  ColumnFilters<String> get freeText => $composableBuilder(
    column: $table.freeText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  $$CoursesTableFilterComposer get courseId {
    final $$CoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoundsTableFilterComposer get doneRoundId {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doneRoundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BucketListTableOrderingComposer
    extends Composer<_$AppDatabase, $BucketListTable> {
  $$BucketListTableOrderingComposer({
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

  ColumnOrderings<String> get freeText => $composableBuilder(
    column: $table.freeText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  $$CoursesTableOrderingComposer get courseId {
    final $$CoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoundsTableOrderingComposer get doneRoundId {
    final $$RoundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doneRoundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableOrderingComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BucketListTableAnnotationComposer
    extends Composer<_$AppDatabase, $BucketListTable> {
  $$BucketListTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get freeText =>
      $composableBuilder(column: $table.freeText, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  $$CoursesTableAnnotationComposer get courseId {
    final $$CoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoundsTableAnnotationComposer get doneRoundId {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doneRoundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BucketListTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BucketListTable,
          BucketItem,
          $$BucketListTableFilterComposer,
          $$BucketListTableOrderingComposer,
          $$BucketListTableAnnotationComposer,
          $$BucketListTableCreateCompanionBuilder,
          $$BucketListTableUpdateCompanionBuilder,
          (BucketItem, $$BucketListTableReferences),
          BucketItem,
          PrefetchHooks Function({bool courseId, bool doneRoundId})
        > {
  $$BucketListTableTableManager(_$AppDatabase db, $BucketListTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BucketListTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BucketListTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BucketListTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> courseId = const Value.absent(),
                Value<String?> freeText = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int?> doneRoundId = const Value.absent(),
              }) => BucketListCompanion(
                id: id,
                courseId: courseId,
                freeText: freeText,
                done: done,
                doneRoundId: doneRoundId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> courseId = const Value.absent(),
                Value<String?> freeText = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int?> doneRoundId = const Value.absent(),
              }) => BucketListCompanion.insert(
                id: id,
                courseId: courseId,
                freeText: freeText,
                done: done,
                doneRoundId: doneRoundId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BucketListTable, BucketItem>(table),
                  $$BucketListTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({courseId = false, doneRoundId = false}) {
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
                    if (courseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.courseId,
                                referencedTable: $$BucketListTableReferences
                                    ._courseIdTable(db),
                                referencedColumn: $$BucketListTableReferences
                                    ._courseIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (doneRoundId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.doneRoundId,
                                referencedTable: $$BucketListTableReferences
                                    ._doneRoundIdTable(db),
                                referencedColumn: $$BucketListTableReferences
                                    ._doneRoundIdTable(db)
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

typedef $$BucketListTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BucketListTable,
      BucketItem,
      $$BucketListTableFilterComposer,
      $$BucketListTableOrderingComposer,
      $$BucketListTableAnnotationComposer,
      $$BucketListTableCreateCompanionBuilder,
      $$BucketListTableUpdateCompanionBuilder,
      (BucketItem, $$BucketListTableReferences),
      BucketItem,
      PrefetchHooks Function({bool courseId, bool doneRoundId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db, _db.courses);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db, _db.rounds);
  $$RoundPhotosTableTableManager get roundPhotos =>
      $$RoundPhotosTableTableManager(_db, _db.roundPhotos);
  $$BucketListTableTableManager get bucketList =>
      $$BucketListTableTableManager(_db, _db.bucketList);
}
