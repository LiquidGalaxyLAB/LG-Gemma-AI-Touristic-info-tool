import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/lg_connection_shared_pref.dart';
import '../models/ssh_model.dart';
import 'connection_provider.dart';

///This is a [Provider] class of [SSHprovider] that extends [ChangeNotifier]

///They all have setters and getters
///We have [saveData] method to save data into the form using [SSHModel]
/// [init] is the function that sets the client with its data when connected
/// [execute] is used to execute a specefic command when connecting with the client
/// [uploadKml] is used to upload a file as kml
///  [disconnect] is used for disconnecting the client
/// [reconnectClient] for connecting the client again in case the connection is lost while app is running

class SSHprovider extends ChangeNotifier {
  String? _host = LgConnectionSharedPref.getIP();

  /// Property that defines the SSH port. Default is 22
  int? _port = int.parse(LgConnectionSharedPref.getPort() ?? '22');

  /// Property that defines the SSH machine username.
  String? _username = LgConnectionSharedPref.getUserName();

  /// Property that defines the SSH machine password or RSA private key.
  String? _passwordOrKey = LgConnectionSharedPref.getPassword();

  /// Property that defines the number of LG screens
  int? _numberOfScreens = LgConnectionSharedPref.getScreenAmount() ?? 3;

  /// Property that defines the SSH client
  SSHClient? _client;

  /// reconnects with the client again every 30 seconds while the app is running with given `ssh` info
  Future<String?> reconnectClient(SSHModel ssh, BuildContext context) async {
    String result = '';

    try {
      final socket = await SSHSocket.connect(ssh.host, ssh.port,
          timeout: const Duration(seconds: 36000000));
      String? password;
      bool isAuthenticated = false;

      _client = SSHClient(
        socket,
        onPasswordRequest: () {
          password = ssh.passwordOrKey;

          return password;
        },
        username: ssh.username,
        onAuthenticated: () {
          isAuthenticated = true;
        },
        keepAliveInterval: const Duration(seconds: 36000000),
      );

      /// Add a delay before checking isAuthenticated
      await Future.delayed(const Duration(seconds: 10));

      if (isAuthenticated) {
      } else {
        // If the client is not authenticated, indicate a failed connection
        throw Exception('SSH authentication failed');
      }
    } catch (e) {
      result = "Failed to connect to the SSH server: $e";
    }

    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    if (result == '') {
      connection.isLgConnected = true;
    } else {
      connection.isLgConnected = false;
    }

    return result;
  }

  /// Sets a client with the given [ssh] info.
  Future<String?> setClient(SSHModel ssh) async {
    String result = '';

    try {
      final socket = await SSHSocket.connect(ssh.host, ssh.port,
          timeout: const Duration(seconds: 36000000));
      String? password;
      bool isAuthenticated = false;

      _client = SSHClient(
        socket,
        onPasswordRequest: () {
          password = ssh.passwordOrKey;

          return password;
        },
        username: ssh.username,
        onAuthenticated: () {
          isAuthenticated = true;
        },
        keepAliveInterval: const Duration(seconds: 36000000),
      );

      /// Add a delay before checking isAuthenticated
      await Future.delayed(const Duration(seconds: 10));

      if (isAuthenticated) {
      } else {
        // If the client is not authenticated, indicate a failed connection
        throw Exception('SSH authentication failed');
      }
    } catch (e) {
      result = "Failed to connect to the SSH server: $e";
    }
    return result;
  }

  set host(String? value) {
    _host = value;
    notifyListeners();
  }

  set port(int? value) {
    _port = value;
    notifyListeners();
  }

  set numberOfScreens(int? value) {
    _numberOfScreens = value;
    notifyListeners();
  }

  set username(String? value) {
    _username = value;
    notifyListeners();
  }

  set passwordOrKey(String? value) {
    _passwordOrKey = value;
    notifyListeners();
  }

  String? get passwordOrKey => _passwordOrKey;
  String? get username => _username;
  String? get host => _host;
  int? get port => _port;
  int? get numberOfScreens => _numberOfScreens;

  /// Property that gets the SSH client instance.
  SSHClient? get client => _client;

  final SSHModel _sshData = SSHModel();
  SSHModel get sshData => _sshData;

  void saveData(String host, String username, String passwordOrKey, int port,
      int screenAmount) {
    _sshData.host = host;
    _sshData.passwordOrKey = passwordOrKey;
    _sshData.username = username;
    _sshData.port = port;
    _sshData.screenAmount = screenAmount;

    notifyListeners();
  }

  Future<String?> init(BuildContext context) async {
    String? result = await setClient(SSHModel(
      username: LgConnectionSharedPref.getUserName() ?? '',
      host: LgConnectionSharedPref.getIP() ?? '',
      passwordOrKey: LgConnectionSharedPref.getPassword() ?? '',
      port: int.parse(LgConnectionSharedPref.getPort() ?? '22'),
    ));
    _username = LgConnectionSharedPref.getUserName() ?? '';
    _host = LgConnectionSharedPref.getIP() ?? '';
    _passwordOrKey = LgConnectionSharedPref.getPassword() ?? '';
    _port = int.parse(LgConnectionSharedPref.getPort() ?? '22');
    _numberOfScreens = LgConnectionSharedPref.getScreenAmount() ?? 3;

    notifyListeners();
    return result;
  }

  /// Connects to the current client, executes a command into it and then disconnects.
  Future<SSHSession> execute(String command) async {
    SSHSession execResult;

    execResult = await _client!.execute(command);

    notifyListeners();
    return execResult;
  }

  /// Disconnects from the a machine using the current client.
  Future<SSHClient> disconnect() async {
    _client!.close();
    return _client!;
  }

  /// Connects to the current client through SFTP, uploads a file into it and then disconnects.
  /// uploading kml file
  uploadKml(File inputFile, String filename) async {
    final sftp = await _client?.sftp();
    double anyKindofProgressBar;
    final file = await sftp?.open('/var/www/html/$filename',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);
    var fileSize = await inputFile.length();
    await file?.write(inputFile.openRead().cast(), onProgress: (progress) {
      anyKindofProgressBar = progress / fileSize;
    });
  }
}
