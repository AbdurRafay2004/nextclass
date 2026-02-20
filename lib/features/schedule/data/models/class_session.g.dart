// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClassSessionCollection on Isar {
  IsarCollection<ClassSession> get classSessions => this.collection();
}

const ClassSessionSchema = CollectionSchema(
  name: r'ClassSession',
  id: 9125337502516925396,
  properties: {
    r'courseUuid': PropertySchema(
      id: 0,
      name: r'courseUuid',
      type: IsarType.string,
    ),
    r'dayOfWeek': PropertySchema(
      id: 1,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'durationMinutes': PropertySchema(
      id: 2,
      name: r'durationMinutes',
      type: IsarType.long,
    ),
    r'room': PropertySchema(
      id: 3,
      name: r'room',
      type: IsarType.string,
    ),
    r'startTimeMinutes': PropertySchema(
      id: 4,
      name: r'startTimeMinutes',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _ClassSessiontypeEnumValueMap,
    )
  },
  estimateSize: _classSessionEstimateSize,
  serialize: _classSessionSerialize,
  deserialize: _classSessionDeserialize,
  deserializeProp: _classSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _classSessionGetId,
  getLinks: _classSessionGetLinks,
  attach: _classSessionAttach,
  version: '3.1.0+1',
);

int _classSessionEstimateSize(
  ClassSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courseUuid.length * 3;
  bytesCount += 3 + object.room.length * 3;
  return bytesCount;
}

void _classSessionSerialize(
  ClassSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseUuid);
  writer.writeLong(offsets[1], object.dayOfWeek);
  writer.writeLong(offsets[2], object.durationMinutes);
  writer.writeString(offsets[3], object.room);
  writer.writeLong(offsets[4], object.startTimeMinutes);
  writer.writeByte(offsets[5], object.type.index);
}

ClassSession _classSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClassSession();
  object.courseUuid = reader.readString(offsets[0]);
  object.dayOfWeek = reader.readLong(offsets[1]);
  object.durationMinutes = reader.readLong(offsets[2]);
  object.id = id;
  object.room = reader.readString(offsets[3]);
  object.startTimeMinutes = reader.readLong(offsets[4]);
  object.type =
      _ClassSessiontypeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          SessionType.lecture;
  return object;
}

P _classSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (_ClassSessiontypeValueEnumMap[reader.readByteOrNull(offset)] ??
          SessionType.lecture) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ClassSessiontypeEnumValueMap = {
  'lecture': 0,
  'lab': 1,
  'tutorial': 2,
};
const _ClassSessiontypeValueEnumMap = {
  0: SessionType.lecture,
  1: SessionType.lab,
  2: SessionType.tutorial,
};

Id _classSessionGetId(ClassSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _classSessionGetLinks(ClassSession object) {
  return [];
}

void _classSessionAttach(
    IsarCollection<dynamic> col, Id id, ClassSession object) {
  object.id = id;
}

extension ClassSessionQueryWhereSort
    on QueryBuilder<ClassSession, ClassSession, QWhere> {
  QueryBuilder<ClassSession, ClassSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ClassSessionQueryWhere
    on QueryBuilder<ClassSession, ClassSession, QWhereClause> {
  QueryBuilder<ClassSession, ClassSession, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ClassSessionQueryFilter
    on QueryBuilder<ClassSession, ClassSession, QFilterCondition> {
  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      courseUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      dayOfWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      dayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      durationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      durationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      durationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      durationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> roomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      roomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> roomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> roomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'room',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      roomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> roomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> roomContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> roomMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'room',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      roomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'room',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      roomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'room',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      startTimeMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      startTimeMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      startTimeMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      startTimeMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTimeMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> typeEqualTo(
      SessionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition>
      typeGreaterThan(
    SessionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> typeLessThan(
    SessionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterFilterCondition> typeBetween(
    SessionType lower,
    SessionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ClassSessionQueryObject
    on QueryBuilder<ClassSession, ClassSession, QFilterCondition> {}

extension ClassSessionQueryLinks
    on QueryBuilder<ClassSession, ClassSession, QFilterCondition> {}

extension ClassSessionQuerySortBy
    on QueryBuilder<ClassSession, ClassSession, QSortBy> {
  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> sortByCourseUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseUuid', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      sortByCourseUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseUuid', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> sortByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> sortByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      sortByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      sortByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> sortByRoom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> sortByRoomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      sortByStartTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      sortByStartTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ClassSessionQuerySortThenBy
    on QueryBuilder<ClassSession, ClassSession, QSortThenBy> {
  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByCourseUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseUuid', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      thenByCourseUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseUuid', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      thenByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      thenByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByRoom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByRoomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      thenByStartTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy>
      thenByStartTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ClassSessionQueryWhereDistinct
    on QueryBuilder<ClassSession, ClassSession, QDistinct> {
  QueryBuilder<ClassSession, ClassSession, QDistinct> distinctByCourseUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QDistinct> distinctByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfWeek');
    });
  }

  QueryBuilder<ClassSession, ClassSession, QDistinct>
      distinctByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMinutes');
    });
  }

  QueryBuilder<ClassSession, ClassSession, QDistinct> distinctByRoom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'room', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClassSession, ClassSession, QDistinct>
      distinctByStartTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTimeMinutes');
    });
  }

  QueryBuilder<ClassSession, ClassSession, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension ClassSessionQueryProperty
    on QueryBuilder<ClassSession, ClassSession, QQueryProperty> {
  QueryBuilder<ClassSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClassSession, String, QQueryOperations> courseUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseUuid');
    });
  }

  QueryBuilder<ClassSession, int, QQueryOperations> dayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfWeek');
    });
  }

  QueryBuilder<ClassSession, int, QQueryOperations> durationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMinutes');
    });
  }

  QueryBuilder<ClassSession, String, QQueryOperations> roomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'room');
    });
  }

  QueryBuilder<ClassSession, int, QQueryOperations> startTimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTimeMinutes');
    });
  }

  QueryBuilder<ClassSession, SessionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
