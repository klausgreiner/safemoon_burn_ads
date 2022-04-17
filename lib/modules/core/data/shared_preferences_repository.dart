import 'package:safemoon_burn_ads/modules/core/data/shared_preferences_core.dart';

abstract class SharedPreferencesRepository {
  Future setuserName(String data);

  Future<String?> getuserName();

  Future setPassword(String data);

  Future<String?> getPassword();

  Future setScore(int data);

  Future<int?> getScore();
}

class SharedPreferencesRepositoryImpl extends SharedPreferencesRepository {
  final SharedPreferencesCore _sharedPreferenceCore;

  SharedPreferencesRepositoryImpl(this._sharedPreferenceCore);

  static const String _password = "@password";
  static const String _userName = "@userName";
  static const String _score = "@score";

  @override
  Future setuserName(String data) =>
      _sharedPreferenceCore.setString(_userName, data);
  @override
  Future<String?> getuserName() => _sharedPreferenceCore.getString(_userName);
  @override
  Future setPassword(String data) =>
      _sharedPreferenceCore.setString(_password, data);
  @override
  Future<String?> getPassword() => _sharedPreferenceCore.getString(_password);
  @override
  Future setScore(int data) => _sharedPreferenceCore.setInt(_score, data);
  @override
  Future<int?> getScore() => _sharedPreferenceCore.getInt(_score);
}
