import 'package:shared_preferences/shared_preferences.dart';

class TokenData {
  static const String AM_AC_TOKEN = "token";
  static saveAccessToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(AM_AC_TOKEN, token);
  }

  // 获取AccessToken
  static Future<String?> getAccessToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(AM_AC_TOKEN);
  }
}
