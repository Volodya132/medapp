
import 'dart:typed_data';

import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:realm/realm.dart';

import 'injury.dart';
part 'injurySnapshot.g.dart';

@RealmModel()
class _InjurySnapshot {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? id;

  DateTime? datetime;
  List<String>  imageLocalPaths = [];
  List<String>  imageDBPaths = [];
  double? area;
  String? description;
  String? severity;

  void setImageLocalPaths( List<String> newPaths) {
    imageLocalPaths.clear();
    imageLocalPaths.addAll(newPaths);
  }

  void setDBPaths( List<String> newPaths) {
    imageDBPaths.clear();
    imageDBPaths.addAll(newPaths);
  }
}
