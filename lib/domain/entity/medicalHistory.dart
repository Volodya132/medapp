import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:realm/realm.dart';

part 'medicalHistory.g.dart';

@RealmModel()
class _MedicalHistory {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? id;

  List<ObjectId> healedInjuresIDs = [];

}