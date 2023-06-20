
import '../../generated/l10n.dart';

String translate(String val, context) {
  if(val == "Woman")
    return S.of(context).Woman;
  if(val == "Man")
    return S.of(context).Man;
  return S.of(context).ServiceError;

}

List translateList(List list, context) {
  final listRes = [];
  print(list);
  for(var elem in list) {
    listRes.add(translate(elem, context));
  }
  return listRes.toList(growable: false);

}
