import 'dart:math';
import 'package:medapp/domain/data_providers/doctor_data_provider.dart';
import 'package:medapp/domain/entity/doctor.dart';
import 'package:medapp/domain/services/realmService.dart';

import '../data_providers/user_data_provider.dart';


class DoctorService {
  final _doctorDataProvider = DoctorDataProvider();
  Doctor? _doctor;
  Doctor? get doctor => _doctor;

  Future<void> initilalize() async {
    _doctor = await _doctorDataProvider.load();

    /*if(_doctor != null) {
      RealmService.updateSubscriptionsForDoctor(_doctor?.id);
    }*/
  }


}