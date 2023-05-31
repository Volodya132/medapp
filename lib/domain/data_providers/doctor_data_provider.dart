import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/doctor.dart';
import '../services/realmService.dart';

class DoctorDataProvider {
  final sharedPreferences = SharedPreferences.getInstance();
  Future<Doctor?> load() async {

    String? id = (await sharedPreferences).getString('account_id');

    Doctor? doctor = (await RealmService.getDoctorByID(id));
    RealmService.updateSubscriptionsDoctor(id);
    //rs.closeRealm();
    return doctor;


  }

  Future<void> save(Doctor doctor) async {

  }
}