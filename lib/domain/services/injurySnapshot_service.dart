import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_providers/injurySnapshot_data_provider.dart';
import '../data_providers/injury_data_provider.dart';
import '../entity/injury.dart';
import 'fileService.dart';
import 'firebaseService.dart';



class InjurySnapshotService {
  final _sharedPreferences = SharedPreferences.getInstance();

  final _injurySnapshotDataProvider = InjurySnapshotDataProvider();
  InjurySnapshot? _injurySnapshot;
  InjurySnapshot? get injurySnapshot => _injurySnapshot;

  Future<void> initilalize(id) async {

    _injurySnapshot = await _injurySnapshotDataProvider.load(id);


  }

  Future<void> addPhotos(Photos, injuryID, injurySnapshotID)async {
    String doctorId = (await _sharedPreferences).getString('account_id')!;
    List<String> imageLocalPaths = (await FileService.copyFiles(Photos, "$doctorId/${injuryID.toString()}"));
    List<String> dbPaths = await FirebaseService.uploadFiles(imageLocalPaths, "$doctorId/${injuryID.toString()}");

    _injurySnapshotDataProvider.addPhotos(imageLocalPaths, dbPaths, injurySnapshotID);

  }

}