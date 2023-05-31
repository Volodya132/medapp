// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injurySnapshot.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class InjurySnapshot extends _InjurySnapshot
    with RealmEntity, RealmObjectBase, RealmObject {
  InjurySnapshot(
    ObjectId? id, {
    DateTime? datetime,
    double? area,
    String? description,
    String? severity,
    Iterable<String> imageLocalPaths = const [],
    Iterable<String> imageDBPaths = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'datetime', datetime);
    RealmObjectBase.set(this, 'area', area);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'severity', severity);
    RealmObjectBase.set<RealmList<String>>(
        this, 'imageLocalPaths', RealmList<String>(imageLocalPaths));
    RealmObjectBase.set<RealmList<String>>(
        this, 'imageDBPaths', RealmList<String>(imageDBPaths));
  }

  InjurySnapshot._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  DateTime? get datetime =>
      RealmObjectBase.get<DateTime>(this, 'datetime') as DateTime?;
  @override
  set datetime(DateTime? value) => RealmObjectBase.set(this, 'datetime', value);

  @override
  RealmList<String> get imageLocalPaths =>
      RealmObjectBase.get<String>(this, 'imageLocalPaths') as RealmList<String>;
  @override
  set imageLocalPaths(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get imageDBPaths =>
      RealmObjectBase.get<String>(this, 'imageDBPaths') as RealmList<String>;
  @override
  set imageDBPaths(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  double? get area => RealmObjectBase.get<double>(this, 'area') as double?;
  @override
  set area(double? value) => RealmObjectBase.set(this, 'area', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get severity =>
      RealmObjectBase.get<String>(this, 'severity') as String?;
  @override
  set severity(String? value) => RealmObjectBase.set(this, 'severity', value);

  @override
  Stream<RealmObjectChanges<InjurySnapshot>> get changes =>
      RealmObjectBase.getChanges<InjurySnapshot>(this);

  @override
  InjurySnapshot freeze() => RealmObjectBase.freezeObject<InjurySnapshot>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(InjurySnapshot._);
    return const SchemaObject(
        ObjectType.realmObject, InjurySnapshot, 'InjurySnapshot', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('datetime', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('imageLocalPaths', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('imageDBPaths', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('area', RealmPropertyType.double, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('severity', RealmPropertyType.string, optional: true),
    ]);
  }
}
