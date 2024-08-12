import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

///`LgConnectionSharedPref` to presist data in the app locally
/// A utility class for managing and persisting lg session data locally using `shared_preferences`.
class SettingsSharedPref {
  static SharedPreferences? _prefs;
  static const String _keyTheme = 'theme';
  // static const String _keyLanguage = 'lang';
   static const String _localeKey = 'locale';
  static const String _keyTitleFont = 'titleFont';
  static const String _keyAccentTheme = 'accentTheme';

  /// Initializes the SharedPreferences instance for local data storage.
  // static Future init() async => _prefs = await SharedPreferences.getInstance();
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();

    // Set default values if they are not set
    if (_prefs?.getString(_keyTheme) == null) {
      await setTheme('default');
    }
    // if (_prefs?.getString(_keyLanguage) == null) {
    //   await setLanguage(_defaultLanguage);
    // }
    if (_prefs?.getDouble(_keyTitleFont) == null) {
      await setTitleFont(40);
    }
    if (_prefs?.getString(_keyAccentTheme) == null) {
      await setAccentTheme('556EA5');
    }
  }

  // Setters

  static Future<void> setTheme(String theme) async =>
      await _prefs?.setString(_keyTheme, theme);

  static Future<void> setAccentTheme(String accentTheme) async =>
      await _prefs?.setString(_keyAccentTheme, accentTheme);

  static Future<void> setLocale(Locale locale) async =>
       await _prefs?.setString(_localeKey, locale.languageCode);

  static Future<void> setTitleFont(double titleFont) async =>
      await _prefs?.setDouble(_keyTitleFont, titleFont);

  ///getters

  static String? getTheme() => _prefs?.getString(_keyTheme);
  static double? getTitleFont() => _prefs?.getDouble(_keyTitleFont);

  static String? getAccentTheme() => _prefs?.getString(_keyAccentTheme);

  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? localeCode = prefs.getString(_localeKey);
    if (localeCode == null) {
      // Default to English if no locale is set
      return const Locale('en');
    }
    return Locale(localeCode);
  }


  // Removers

  static Future<void> removeTheme() async => await _prefs?.remove(_keyTheme);
  static Future<void> removeTitleFont() async =>
      await _prefs?.remove(_keyTitleFont);
  static Future<void> removeAccentTheme() async =>
      await _prefs?.remove(_keyAccentTheme);
   static Future<void> clearLocale() async =>
    await _prefs?.remove(_localeKey);
  
}
