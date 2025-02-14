import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<String> saveImage(String sourcePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = const Uuid().v4() + '.jpg';
    final String targetPath = '${directory.path}/images/$fileName';

    // Create images directory if it doesn't exist
    final imageDir = Directory('${directory.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    // Copy image to app's local storage
    await File(sourcePath).copy(targetPath);
    return targetPath;
  }

  Future<File?> getImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
    return null;
  }
}
