import 'package:shared_preferences/shared_preferences.dart';

///`LgConnectionSharedPref` to presist data in the app locally
/// A utility class for managing and persisting lg session data locally using `shared_preferences`.
class LgConnectionSharedPref {
  static SharedPreferences? _prefs;
  static const String _keyIP = 'ip';
  static const String _keyPort = 'port';
  static const String _keyUserName = 'userName';
  static const String _keyPassword = 'pass';
  static const String _keyScreenAmount = 'screenAmount';

  /// Initializes the SharedPreferences instance for local data storage.
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  // Setters

  /// Sets the IP address for the lg session.
  static Future<void> setIP(String ip) async =>
      await _prefs?.setString(_keyIP, ip);

  /// Sets the port number for the lg session.
  static Future<void> setPort(String port) async =>
      await _prefs?.setString(_keyPort, port);

  /// Sets the username for the lg session.
  static Future<void> setUserName(String userName) async =>
      await _prefs?.setString(_keyUserName, userName);

  /// Sets the password for the lg session.
  static Future<void> setPassword(String pass) async =>
      await _prefs?.setString(_keyPassword, pass);

  /// Sets the screen amount for the lg session.
  static Future<void> setScreenAmount(int screenAmount) async =>
      await _prefs?.setInt(_keyScreenAmount, screenAmount);

  // Getters

  /// Retrieves the saved IP address from the lg session.
  static String? getIP() => _prefs?.getString(_keyIP);

  /// Retrieves the saved port number from the lg session.
  static String? getPort() => _prefs?.getString(_keyPort);

  /// Retrieves the saved username from the lg session.
  static String? getUserName() => _prefs?.getString(_keyUserName);

  /// Retrieves the saved password from the lg session.
  static String? getPassword() => _prefs?.getString(_keyPassword);

  /// Retrieves the saved screen amount from the lg session.
  static int? getScreenAmount() => _prefs?.getInt(_keyScreenAmount);

  // Removers

  /// Removes the saved IP address from the lg session.
  static Future<void> removeIP() async => await _prefs?.remove(_keyIP);

  /// Removes the saved port number from the lg session.
  static Future<void> removePort() async => await _prefs?.remove(_keyPort);

  /// Removes the saved username from the lg session.
  static Future<void> removeUserName() async =>
      await _prefs?.remove(_keyUserName);

  /// Removes the saved password from the lg session.
  static Future<void> removePassword() async =>
      await _prefs?.remove(_keyPassword);

  /// Removes the saved screen amount from the lg session.
  static Future<void> removeScreenAmount() async =>
      await _prefs?.remove(_keyScreenAmount);
}