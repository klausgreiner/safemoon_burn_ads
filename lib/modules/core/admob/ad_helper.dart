import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      //  return 'ca-app-pub-3940256099942544/6300978111'; //HOMOL
      return 'ca-app-pub-3158172826515652/7383032936'; //prod
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3158172826515652/4503881860';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      //return "ca-app-pub-3940256099942544/5354046379"; //homol
      return 'ca-app-pub-3158172826515652/6862277851'; //prod

    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3158172826515652/1809489662";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3158172826515652/4562757467";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
