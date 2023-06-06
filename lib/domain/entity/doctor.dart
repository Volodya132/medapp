import 'package:medapp/domain/entity/patient.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:realm/realm.dart';
part 'doctor.g.dart';



@RealmModel()
class _Doctor {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId id = ObjectId();

  String fName = "";
  String lName = "";
  String mName = "";
  String gender = "";
  String number = "";
  String email = "";
  List<String> specialities = [];
  DateTime? birtday;
  String BIO = "";
  String login = "";
  String password = "";

  List<ObjectId> patientsIDs = [];

  String salt = "";



  List<Patient?> get patients => patientsIDs.map((id) => RealmService.getPatientByID(id)).toList();


}