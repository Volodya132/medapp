
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/entity/patient.dart';
import 'package:medapp/domain/services/crypt_service.dart';
import 'package:medapp/domain/services/firebaseService.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/doctor.dart';
import '../entity/injury.dart';
import '../services/fileService.dart';

abstract class RegProviderError {}

class RegProviderIncorrectLoginDataError {}

class RegProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<void> registerDoctor(Doctor doctor) async {
    if((await RealmService.getDoctorByLogin(doctor.login)) != null) {
      throw RegProviderIncorrectLoginDataError();
    }
    doctor.salt = CryptService.createSalt();
    doctor.password = CryptService.encode( doctor.password, doctor.salt);
    await RealmService.addDoctor(doctor);
  }

  Future<void> registerPatient(Patient patient) async {
    String? id = (await _sharedPreferences).getString('account_id');
    Doctor? doctor = (await RealmService.getDoctorByID(id));

    await RealmService.addPatientToDoctor(doctor!, patient);
    await RealmService.addPatient(patient);

    //await RealmService.updateSubscriptionsDoctor(doctor.id, doctor.patientsIDs);
  }

  Future<void> addCurrentInjury(
      String type,
      String location,
      String severity,
      DateTime timeOfInjury,
      String cause,
      ObjectId? patientID) async {
    var injury = Injury(ObjectId(), type: type, location: location, severity: severity, timeOfInjury: timeOfInjury, cause: cause );
    Patient? patient = (await RealmService.getPatientByID(patientID));
    await RealmService.addInjury(injury);
    await RealmService.addInjuryToPatient(patient!, injury);
  }

  Future<void> addInjurySnapshot(
      DateTime datetime,
      List<String> imageLocalPaths,
      String area,
      String description,
      String severity,
      ObjectId? injuryID) async {

    String doctorId = (await _sharedPreferences).getString('account_id')!; //
    String injuryIdString = injuryID.toString();
    imageLocalPaths = await FileService.copyFiles(imageLocalPaths, "$doctorId/$injuryIdString");
    List<String> dbPaths = await FirebaseService.uploadFiles(imageLocalPaths, "$doctorId/$injuryIdString");
    double castArea = double.parse(area);

    var injurySnapshot = InjurySnapshot(ObjectId(), datetime: datetime, imageLocalPaths: imageLocalPaths, imageDBPaths: dbPaths, area: castArea, description: description, severity: severity );
    Injury? injury = (await RealmService.getInjuryByID(injuryID));
    await RealmService.addInjurySnapshot(injurySnapshot);
    await RealmService.addSnapshotToInjury(injurySnapshot, injury!);

  }
}