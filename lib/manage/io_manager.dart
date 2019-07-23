import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'manager.dart';

class IOManager {
  File jsonFile;
  Directory dir;
  String fileName = "skagenData.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent = Map();

  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + "/" + fileName);
    fileExists = jsonFile.existsSync();
    if (fileExists) fileContent = jsonDecode(jsonFile.readAsStringSync());
    print('Initialized IO manager');
  }

  Map<String, dynamic> getManagerData(Manager manager) {
    var name = manager.getName();
    if (!fileContent.containsKey(name)) {
      fileContent[name] = Map<String, dynamic>();
      saveFile();
    }

    return fileContent[name];
  }

  void saveFile() {
    jsonFile.writeAsStringSync(jsonEncode(fileContent));
  }
}
