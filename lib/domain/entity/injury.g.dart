// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injury.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Injury extends _Injury with RealmEntity, RealmObjectBase, RealmObject {
  Injury(
    ObjectId? id, {
    String? type,
    String? location,
    String? severity,
    DateTime? timeOfInjury,
    String? cause,
    Iterable<String> additionalSymptoms = const [],
    Iterable<ObjectId> injurySnapshotIDs = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'location', location);
    RealmObjectBase.set(this, 'severity', severity);
    RealmObjectBase.set(this, 'timeOfInjury', timeOfInjury);
    RealmObjectBase.set(this, 'cause', cause);
    RealmObjectBase.set<RealmList<String>>(
        this, 'additionalSymptoms', RealmList<String>(additionalSymptoms));
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'injurySnapshotIDs', RealmList<ObjectId>(injurySnapshotIDs));
  }

  Injury._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get location =>
      RealmObjectBase.get<String>(this, 'location') as String?;
  @override
  set location(String? value) => RealmObjectBase.set(this, 'location', value);

  @override
  String? get severity =>
      RealmObjectBase.get<String>(this, 'severity') as String?;
  @override
  set severity(String? value) => RealmObjectBase.set(this, 'severity', value);

  @override
  DateTime? get timeOfInjury =>
      RealmObjectBase.get<DateTime>(this, 'timeOfInjury') as DateTime?;
  @override
  set timeOfInjury(DateTime? value) =>
      RealmObjectBase.set(this, 'timeOfInjury', value);

  @override
  String? get cause => RealmObjectBase.get<String>(this, 'cause') as String?;
  @override
  set cause(String? value) => RealmObjectBase.set(this, 'cause', value);

  @override
  RealmList<String> get additionalSymptoms =>
      RealmObjectBase.get<String>(this, 'additionalSymptoms')
          as RealmList<String>;
  @override
  set additionalSymptoms(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<ObjectId> get injurySnapshotIDs =>
      RealmObjectBase.get<ObjectId>(this, 'injurySnapshotIDs')
          as RealmList<ObjectId>;
  @override
  set injurySnapshotIDs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Injury>> get changes =>
      RealmObjectBase.getChanges<Injury>(this);

  @override
  Injury freeze() => RealmObjectBase.freezeObject<Injury>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Injury._);
    return const SchemaObject(ObjectType.realmObject, Injury, 'Injury', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('location', RealmPropertyType.string, optional: true),
      SchemaProperty('severity', RealmPropertyType.string, optional: true),
      SchemaProperty('timeOfInjury', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('cause', RealmPropertyType.string, optional: true),
      SchemaProperty('additionalSymptoms', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('injurySnapshotIDs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
    ]);
  }
}
