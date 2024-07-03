import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Hijau muda
// conts Color.fromARGB(255, 245, 250, 225),

// Hijau Tua
// const Color.fromARGB(255, 48, 85, 77),

// Coklat muda
// Color.fromARGB(255, 174, 144, 108),

// Coklat tua
// Color.fromARGB(255, 113, 63, 53),

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 48, 85, 77),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 48, 85, 77),
      elevation: 0,
      iconTheme: IconThemeData(color: Color.fromARGB(255, 245, 250, 225)),
      titleTextStyle:
          TextStyle(color: Color.fromARGB(255, 245, 250, 225), fontSize: 32.0)),
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 245, 250, 225),
    primary: Color.fromARGB(255, 48, 85, 77),
    onPrimary: Color.fromARGB(255, 245, 250, 225),
    secondary: Color.fromARGB(255, 245, 250, 225),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 113, 63, 53),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 113, 63, 53),
      elevation: 0,
      iconTheme: IconThemeData(color: Color.fromARGB(255, 245, 250, 225)),
      titleTextStyle:
          TextStyle(color: Color.fromARGB(255, 245, 250, 225), fontSize: 32.0)),
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(255, 245, 250, 225),
    primary: Color.fromARGB(255, 113, 63, 53),
    onPrimary: Color.fromARGB(255, 245, 250, 225),
    secondary: Color.fromARGB(255, 245, 250, 225),
  ),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _preferences;
  bool? _darkMode;

  bool? get darkMode => _darkMode;

  ThemeNotifier() {
    _darkMode = false;
    _loadFromPreferences();
  }

  _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _savePreferences() async {
    await _initialPreferences();
    _preferences!.setBool(key, _darkMode!);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    _darkMode = _preferences!.getBool(key) ?? true;
    notifyListeners();
  }

  toggleChangeTheme(bool isOn) {
    darkMode == isOn ? _darkMode! : _darkMode = !_darkMode!;
    _savePreferences();
    notifyListeners();
  }
}
