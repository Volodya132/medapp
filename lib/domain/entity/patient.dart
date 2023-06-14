import 'package:medapp/domain/entity/medicalHistory.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:realm/realm.dart';
import 'evolutionInjury.dart';
import 'injury.dart';

part 'patient.g.dart';

@RealmModel()
class _Patient {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  String? fname;
  String? mname;
  String? lname;
  DateTime? birthday;
  String? gender;
  String? address;
  String? phoneNumber;
  ObjectId? medicalHistoryID;
  List<ObjectId> currentInjuriesIDs = [];



  DateTime? getLastChange() {
    DateTime? result;
    for(int i = 0; i <currentInjuries.length; i++) {
      if (result == null) {
        if (currentInjuries[i] is EvolutionInjury) {
          result = (currentInjuries[i] as EvolutionInjury).getLastChange();
        }
        else {
          result = currentInjuries[i].getLastChange();
        }
      }
      else {
        DateTime? last;
        if (currentInjuries[i] is EvolutionInjury) {
          last = (currentInjuries[i] as EvolutionInjury).getLastChange();
        }
        else {
          last = currentInjuries[i].getLastChange();
        }
        if (last != null && last.isAfter(result)) {
          result = last;
        }
      }
    }
    return result;
  }

  List<Injury> get currentInjuries => currentInjuriesIDs.map((id) => RealmService.getInjuryByID(id)!).toList();
}
