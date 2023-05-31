// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Patient extends _Patient with RealmEntity, RealmObjectBase, RealmObject {
  Patient(
    ObjectId id, {
    String? fname,
    String? mname,
    String? lname,
    int? age,
    String? gender,
    String? address,
    String? phoneNumber,
    ObjectId? medicalHistoryID,
    Iterable<ObjectId> currentInjuriesIDs = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'fname', fname);
    RealmObjectBase.set(this, 'mname', mname);
    RealmObjectBase.set(this, 'lname', lname);
    RealmObjectBase.set(this, 'age', age);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
    RealmObjectBase.set(this, 'medicalHistoryID', medicalHistoryID);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'currentInjuriesIDs', RealmList<ObjectId>(currentInjuriesIDs));
  }

  Patient._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get fname => RealmObjectBase.get<String>(this, 'fname') as String?;
  @override
  set fname(String? value) => RealmObjectBase.set(this, 'fname', value);

  @override
  String? get mname => RealmObjectBase.get<String>(this, 'mname') as String?;
  @override
  set mname(String? value) => RealmObjectBase.set(this, 'mname', value);

  @override
  String? get lname => RealmObjectBase.get<String>(this, 'lname') as String?;
  @override
  set lname(String? value) => RealmObjectBase.set(this, 'lname', value);

  @override
  int? get age => RealmObjectBase.get<int>(this, 'age') as int?;
  @override
  set age(int? value) => RealmObjectBase.set(this, 'age', value);

  @override
  String? get gender => RealmObjectBase.get<String>(this, 'gender') as String?;
  @override
  set gender(String? value) => RealmObjectBase.set(this, 'gender', value);

  @override
  String? get address =>
      RealmObjectBase.get<String>(this, 'address') as String?;
  @override
  set address(String? value) => RealmObjectBase.set(this, 'address', value);

  @override
  String? get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
  @override
  set phoneNumber(String? value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  ObjectId? get medicalHistoryID =>
      RealmObjectBase.get<ObjectId>(this, 'medicalHistoryID') as ObjectId?;
  @override
  set medicalHistoryID(ObjectId? value) =>
      RealmObjectBase.set(this, 'medicalHistoryID', value);

  @override
  RealmList<ObjectId> get currentInjuriesIDs =>
      RealmObjectBase.get<ObjectId>(this, 'currentInjuriesIDs')
          as RealmList<ObjectId>;
  @override
  set currentInjuriesIDs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Patient>> get changes =>
      RealmObjectBase.getChanges<Patient>(this);

  @override
  Patient freeze() => RealmObjectBase.freezeObject<Patient>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Patient._);
    return const SchemaObject(ObjectType.realmObject, Patient, 'Patient', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('fname', RealmPropertyType.string, optional: true),
      SchemaProperty('mname', RealmPropertyType.string, optional: true),
      SchemaProperty('lname', RealmPropertyType.string, optional: true),
      SchemaProperty('age', RealmPropertyType.int, optional: true),
      SchemaProperty('gender', RealmPropertyType.string, optional: true),
      SchemaProperty('address', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('medicalHistoryID', RealmPropertyType.objectid,
          optional: true),
      SchemaProperty('currentInjuriesIDs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
    ]);
  }
}
