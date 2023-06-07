import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/doctor.dart';
import '../services/realmService.dart';

class DoctorDataProvider {
  final sharedPreferences = SharedPreferences.getInstance();
  Future<Doctor?> load() async {

    String? id = (await sharedPreferences).getString('account_id');

    Doctor? doctor = (await RealmService.getDoctorByID(id));
    if(doctor!=null) {
      RealmService.updateSubscriptionsDoctor(id, doctor.patientsIDs);
      //rs.closeRealm();
      return doctor;
    }
  }


  Future<void> save(Doctor? doctor, patientID) async {
    if(doctor != null) {
      RealmService.addDoctor(doctor);
    }
  }
  Future<void> removePatient(Doctor? doctor, patientsID) async {
    if(doctor != null) {
      RealmService.removePatientFromDoctor(doctor, patientsID);
    }
  }


}