import 'package:realm/realm.dart';
part 'healedInjure.g.dart';

@RealmModel()
class _HealedInjure {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? id;

  int? injury;
  DateTime? dateTime;
  String? doctorReport;



}