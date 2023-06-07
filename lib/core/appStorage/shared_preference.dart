import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  SharedPreferences? _preferences;
  static final Preferences instance = Preferences._instance();
  static const String fcmToken = 'task_fcmToken';
  static const String id = 'task_id';
  static const String name = 'task_name';
  static const String phone = 'task_phone';
  static const String token = 'task_token';

  Preferences._instance();

  Future<SharedPreferences?> initPref() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences;
  }

  Future<bool> setFcmToken(String? value) async {
    bool isSet = await _preferences!.setString(fcmToken, value!);
    return isSet;
  }

  Future<bool> setUserName(String value) async {
    bool isSet = await _preferences!.setString(name, value);
    return isSet;
  }

  Future<bool> setUserId(String value) async {
    bool isSet = await _preferences!.setString(id, value);
    return isSet;
  }

  Future<bool> setUserPhone(String value) async {
    bool isSet = await _preferences!.setString(phone, value);
    return isSet;
  }

  Future<bool> setUserToken(String value) async {
    bool isSet = await _preferences!.setString(token, value);
    return isSet;
  }

  Future<bool> logout() async {
    bool isSet = await _preferences!.clear();
    return isSet;
  }

  String get getFcmToken => _preferences!.getString(fcmToken) ?? '';

  String get getUserId => _preferences!.getString(id) ?? '';

  String get getUserName => _preferences!.getString(name) ?? '';

  String get getUserPhone => _preferences!.getString(phone) ?? '';

  String get getUserToken => _preferences!.getString(token) ?? '';
}
