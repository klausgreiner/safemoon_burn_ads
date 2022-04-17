import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesCore {
  Future setString(String key, String data);

  Future<String?> getString(String key);

  Future setObject(String key, dynamic data);

  Future<dynamic> getObject(String key);

  Future setBool(String key, bool value);

  Future<bool?> getBool(String key);

  Future setInt(String key, int value);

  Future<int?> getInt(String key);
}

class SharedPreferencesCoreImpl implements SharedPreferencesCore {
  @override
  Future setString(String key, String data) => SharedPreferences.getInstance()
      .then((preference) => preference.setString(key, data));

  @override
  Future<String?> getString(String key) => SharedPreferences.getInstance()
      .then((preference) => preference.getString(key));

  @override
  Future setObject(String key, dynamic data) => SharedPreferences.getInstance()
      .then((preference) => preference.setString(key, json.encode(data)));

  @override
  Future<dynamic> getObject(String key) =>
      SharedPreferences.getInstance().then((preference) {
        String? data = preference.getString(key);
        if (data != null) {
          return json.decode(data);
        }
        return null;
      });

  @override
  Future setBool(String key, bool value) => SharedPreferences.getInstance()
      .then((preference) => preference.setBool(key, value));

  @override
  Future<bool?> getBool(String key) => SharedPreferences.getInstance()
      .then((preference) => preference.getBool(key));

  @override
  Future setInt(String key, int value) => SharedPreferences.getInstance()
      .then((preference) => preference.setInt(key, value));

  @override
  Future<int?> getInt(String key) => SharedPreferences.getInstance()
      .then((preference) => preference.getInt(key));
}
