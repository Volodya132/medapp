import 'package:flutter/material.dart';
import 'package:medapp/ui/helper/translator.dart';


class DropMenuService {

  static List<DropdownMenuItem<String>> fromList2DropItems(List items) {
    List<DropdownMenuItem<String>> res = [];
    for(var elem in items) {
        res.add(DropdownMenuItem(value: elem,child: Text(elem.toString()),));
    }
    return res;
  }
}