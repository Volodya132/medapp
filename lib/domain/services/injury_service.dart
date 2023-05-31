import '../data_providers/injury_data_provider.dart';
import '../entity/injury.dart';



class InjuryService {
  final _injuryDataProvider = InjuryDataProvider();
  Injury? _injury;
  Injury? get injury => _injury;

  Future<void> initilalize(id) async {
    _injury = await _injuryDataProvider.load(id);
  }


}