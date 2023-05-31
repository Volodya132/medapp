import 'dart:typed_data';

import 'package:medapp/domain/data_providers/reg_provider.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegService {

  final _regProvider = RegProvider();

  final sharedPreferences = SharedPreferences.getInstance();
  Future<void> registerDoctor(String login, String password, String name) async {
     await _regProvider.registerDoctor(login, password, name);
  }

  Future<void> registerPatient(String fname, String mname, String lname,String age, String gender, String phoneNumber, String? id) async {
    await _regProvider.registerPatient(fname, mname, lname, age, gender, phoneNumber, id);
  }

  Future<void> addCurrentInjury(String type, String location, String severity, String timeOfInjury,  String cause, ObjectId? patientID) async {
    await _regProvider.addCurrentInjury(type, location, severity, timeOfInjury, cause, patientID);
  }
  Future<void> addInjurySnapshot(String datetime, List<String> imageLocalPaths, String area, String description,  String severity, ObjectId? injuryID) async {
    await _regProvider.addInjurySnapshot(datetime, imageLocalPaths, area, description,severity, injuryID);
  }


}