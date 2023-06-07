import 'package:medapp/domain/services/crypt_service.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/doctor.dart';
import '../services/realmService.dart';


class DoctorDataProviderError {}

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


  Future<void> save(Doctor? doctor) async {
    if(doctor != null) {
      RealmService.addDoctor(doctor);
    }
  }
  Future<void> removePatient(Doctor? doctor, patientsID) async {
    if(doctor != null) {
      RealmService.removePatientFromDoctor(doctor, patientsID);
    }
  }

  Future<bool> isDoctorPassword(password)async {
    Doctor? doctor = await load();
    if(doctor != null) {
      String hashPassword = CryptService.encode(password, doctor.salt);
      if(hashPassword == doctor.password) {
        return true;
      }
    }
    return false;
  }


  Future<void> changePassword(oldPassword, newPassword)async {
    Doctor? doctor = await load();
    if(doctor != null) {
      String newSalt = CryptService.createSalt();
      oldPassword = CryptService.encode(oldPassword, doctor.salt);
      newPassword = CryptService.encode(newPassword, newSalt);
      RealmService.changePasswordDoctor(doctor, oldPassword, newPassword, newSalt);
      return;
    }
    throw DoctorDataProviderError;
  }


}