import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> createDirectory(dirName) async{
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$dirName');

    if (await _appDocDirFolder.exists()) {
    return _appDocDirFolder.path;
    } else {
    await _appDocDirFolder.create(recursive: true);
    return _appDocDirFolder.path;
    }
  }

  static Future<List<String>> copyFiles(List<String> files, newDir)async {
    final path = await createDirectory(newDir);
    for(int i = 0; i < files.length; i++) {

      final originalFile = File(files[i]);
      String newName = '${DateTime.now().microsecondsSinceEpoch}.${files[i].split('/').last.split('.').last}';
      files[i] = (await originalFile.copy("$path/$newName")).path;
    }
    return files;
  }


}