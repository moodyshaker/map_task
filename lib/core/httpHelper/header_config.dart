import '../appStorage/shared_preference.dart';

class HeaderConfig {
  static Future<Map<String, String>> getHeader() async {
    var header = {
      'Accept-Language': 'ar',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    return header;
  }

  static Future<Map<String, String>> getHeaderWithToken() async {
    var header = {
      'Accept-Language': 'ar',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "usertoken": '${Preferences.instance.getUserToken}'
    };
    return header;
  }
}
