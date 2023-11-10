import 'package:shared_preferences/shared_preferences.dart';

import 'package:tarifa_luz/utils/constantes.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  static const String _token = keyToken;
  static const String _autoGetData = keyAutoGetData;
  static const String _autoSave = keyAutoSave;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get token => _sharedPrefs?.getString(_token) ?? '';
  set token(String value) => _sharedPrefs?.setString(_token, value);

  bool get autoGetData => _sharedPrefs?.getBool(_autoGetData) ?? true;
  set autoGetData(bool value) => _sharedPrefs?.setBool(_autoGetData, value);

  bool get autoSave => _sharedPrefs?.getBool(_autoSave) ?? true;
  set autoSave(bool value) => _sharedPrefs?.setBool(_autoSave, value);
}
