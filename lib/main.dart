import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'src/app.dart';

void main() async {
  _initGoogleMobileAds();
  runApp(MyApp());
}

Future<InitializationStatus> _initGoogleMobileAds() {
  WidgetsFlutterBinding.ensureInitialized();
  return MobileAds.instance.initialize();
}
