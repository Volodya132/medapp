import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:medapp/domain/entity/patient.dart';
import '../entity/injury.dart';
import '../entity/injurySnapshot.dart';
import '../services/realmService.dart';

class InjurySnapshotDataProvider {
  Future<InjurySnapshot?> load(id) async {
    InjurySnapshot? injurySnapshot = (await RealmService.getInjurySnapshotByID(id));

    return injurySnapshot;
  }

  Future<void> save(InjurySnapshot injurySnapshot) async {

  }
}