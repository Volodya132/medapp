import 'package:medapp/domain/entity/doctor.dart';

import '../services/SyncService.dart';
import '../services/realmService.dart';

abstract class AuthProviderError {}

class AuthProviderIncorrectLoginDataError {}

class AuthProvider {
  Future<String> login(String login, String password) async {

    var doctorID = (await RealmService.getDoctorByLoginAndPassword(login, password))?.id;
    //rs.closeRealm();
    if (doctorID != null) {
      SyncService.sync();
      return doctorID.toString();
    } else {
      throw AuthProviderIncorrectLoginDataError();
    }
  }
}