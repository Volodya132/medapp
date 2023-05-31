import 'package:medapp/domain/entity/patient.dart';
import '../services/realmService.dart';

class PatientDataProvider {
  Future<Patient?> load(id) async {
    Patient? patient = (await RealmService.getPatientByID(id));
    //RealmService.updateSubscriptionsDoctor(id);
    //rs.closeRealm();
    return patient;
  }

  Future<void> save(Patient patient) async {

  }
}