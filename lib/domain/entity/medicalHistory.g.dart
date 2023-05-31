// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicalHistory.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class MedicalHistory extends _MedicalHistory
    with RealmEntity, RealmObjectBase, RealmObject {
  MedicalHistory(
    ObjectId? id, {
    Iterable<ObjectId> healedInjuresIDs = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'healedInjuresIDs', RealmList<ObjectId>(healedInjuresIDs));
  }

  MedicalHistory._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  RealmList<ObjectId> get healedInjuresIDs =>
      RealmObjectBase.get<ObjectId>(this, 'healedInjuresIDs')
          as RealmList<ObjectId>;
  @override
  set healedInjuresIDs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<MedicalHistory>> get changes =>
      RealmObjectBase.getChanges<MedicalHistory>(this);

  @override
  MedicalHistory freeze() => RealmObjectBase.freezeObject<MedicalHistory>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MedicalHistory._);
    return const SchemaObject(
        ObjectType.realmObject, MedicalHistory, 'MedicalHistory', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('healedInjuresIDs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
    ]);
  }
}
