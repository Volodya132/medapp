import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

String? passwordValidator(BuildContext context, String? password) {
  if (password == null || password.isEmpty) {
    return S.of(context).FieldCannotBeEmpty;
  }
  if( !password.contains(RegExp(r'[A-Z]'))) {
    return S.of(context).ThePasswordMustContainAtLeastOneUppercaseLetter;
  }
  if( !password.contains(RegExp(r'[0-9]'))) {
    return S.of(context).ThePasswordMustContainAtLeastOneDigit;
  }
  if( !password.contains(RegExp(r'[a-z]'))) {
    return S.of(context).ThePasswordMustContainAtLeastOneLowercaseLetter;
  }
  if( !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return S.of(context).ThePasswordMustContainAtLeastOneSpecialCharacter;
  }
  if( password.length < 8) {
    return S.of(context).ThePasswordMustContainAMinimumOf8Characters;
  }
  return null;

}