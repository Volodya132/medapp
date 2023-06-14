import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:realm/realm.dart';

import '../services/realmService.dart';
part 'injury.g.dart';

enum InjurySeverity {
  mild,
  moderate,
  severe
}

@RealmModel()
class _Injury {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? id;


  String? type;
  String? location;
  String? severity;
  DateTime? timeOfInjury;
  String? cause;
  List<String> additionalSymptoms = [];
  List<ObjectId> injurySnapshotIDs = [];

  InjurySeverity? getSeverityEnum() {
    return severity != null ? InjurySeverity.values.firstWhere((e) => e.toString().split('.').last == severity) : null;
  }
  DateTime? getLastChange() {
    DateTime? result = timeOfInjury;
    for(int i = 0; i <injurySnapshot.length; i++) {
      if (result == null) {
        if (injurySnapshot[i] != null) {
          result = injurySnapshot[i]?.datetime;
        }
      }
      else {
        DateTime? last = injurySnapshot[i]?.datetime;
        if (last != null && last.isAfter(result)) {
          result = last;
        }
      }
    }
    return result;
  }
  List<InjurySnapshot?> get injurySnapshot => injurySnapshotIDs.map((id) => RealmService.getInjurySnapshotByID(id)).toList();
}












