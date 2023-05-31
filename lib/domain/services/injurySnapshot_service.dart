import 'package:medapp/domain/entity/injurySnapshot.dart';

import '../data_providers/injurySnapshot_data_provider.dart';
import '../data_providers/injury_data_provider.dart';
import '../entity/injury.dart';



class InjurySnapshotService {
  final _injurySnapshotDataProvider = InjurySnapshotDataProvider();
  InjurySnapshot? _injurySnapshot;
  InjurySnapshot? get injurySnapshot => _injurySnapshot;

  Future<void> initilalize(id) async {

    _injurySnapshot = await _injurySnapshotDataProvider.load(id);


  }


}