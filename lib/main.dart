import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medapp/domain/entity/doctor.dart';
import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/ui/pages/my_app.dart';
import 'package:realm/realm.dart';

import 'domain/entity/injury.dart';
import 'domain/entity/injurySnapshot.dart';
import 'domain/entity/patient.dart';
import 'firebase_options.dart';

final String appId = "application-0-ftetu";
final Uri baseUrl = Uri.parse("https://realm.mongodb.com");


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RealmService.openRealm([Doctor.schema, Patient.schema, Injury.schema, InjurySnapshot.schema]);
  runApp(const MyApp());
}
