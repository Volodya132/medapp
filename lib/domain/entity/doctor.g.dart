// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Doctor extends _Doctor with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Doctor(
    ObjectId id, {
    String fName = "",
    String lName = "",
    String mName = "",
    String gender = "",
    String number = "",
    String email = "",
    DateTime? birtday,
    String BIO = "",
    String login = "",
    String password = "",
    String salt = "",
    Iterable<String> specialities = const [],
    Iterable<ObjectId> patientsIDs = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Doctor>({
        '_id': ObjectId(),
        'fName': "",
        'lName': "",
        'mName': "",
        'gender': "",
        'number': "",
        'email': "",
        'BIO': "",
        'login': "",
        'password': "",
        'salt': "",
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'fName', fName);
    RealmObjectBase.set(this, 'lName', lName);
    RealmObjectBase.set(this, 'mName', mName);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'number', number);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'birtday', birtday);
    RealmObjectBase.set(this, 'BIO', BIO);
    RealmObjectBase.set(this, 'login', login);
    RealmObjectBase.set(this, 'password', password);
    RealmObjectBase.set(this, 'salt', salt);
    RealmObjectBase.set<RealmList<String>>(
        this, 'specialities', RealmList<String>(specialities));
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'patientsIDs', RealmList<ObjectId>(patientsIDs));
  }

  Doctor._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get fName => RealmObjectBase.get<String>(this, 'fName') as String;
  @override
  set fName(String value) => RealmObjectBase.set(this, 'fName', value);

  @override
  String get lName => RealmObjectBase.get<String>(this, 'lName') as String;
  @override
  set lName(String value) => RealmObjectBase.set(this, 'lName', value);

  @override
  String get mName => RealmObjectBase.get<String>(this, 'mName') as String;
  @override
  set mName(String value) => RealmObjectBase.set(this, 'mName', value);

  @override
  String get gender => RealmObjectBase.get<String>(this, 'gender') as String;
  @override
  set gender(String value) => RealmObjectBase.set(this, 'gender', value);

  @override
  String get number => RealmObjectBase.get<String>(this, 'number') as String;
  @override
  set number(String value) => RealmObjectBase.set(this, 'number', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  RealmList<String> get specialities =>
      RealmObjectBase.get<String>(this, 'specialities') as RealmList<String>;
  @override
  set specialities(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  DateTime? get birtday =>
      RealmObjectBase.get<DateTime>(this, 'birtday') as DateTime?;
  @override
  set birtday(DateTime? value) => RealmObjectBase.set(this, 'birtday', value);

  @override
  String get BIO => RealmObjectBase.get<String>(this, 'BIO') as String;
  @override
  set BIO(String value) => RealmObjectBase.set(this, 'BIO', value);

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
  RealmList<ObjectId> get patientsIDs =>
      RealmObjectBase.get<ObjectId>(this, 'patientsIDs') as RealmList<ObjectId>;
  @override
  set patientsIDs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get salt => RealmObjectBase.get<String>(this, 'salt') as String;
  @override
  set salt(String value) => RealmObjectBase.set(this, 'salt', value);

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
      SchemaProperty('fName', RealmPropertyType.string),
      SchemaProperty('lName', RealmPropertyType.string),
      SchemaProperty('mName', RealmPropertyType.string),
      SchemaProperty('gender', RealmPropertyType.string),
      SchemaProperty('number', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('specialities', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('birtday', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('BIO', RealmPropertyType.string),
      SchemaProperty('login', RealmPropertyType.string),
      SchemaProperty('password', RealmPropertyType.string),
      SchemaProperty('patientsIDs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
      SchemaProperty('salt', RealmPropertyType.string),
    ]);
  }
}
