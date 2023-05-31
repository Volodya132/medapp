import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionDataProviderKeys {
  static const _apiKey = 'api_key';
  static const _accountId = 'account_id';
}

class SessionDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<String?> apiKey() async {
    return (await _sharedPreferences)
        .getString(SessionDataProviderKeys._apiKey);
  }

  Future<void> saveApiKey(String key) async {
    (await _sharedPreferences).setString(SessionDataProviderKeys._apiKey, key);
  }

  Future<void> clearApiKey() async {
    (await _sharedPreferences).remove(SessionDataProviderKeys._apiKey);
  }


  Future<String?> getID() async {
    return (await _sharedPreferences)
        .getString(SessionDataProviderKeys._accountId);
  }

  Future<void> saveAccountID(String id) async {
    (await _sharedPreferences).setString(SessionDataProviderKeys._accountId, id);
  }

  Future<void> clearID() async {
    (await _sharedPreferences).remove(SessionDataProviderKeys._accountId);
  }


}