import 'package:shared_preferences/shared_preferences.dart';

///`LgConnectionSharedPref` to presist data in the app locally
/// A utility class for managing and persisting lg session data locally using `shared_preferences`.
class SettingsSharedPref {
  static SharedPreferences? _prefs;
  static const String _keyTheme = 'theme';
  static const String _keyLanguage = 'lang';
  static const String _keyTitleFont = 'titleFont';
  static const String _keyHeadingFont = 'headingFont';
  static const String _keyTextFont = 'textFont';

 

  /// Initializes the SharedPreferences instance for local data storage.
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  // Setters

  static Future<void> setTheme(String theme) async =>
      await _prefs?.setString(_keyTheme, theme);
  
  static Future<void> setLanguage(String lang) async =>
      await _prefs?.setString(_keyLanguage, lang);
  
  static Future<void> setTitleFont(double titleFont) async =>
      await _prefs?.setDouble(_keyTitleFont, titleFont);

  static Future<void> setHeadingFont(double headingFont) async =>
      await _prefs?.setDouble(_keyHeadingFont, headingFont);
    
  static Future<void> setTextFont(double textFont) async =>
      await _prefs?.setDouble(_keyTextFont, textFont);


///getters

  static String? getTheme() => _prefs?.getString(_keyTheme);
  static String? getLanguage() => _prefs?.getString(_keyLanguage);
  static double? getTitleFont() => _prefs?.getDouble(_keyTitleFont);
  static double? getHeadingFont() => _prefs?.getDouble(_keyHeadingFont);
  static double? getTextFont() => _prefs?.getDouble(_keyTextFont);

  

  // Removers

  static Future<void> removeTheme() async => await _prefs?.remove(_keyTheme);
  static Future<void> removeLanguage() async => await _prefs?.remove(_keyLanguage);
  static Future<void> removeTitleFont() async => await _prefs?.remove(_keyTitleFont);
  static Future<void> removeHeadingFont() async => await _prefs?.remove(_keyHeadingFont);
  static Future<void> removeTextFont() async => await _prefs?.remove(_keyTextFont);


}
