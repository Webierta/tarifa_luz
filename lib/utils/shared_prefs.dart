import 'package:shared_preferences/shared_preferences.dart';

import 'package:tarifa_luz/utils/constantes.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  static const String _token = tokenKey;
  static const String _autosave = autosaveKey;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get token => _sharedPrefs?.getString(_token) ?? '';

  set token(String value) => _sharedPrefs?.setString(_token, value);

  bool get autosave => _sharedPrefs?.getBool(_autosave) ?? true;

  set autosave(bool value) => _sharedPrefs?.setBool(_autosave, value);
}
