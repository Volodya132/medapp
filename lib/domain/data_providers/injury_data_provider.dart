import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:medapp/domain/entity/patient.dart';
import '../entity/injury.dart';
import '../services/realmService.dart';

class InjuryDataProvider {
  Future<Injury?> load(id) async {
    Injury? injury = (await RealmService.getInjuryByID(id));
    return injury;
  }

  Future<void> save(Injury injury) async {

  }

  void removeInjurySnapshot(Injury? injury, injurySnapshot)async {
    if(injury != null) {
      RealmService.removeInjureSnapshotFromInjure(injury, injurySnapshot);
    }
  }
}