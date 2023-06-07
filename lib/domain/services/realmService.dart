
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/entity/patient.dart';
import 'package:realm/realm.dart';

import '../entity/doctor.dart';
import '../entity/injury.dart';

class RealmService {
  static final String appId = "application-0-ftetu";
  static final Uri baseUrl = Uri.parse("https://realm.mongodb.com");
  static late Realm realm;

  /*RealmService(List<SchemaObject> schemaList) {
    openRealm(schemaList);
  }*/

  static Future<void> openRealm(schemaList) async {
    final appConfig = AppConfiguration(appId, baseUrl: baseUrl);
    final app = App(appConfig);
    final user = await app.logIn(Credentials.anonymous());
    final config = Configuration.flexibleSync(user, schemaList);
    realm = Realm(config);

    //if (_realm.subscriptions.isEmpty) {
      updateSubscriptions();
    //}

  }

  static Future<void> updateSubscriptions() async {

    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
        mutableSubscriptions.add(realm.all<Doctor>(), name: "Doctor");
        mutableSubscriptions.add(realm.all<Patient>(), name: "DoctorsPatient");
        mutableSubscriptions.add(realm.all<Injury>(), name: "Injuries");
        mutableSubscriptions.add(realm.all<InjurySnapshot>(), name: "InjurySnapshot");
    });
    await realm.subscriptions.waitForSynchronization();
  }
  static String makeRealmList(list) {
    return "${"{" + list.map((id) => "oid(${id.toString()})").join(', ')}}";
  }
  static Future<void> updateSubscriptionsDoctor(id, patientsIds) async {

    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
      mutableSubscriptions.add(realm.query<Doctor>('_id == oid($id)'), name: "Doctor");
      mutableSubscriptions.add(realm.all<Patient>(), name: "DoctorsPatient");
      mutableSubscriptions.add(realm.all<Injury>(), name: "Injuries");
      mutableSubscriptions.add(realm.all<InjurySnapshot>(), name: "InjurySnapshot");
    });
    await realm.subscriptions.waitForSynchronization();
  }



 /* static Future<void> updateSubscriptionsFilterPatient(String fio) async {
    var fioList = fio.split(' ');
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.removeByName('DoctorsPatient');
      mutableSubscriptions
      .add(realm.query<Patient>("fname CONTAINS[c] '${fioList[0]}'"), name: "DoctorsPatient");

    });
    await realm.subscriptions.waitForSynchronization();
  }*/

  static Future<void> closeRealm() async {
       realm.close();
  }



  static Future<void> addDoctor(Doctor doctor) async {
    realm.write(() {
      realm.add<Doctor>(doctor, update: true);
    });
  }

  static Future<void> addPatient(Patient patient) async {
    realm.write(() {
      realm.add(patient);
    });
  }

  static Future<void> addInjury(Injury injury) async {
    realm.write(() {
      realm.add(injury);
    });
  }

  static Future<void> addInjurySnapshot(InjurySnapshot injurySnapshot) async {
    realm.write(() {
      realm.add(injurySnapshot);
    });
  }

  static Future<void> addPatientToDoctor(Doctor doctor, Patient patient) async {
    realm.write(() {
      doctor.patientsIDs.add(patient.id);
      realm.add(doctor);
    });
  }

  static Future<void> removePatientFromDoctor(Doctor doctor, patientID) async {
    realm.write(() {
      doctor.patientsIDs.remove(patientID);
      realm.add<Doctor>(doctor, update: true);
    });
  }
  static Future<void> addInjuryToPatient(Patient patient, Injury injury) async {
    realm.write(() {
      patient.currentInjuriesIDs.add(injury.id!);
      realm.add(patient);
    });
  }
  static Future<void> addSnapshotToInjury(InjurySnapshot snapshot, Injury injury) async {
    realm.write(() {
      injury.injurySnapshotIDs.add(snapshot.id!);
      realm.add(snapshot);
    });
  }


  static Future<Doctor?> getDoctorByLoginAndPassword(login, password)async {
     var doctor = realm.query<Doctor>('password == "$password" AND login == "$login"').first;
     return doctor;
  }

  static Future<Doctor?> getDoctorByID(id)async {
    var doctor = realm.query<Doctor>('_id == oid($id)').first;
    return doctor;
  }
  static Future<Doctor?> getDoctorByLogin(login)async {
    var doctor = realm.query<Doctor>('login == "$login"');
    return doctor.isNotEmpty ? doctor.first : null;
  }
  static Patient? getPatientByID(id) {
    var patient = realm.query<Patient>(r'_id == $0',[id]);
    return patient.isNotEmpty ? patient.first : null;
  }

  static Injury? getInjuryByID(id) {
    var injury = realm.query<Injury>(r'_id == $0',[id]);
    return injury.isNotEmpty ? injury.first : null;
  }

  static InjurySnapshot? getInjurySnapshotByID(id) {
    var injurySnapshot = realm.query<InjurySnapshot>(r'_id == $0',[id]);
    return injurySnapshot.isNotEmpty ? injurySnapshot.first : null;
  }

  static Stream<RealmResultsChanges<Patient>> getPatientsChanges(fio, patientsIDS) {
    var patients = makeRealmList(patientsIDS);

    List<String> fioList = fio.split(' ');
    String query = "(_id in $patients) AND";
    for(int i = 0; i< fioList.length; i++) {
      query += "(fname CONTAINS[c] '${fioList[i]}' OR mname CONTAINS[c] '${fioList[i]}' OR lname CONTAINS[c] '${fioList[i]}')";
      if(i < fioList.length-1){
        query += "AND ";
      }
    };
    return RealmService.realm
        .query<Patient>(query)
        .changes;
  }

  static Stream<RealmResultsChanges<Injury>> getInjuriesChanges() {
    return RealmService.realm
        .query<Injury>("TRUEPREDICATE SORT(_id ASC)")
        .changes;
  }
  static Stream<RealmResultsChanges<InjurySnapshot>> getInjurySnapshotChanges() {
    return RealmService.realm
        .query<InjurySnapshot>("TRUEPREDICATE SORT(_id ASC)")
        .changes;
  }

  static Stream<RealmResultsChanges<Doctor>> getDoctorChanges() {
    return RealmService.realm
        .query<Doctor>("TRUEPREDICATE SORT(_id ASC)")
        .changes;
  }


  @override
  static void dispose() {
    realm.close();
  }
}


