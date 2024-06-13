import 'dart:async';

import 'package:ai_touristic_info_tool/reusable_widgets/main_layout.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/current_view_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'helpers/lg_connection_shared_pref.dart';
import 'models/ssh_model.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  /// Initialize shared preferences for LG connection
  await LgConnectionSharedPref.init();
  await dotenv.load(fileName: ".env");
  
  runApp(  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Connectionprovider()),
        ChangeNotifierProvider(create: (_) => SSHprovider()),
        ChangeNotifierProvider(create: (_) => CurrentViewProvider()),
      ],
      child: const AITouristicInfo(),
    ),);
  //   Timer.periodic(const Duration(seconds: 30), (timer) async {
  //   final sshData =
  //       Provider.of<SSHprovider>(navigatorKey.currentContext!, listen: false);
  //   Connectionprovider connection = Provider.of<Connectionprovider>(
  //       navigatorKey.currentContext!,
  //       listen: false);

  //   String? result = await sshData.reconnectClient(
  //       SSHModel(
  //         username: LgConnectionSharedPref.getUserName() ?? '',
  //         host: LgConnectionSharedPref.getIP() ?? '',
  //         passwordOrKey: LgConnectionSharedPref.getPassword() ?? '',
  //         port: int.parse(LgConnectionSharedPref.getPort() ?? '22'),
  //       ),
  //       navigatorKey.currentContext!);
  //   if (result == '') {
    
  //     connection.isConnected = true;
  //   } else {
  //     connection.isConnected = false;
  //   }
  // });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AITouristicInfo extends StatelessWidget {
  const AITouristicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Touristic Info Tool',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainLayout() ,
    );
  }
}
