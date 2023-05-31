// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evolutionInjury.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class EvolutionInjury extends _EvolutionInjury
    with RealmEntity, RealmObjectBase, RealmObject {
  EvolutionInjury(
    ObjectId? id, {
    Iterable<ObjectId> injureSnapshotsIDs = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'injureSnapshotsIDs', RealmList<ObjectId>(injureSnapshotsIDs));
  }

  EvolutionInjury._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  RealmList<ObjectId> get injureSnapshotsIDs =>
      RealmObjectBase.get<ObjectId>(this, 'injureSnapshotsIDs')
          as RealmList<ObjectId>;
  @override
  set injureSnapshotsIDs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<EvolutionInjury>> get changes =>
      RealmObjectBase.getChanges<EvolutionInjury>(this);

  @override
  EvolutionInjury freeze() =>
      RealmObjectBase.freezeObject<EvolutionInjury>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(EvolutionInjury._);
    return const SchemaObject(
        ObjectType.realmObject, EvolutionInjury, 'EvolutionInjury', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('injureSnapshotsIDs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
    ]);
  }
}
