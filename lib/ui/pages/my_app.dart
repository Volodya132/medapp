
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medapp/ui/helper/theme.dart';
import 'package:medapp/ui/pages/add_injury.dart';
import 'package:medapp/ui/pages/add_injurySnapshot.dart';
import 'package:medapp/ui/pages/auth_page.dart';
import 'package:medapp/ui/pages/doctor_account_page.dart';
import 'package:medapp/ui/pages/injureSnapshot_PaintMask_page.dart';
import 'package:medapp/ui/pages/patient_detail_page.dart';
import 'package:medapp/ui/pages/register_page.dart';
import 'package:realm/realm.dart';

import '../../generated/l10n.dart';

import 'package:medapp/ui/pages/patients_page.dart';
import 'package:medapp/ui/pages/loader_page.dart';

import 'add_patient.dart';
import 'add_photo_to_injurysnapshot.dart';
import 'change_password_page.dart';
import 'injuries_detail.dart';
import 'injurySnapshot_detail_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: kLightTheme,
      dark: kDarkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(

        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Flutter Demo',
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == '/auth') {
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  AuthWidget.create(),
              transitionDuration: Duration.zero,
            );
          } else if (settings.name == '/patients_page') {
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  PatientsPage.create(),
              transitionDuration: Duration.zero,
            );
          } else if (settings.name == '/loader') {
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  LoaderWidget.create(),
              transitionDuration: Duration.zero,
            );
          } else if (settings.name == '/auth/register') {
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  RegisterWidget.create(),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/addPatient') {
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  AddPatientWidget.create(),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/patientDetail') {
            final arguments = settings.arguments;
            final patientID = arguments is ObjectId ? arguments : 0;
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  PatientDetail.create(patientID),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/doctor_account') {
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  DoctorAccountWidget.create(context),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/doctor_account/changePassword') {
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  ChangePassword.create(),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/patientDetail/addInjury') {
            final arguments = settings.arguments;
            final patientID = arguments is ObjectId ? arguments : 0;
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  AddInjuryWidget.create(patientID),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/patientDetail/injuryDetail') {
            final arguments = settings.arguments;
            final injuryID = arguments is ObjectId ? arguments : 0;
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  InjuryDetail.create(injuryID),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/patientDetail/injuryDetail/addInjurySnapshot') {
            final arguments = settings.arguments;
            final injuryID = arguments is ObjectId ? arguments : 0;
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  AddInjurySnapshotWidget.create(injuryID),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/patientDetail/injuryDetail/injurySnapshotDetail') {
            print( settings.arguments);
            final arguments = settings.arguments as List;
            var snapshotID = arguments[0];
            var injuryID = arguments[1];
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  InjurySnapshotDetailPage.create(snapshotID, injuryID),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/patientDetail/injuryDetail/injurySnapshotDetail/addPhoto') {
            print( settings.arguments);
            final arguments = settings.arguments as List;
            var snapshotID = arguments[0];
            var injuryID = arguments[1];
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  InjurySnapshotDetailAddPhotosPage.create(snapshotID, injuryID),
              transitionDuration: Duration.zero,
            );
          }
          else if (settings.name == '/patients_page/patientDetail/injuryDetail/injurySnapshotDetail/injurySnapshotPaintMask') {
            final arguments = settings.arguments;
            final injurySnapshotPhoto = arguments is String ? arguments : "";
            return PageRouteBuilder<dynamic>(
              pageBuilder: (context, animation1, animation2) =>
                  InjurySnapshotPaintMaskPage.create(injurySnapshotPhoto),
              transitionDuration: Duration.zero,
            );
          }
        },

        home: LoaderWidget.create(),
      ),
    );
  }
}

