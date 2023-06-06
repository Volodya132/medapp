import 'package:medapp/domain/entity/doctor.dart';
import 'package:medapp/domain/services/crypt_service.dart';

import '../services/SyncService.dart';
import '../services/realmService.dart';

abstract class AuthProviderError {}

class AuthProviderIncorrectLoginDataError {}
class AuthProviderIncorrectPasswordDataError {}

class AuthProvider {
  Future<String> login(String login, String password) async {
    Doctor? doctor = (await RealmService.getDoctorByLogin(login));
    if(doctor == null) {
      throw AuthProviderIncorrectLoginDataError();
    }
    var doctorSalt = doctor.salt;
    final cryptPass = CryptService.encode(password, doctorSalt);
    if(cryptPass != doctor.password) {
      throw AuthProviderIncorrectPasswordDataError();
    }
    SyncService.sync();
    return doctor.id.toString();
  }
}