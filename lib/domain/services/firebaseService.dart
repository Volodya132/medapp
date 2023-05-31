import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:dio/dio.dart';

class FirebaseService {
  static FirebaseStorage storage = FirebaseStorage.instance;
  static Dio dio = Dio();

  static List<String> createDBPaths(List<String> filePaths, String directoryPath) {
    for(int i = 0; i < filePaths.length; i++) {
      String fileName = filePaths[i].split('/').last;
      filePaths[i] = '$directoryPath/$fileName';
    }
    return filePaths;
  }
  static Future<void> uploadFile(String filePath, String fileName, String directoryPath) async {
    try {
      await storage.ref('$directoryPath/$fileName').putFile(File(filePath));
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future<List<String>> uploadFiles(List<String> filePaths, String directoryPath) async {
    List<String> paths = [];
    try {
      await Future.wait(filePaths.map((filePath) async {
        String fileName = filePath.split('/').last;
        paths.add('$directoryPath/$fileName');
        await storage.ref(paths.last).putFile(File(filePath));
      }));
    } on FirebaseException catch (e) {
      print(e);
    }
    return paths;
  }
  static Future<List<String>> getAllFileNamesInDirectory(path)async {
    List<String> res = [];
    final items = (await storage.ref(path).listAll()).items;
    for(var item in items){
      res.add(item.fullPath);
    }
    return res;
  }
  static Future<void> synchronizeFolder(String localFolderPath, String storageFolderPath) async {
    try {
      final localDirectory = Directory(localFolderPath);

      // Get local files and folders
      final localEntities = localDirectory.listSync(recursive: true);
      final localFiles = localEntities
          .where((FileSystemEntity entity) => entity is File)
          .map((FileSystemEntity entity) => entity.path)
          .toList();

      final localDirectories = localEntities
          .where((FileSystemEntity entity) => entity is Directory)
          .map((FileSystemEntity entity) => entity.path)
          .toList();

      // Create directories in Firebase Storage
      for (String directoryPath in localDirectories) {
        String relativePath = Path.relative(directoryPath, from: localDirectory.path);
        await storage.ref('$storageFolderPath/$relativePath').listAll();
      }

      // Get list of files in Firebase Storage
      final storageDirectoryList = (await storage.ref(storageFolderPath).listAll()).prefixes;
      Set<String> storageFilesList = {};
      for (Reference ref in storageDirectoryList) {
        storageFilesList.addAll(await getAllFileNamesInDirectory(ref.fullPath));
      }
      for(var item in storageFilesList) {
        print(item);
      }
      //final storageFileNames = storageFilesList.map((ref) => ref.name).toSet();

      // Files present locally but not on storage -> upload to storage
      final filesToUpload = localFiles
          .where((path) => !storageFilesList.contains(Path.relative(path, from: localDirectory.path)))
          .toList();
      await uploadFilesWithStructure(filesToUpload, localFolderPath, storageFolderPath);

      // Files present on storage but not locally -> download from storage
      final filesToDownload = storageFilesList
          .where((name) => !localFiles.contains('${Path.dirname(localFolderPath)}/$name'))
          .toList();
      for (final file in filesToDownload) {
        downloadFileWithStructure(file, Path.dirname(localFolderPath));
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future<void> uploadFilesWithStructure(List<String> filePaths, String localBasePath, String storageBasePath) async {
    for (String filePath in filePaths) {
      File file = File(filePath);
      try {
        String relativePath = Path.relative(filePath, from: localBasePath);
        await storage.ref('$storageBasePath/$relativePath').putFile(file);
      } catch (e) {
        print('Failed to upload file: $e');
      }
    }
  }

  static Future<void> downloadFileWithStructure(String storageFilePath, String localBasePath) async {
    try {
      final ref = storage.ref(storageFilePath);
      final url = await ref.getDownloadURL();
      final localFilePath = Path.join(localBasePath, storageFilePath);

      // Ensure the directory exists
      await Directory(Path.dirname(localFilePath)).create(recursive: true);

      await dio.download(url, localFilePath);
      print('File downloaded to $localFilePath');
    } catch (e) {
      print('Failed to download file: $e');
    }
  }
}





