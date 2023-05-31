import 'package:medapp/domain/entity/patient.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:realm/realm.dart';
part 'doctor.g.dart';



@RealmModel()
class _Doctor {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId id = ObjectId();

  String name = "";
  List<ObjectId> patientsIDs = [];

  String login = "";
  String password = "";

  List<Patient?> get patients => patientsIDs.map((id) => RealmService.getPatientByID(id)).toList();

}