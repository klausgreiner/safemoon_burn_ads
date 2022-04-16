import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safemoon_burn_ads/di/main_module.dart';
import 'package:safemoon_burn_ads/main_widget.dart';

void main() => startApp();

Future<void> startApp() async {
  await startFirebase();
  _systemSetup();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

void _systemSetup() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

Future startFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return MobileAds.instance.initialize();
}
