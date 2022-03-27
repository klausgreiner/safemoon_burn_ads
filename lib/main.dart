import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'src/app.dart';

void main() async {
  await _initGoogleMobileAds();
  runApp(MyApp());
}
//ca-app-pub-3158172826515652~1963185296
//Super burnca-app-pub-3158172826515652/1809489662

Future<InitializationStatus> _initGoogleMobileAds() {
  WidgetsFlutterBinding.ensureInitialized();
  return MobileAds.instance.initialize();
}
