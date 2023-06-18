
import 'dart:io';

import 'package:flutter/cupertino.dart';

ImageProvider<Object> getImageIfExist(String? path) {
  if (path == null) {
    return const AssetImage("assets/images/loader.png");
  }
  if (path.isEmpty) {
    return const AssetImage("assets/images/loader.png");
  }
  var file = File(path);
  if (file.existsSync()) {
    return FileImage(file);
  } else {
    return const AssetImage("assets/images/loader.png");
  }
}
