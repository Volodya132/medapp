import 'dart:typed_data';

import 'package:medapp/domain/data_providers/reg_provider.dart';
import 'package:medapp/domain/entity/doctor.dart';
import 'package:medapp/domain/entity/patient.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegService {

  final _regProvider = RegProvider();

  final sharedPreferences = SharedPreferences.getInstance();
  Future<void> registerDoctor(Doctor doctor) async {

     await _regProvider.registerDoctor(doctor);
  }

  Future<void> registerPatient(Patient patient) async {
    await _regProvider.registerPatient(patient);
  }

  Future<void> addCurrentInjury(String type, String location, String severity, DateTime timeOfInjury,  String cause, ObjectId? patientID) async {
    await _regProvider.addCurrentInjury(type, location, severity, timeOfInjury, cause, patientID);
  }
  Future<void> addInjurySnapshot(String datetime, List<String> imageLocalPaths, String area, String description,  String severity, ObjectId? injuryID) async {
    await _regProvider.addInjurySnapshot(datetime, imageLocalPaths, area, description,severity, injuryID);
  }


}