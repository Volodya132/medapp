import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypt/crypt.dart';

class CryptService {
  static String createSalt([int length = 16]) {
    final rnd = Random.secure();
    final saltBytes = Uint8List(length);
    for (int i = 0; i < saltBytes.length; i++) {
      saltBytes[i] = rnd.nextInt(256);
    }
    return base64.encode(saltBytes);
  }

  static String encode(String password, String salt) {
    return Crypt.sha256(password, salt: salt).toString();
  }
}