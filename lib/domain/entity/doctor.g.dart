// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Doctor extends _Doctor with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Doctor(
    ObjectId id, {
    String name = "",
    String login = "",
    String password = "",
    Iterable<ObjectId> patientsIDs = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Doctor>({
        '_id': ObjectId(),
        'name': "",
        'login': "",
        'password': "",
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'login', login);
    RealmObjectBase.set(this, 'password', password);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'patientsIDs', RealmList<ObjectId>(patientsIDs));
  }

  Doctor._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<ObjectId> get patientsIDs =>
      RealmObjectBase.get<ObjectId>(this, 'patientsIDs') as RealmList<ObjectId>;
  @override
  set patientsIDs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get login => RealmObjectBase.get<String>(this, 'login') as String;
  @override
  set login(String value) => RealmObjectBase.set(this, 'login', value);

  @override
  String get password =>
      RealmObjectBase.get<String>(this, 'password') as String;
  @override
  set password(String value) => RealmObjectBase.set(this, 'password', value);

  @override
  Stream<RealmObjectChanges<Doctor>> get changes =>
      RealmObjectBase.getChanges<Doctor>(this);

  @override
  Doctor freeze() => RealmObjectBase.freezeObject<Doctor>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Doctor._);
    return const SchemaObject(ObjectType.realmObject, Doctor, 'Doctor', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('patientsIDs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
      SchemaProperty('login', RealmPropertyType.string),
      SchemaProperty('password', RealmPropertyType.string),
    ]);
  }
}
