import 'package:shared_preferences/shared_preferences.dart';

///`LgConnectionSharedPref` to presist data in the app locally
/// A utility class for managing and persisting lg session data locally using `shared_preferences`.
class SettingsSharedPref {
  static SharedPreferences? _prefs;
  static const String _keyTheme = 'theme';
  static const String _keyLanguage = 'lang';
  static const String _keyTitleFont = 'titleFont';
  static const String _keyAccentTheme= 'accentTheme';

 

  /// Initializes the SharedPreferences instance for local data storage.
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  // Setters

  static Future<void> setTheme(String theme) async =>
      await _prefs?.setString(_keyTheme, theme);

  static Future<void> setAccentTheme(String accentTheme) async =>
      await _prefs?.setString(_keyAccentTheme, accentTheme);
  
  static Future<void> setLanguage(String lang) async =>
      await _prefs?.setString(_keyLanguage, lang);
  
  static Future<void> setTitleFont(double titleFont) async =>
      await _prefs?.setDouble(_keyTitleFont, titleFont);


///getters

  static String? getTheme() => _prefs?.getString(_keyTheme);
  static String? getLanguage() => _prefs?.getString(_keyLanguage);
  static double? getTitleFont() => _prefs?.getDouble(_keyTitleFont);

  static String? getAccentTheme() => _prefs?.getString(_keyAccentTheme);
  

  // Removers

  static Future<void> removeTheme() async => await _prefs?.remove(_keyTheme);
  static Future<void> removeLanguage() async => await _prefs?.remove(_keyLanguage);
  static Future<void> removeTitleFont() async => await _prefs?.remove(_keyTitleFont);
  static Future<void> removeAccentTheme() async => await _prefs?.remove(_keyAccentTheme);


}