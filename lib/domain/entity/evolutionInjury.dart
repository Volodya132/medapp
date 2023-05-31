import 'package:medapp/domain/entity/injury.dart';
import 'package:realm/realm.dart';

import 'injurySnapshot.dart';
part 'evolutionInjury.g.dart';

@RealmModel()
class _EvolutionInjury  {
    @PrimaryKey()
    @MapTo('_id')
    ObjectId? id;

    List<ObjectId> injureSnapshotsIDs = [];

    DateTime? getLastChange() {
        DateTime? result;
        for (int i = 0; i < injureSnapshots.length; i++) {
            if(result == null || injureSnapshots[i].datetime!.isAfter(result)){
              result = injureSnapshots[i].datetime;
            }
        }
        return result;
    }

    List<InjurySnapshot> get injureSnapshots => [];
}