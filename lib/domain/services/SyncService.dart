

import 'dart:io';

import 'package:medapp/domain/services/fileService.dart';
import 'package:medapp/domain/services/firebaseService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncService {
    static final sharedPreferences = SharedPreferences.getInstance();

    static void sync() async{
        String? id = (await sharedPreferences).getString('account_id');
        if(id != null) {
            FileService.createDirectory(id);
            final Directory _appDocDir = await getApplicationDocumentsDirectory();
            final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$id');
            FirebaseService.synchronizeFolder(_appDocDirFolder.path, id);
        }
    }
}