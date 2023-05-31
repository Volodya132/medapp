import 'package:medapp/domain/data_providers/patient_data_provider.dart';
import 'package:medapp/domain/entity/patient.dart';



class PatientService {
  final _patientDataProvider = PatientDataProvider();
  Patient? _patient;
  Patient? get patient => _patient;

  Future<void> initilalize(id) async {
    _patient = await _patientDataProvider.load(id);

    /*if(_doctor != null) {
      RealmService.updateSubscriptionsForDoctor(_doctor?.id);
    }*/
  }


}