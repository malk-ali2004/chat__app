import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required String value,
  }) async {
    return await _sharedPreferences!.setString(key, value);
  }

  static Future<bool> saveIntData({
    required String key,
    required int value,
  }) async {
    return await _sharedPreferences!.setInt(key, value);
  }

  static Future<bool> saveBoolData({
    required String key,
    required bool value,
  }) async {
    return await _sharedPreferences!.setBool(key, value);
  }

  static Future<bool> saveDoubleData({
    required String key,
    required double value,
  }) async {
    return await _sharedPreferences!.setDouble(key, value);
  }

  static String? getData({required String key}) {
    return _sharedPreferences!.getString(key);
  }

  static int? getIntData({required String key}) {
    return _sharedPreferences!.getInt(key);
  }

  static bool? getBoolData({required String key}) {
    return _sharedPreferences!.getBool(key);
  }

  static double? getDoubleData({required String key}) {
    return _sharedPreferences!.getDouble(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences!.remove(key);
  }

  static Future<bool> clearData() async {
    return await _sharedPreferences!.clear();
  }
}
