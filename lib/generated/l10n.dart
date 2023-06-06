// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get Hello {
    return Intl.message(
      'Hello',
      name: 'Hello',
      desc: '',
      args: [],
    );
  }

  /// `I am happy to see you again. You can continue where you left off by logging in`
  String get SubtitleOnLoginScreen {
    return Intl.message(
      'I am happy to see you again. You can continue where you left off by logging in',
      name: 'SubtitleOnLoginScreen',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get WelcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'WelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `How do you do?`
  String get HowDoYouDo {
    return Intl.message(
      'How do you do?',
      name: 'HowDoYouDo',
      desc: '',
      args: [],
    );
  }

  /// `Patient search`
  String get PatientSearchHint {
    return Intl.message(
      'Patient search',
      name: 'PatientSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Patients`
  String get PatientsLbl {
    return Intl.message(
      'Patients',
      name: 'PatientsLbl',
      desc: '',
      args: [],
    );
  }

  /// `Last change`
  String get LastChange {
    return Intl.message(
      'Last change',
      name: 'LastChange',
      desc: '',
      args: [],
    );
  }

  /// `Add patient`
  String get AddPatient {
    return Intl.message(
      'Add patient',
      name: 'AddPatient',
      desc: '',
      args: [],
    );
  }

  /// `no information`
  String get NoInformation {
    return Intl.message(
      'no information',
      name: 'NoInformation',
      desc: '',
      args: [],
    );
  }

  /// `Wrong answer or password`
  String get WrongAnswerOrPassword {
    return Intl.message(
      'Wrong answer or password',
      name: 'WrongAnswerOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Service error`
  String get ServiceError {
    return Intl.message(
      'Service error',
      name: 'ServiceError',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get Area {
    return Intl.message(
      'Area',
      name: 'Area',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get Type {
    return Intl.message(
      'Type',
      name: 'Type',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get Location {
    return Intl.message(
      'Location',
      name: 'Location',
      desc: '',
      args: [],
    );
  }

  /// `Severity`
  String get Severity {
    return Intl.message(
      'Severity',
      name: 'Severity',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get Time {
    return Intl.message(
      'Time',
      name: 'Time',
      desc: '',
      args: [],
    );
  }

  /// `Cause`
  String get Cause {
    return Intl.message(
      'Cause',
      name: 'Cause',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get Description {
    return Intl.message(
      'Description',
      name: 'Description',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get ForgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'ForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get DontHaveAcc {
    return Intl.message(
      'Don\'t have an account?',
      name: 'DontHaveAcc',
      desc: '',
      args: [],
    );
  }

  /// `Sing up`
  String get SingUp {
    return Intl.message(
      'Sing up',
      name: 'SingUp',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get Add {
    return Intl.message(
      'Add',
      name: 'Add',
      desc: '',
      args: [],
    );
  }

  /// `telephone number`
  String get TelephoneNumber {
    return Intl.message(
      'telephone number',
      name: 'TelephoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `address`
  String get Address {
    return Intl.message(
      'address',
      name: 'Address',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get Gender {
    return Intl.message(
      'Gender',
      name: 'Gender',
      desc: '',
      args: [],
    );
  }

  /// `age`
  String get Age {
    return Intl.message(
      'age',
      name: 'Age',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get FName {
    return Intl.message(
      'First name',
      name: 'FName',
      desc: '',
      args: [],
    );
  }

  /// `Middle name`
  String get MName {
    return Intl.message(
      'Middle name',
      name: 'MName',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get LName {
    return Intl.message(
      'Last name',
      name: 'LName',
      desc: '',
      args: [],
    );
  }

  /// `Registraion`
  String get Registraion {
    return Intl.message(
      'Registraion',
      name: 'Registraion',
      desc: '',
      args: [],
    );
  }

  /// `MM.dd.yyyy`
  String get FormatOfDate {
    return Intl.message(
      'MM.dd.yyyy',
      name: 'FormatOfDate',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get Birthday {
    return Intl.message(
      'Birthday',
      name: 'Birthday',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get RepeatPassword {
    return Intl.message(
      'Repeat password',
      name: 'RepeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Field cannot be empty`
  String get FieldCannotBeEmpty {
    return Intl.message(
      'Field cannot be empty',
      name: 'FieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get PasswordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'PasswordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Input error`
  String get InputError {
    return Intl.message(
      'Input error',
      name: 'InputError',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain at least one uppercase letter.`
  String get ThePasswordMustContainAtLeastOneUppercaseLetter {
    return Intl.message(
      'The password must contain at least one uppercase letter.',
      name: 'ThePasswordMustContainAtLeastOneUppercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain at least one lowercase letter.`
  String get ThePasswordMustContainAtLeastOneLowercaseLetter {
    return Intl.message(
      'The password must contain at least one lowercase letter.',
      name: 'ThePasswordMustContainAtLeastOneLowercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain at least one digit.`
  String get ThePasswordMustContainAtLeastOneDigit {
    return Intl.message(
      'The password must contain at least one digit.',
      name: 'ThePasswordMustContainAtLeastOneDigit',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain at least one special character.`
  String get ThePasswordMustContainAtLeastOneSpecialCharacter {
    return Intl.message(
      'The password must contain at least one special character.',
      name: 'ThePasswordMustContainAtLeastOneSpecialCharacter',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain a minimum of 8 characters.`
  String get ThePasswordMustContainAMinimumOf8Characters {
    return Intl.message(
      'The password must contain a minimum of 8 characters.',
      name: 'ThePasswordMustContainAMinimumOf8Characters',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get LogIn {
    return Intl.message(
      'Log in',
      name: 'LogIn',
      desc: '',
      args: [],
    );
  }

  /// `There is no user with the entered login`
  String get ThereIsNoUserWithTheEnteredLogin {
    return Intl.message(
      'There is no user with the entered login',
      name: 'ThereIsNoUserWithTheEnteredLogin',
      desc: '',
      args: [],
    );
  }

  /// `The password entered is incorrect`
  String get ThePasswordEnteredIsIncorrect {
    return Intl.message(
      'The password entered is incorrect',
      name: 'ThePasswordEnteredIsIncorrect',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'uk', countryCode: 'UA'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
