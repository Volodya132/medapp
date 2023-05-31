// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'healedInjure.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class HealedInjure extends _HealedInjure
    with RealmEntity, RealmObjectBase, RealmObject {
  HealedInjure(
    ObjectId? id, {
    int? injury,
    DateTime? dateTime,
    String? doctorReport,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'injury', injury);
    RealmObjectBase.set(this, 'dateTime', dateTime);
    RealmObjectBase.set(this, 'doctorReport', doctorReport);
  }

  HealedInjure._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get injury => RealmObjectBase.get<int>(this, 'injury') as int?;
  @override
  set injury(int? value) => RealmObjectBase.set(this, 'injury', value);

  @override
  DateTime? get dateTime =>
      RealmObjectBase.get<DateTime>(this, 'dateTime') as DateTime?;
  @override
  set dateTime(DateTime? value) => RealmObjectBase.set(this, 'dateTime', value);

  @override
  String? get doctorReport =>
      RealmObjectBase.get<String>(this, 'doctorReport') as String?;
  @override
  set doctorReport(String? value) =>
      RealmObjectBase.set(this, 'doctorReport', value);

  @override
  Stream<RealmObjectChanges<HealedInjure>> get changes =>
      RealmObjectBase.getChanges<HealedInjure>(this);

  @override
  HealedInjure freeze() => RealmObjectBase.freezeObject<HealedInjure>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(HealedInjure._);
    return const SchemaObject(
        ObjectType.realmObject, HealedInjure, 'HealedInjure', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('injury', RealmPropertyType.int, optional: true),
      SchemaProperty('dateTime', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('doctorReport', RealmPropertyType.string, optional: true),
    ]);
  }
}
