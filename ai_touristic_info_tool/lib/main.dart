import 'dart:async';

import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/screens/splash_screen.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/current_view_provider.dart';
import 'package:ai_touristic_info_tool/state_management/displayed_fav_provider.dart';
import 'package:ai_touristic_info_tool/state_management/drop_down_state.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/map_type_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:showcaseview/showcaseview.dart';
import 'helpers/lg_connection_shared_pref.dart';
import 'models/ssh_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize shared preferences for LG connection
  await LgConnectionSharedPref.init();

  await PromptsSharedPref.init();

  await SettingsSharedPref.init();

  await FavoritesSharedPref.init();

  await APIKeySharedPref.init();

  Locale locale = await SettingsSharedPref.getLocale();

  //clear:
  // await FavoritesSharedPref().clearToursList();
  // await PromptsSharedPref.clearPreferences();

  await dotenv.load(fileName: ".env");

  FeaturesTour.setGlobalConfig(
    skipConfig: SkipConfig(
      text: 'Skip',
      textStyle: TextStyle(fontSize: 25, color: Colors.white),
      buttonStyle: TextButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.9),
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 13),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(300),
              side:
                  BorderSide(color: Colors.black.withOpacity(0.2), width: 1))),
    ),
    nextConfig: NextConfig(
      text: 'Next',
      textStyle: TextStyle(fontSize: 25, color: Colors.white),
      buttonStyle: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 13),
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(300),
              side:
                  BorderSide(color: Colors.black.withOpacity(0.2), width: 1))),
    ),
    predialogConfig: PredialogConfig(
      enabled: false,
    ),
    debugLog: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Connectionprovider()),
        ChangeNotifierProvider(create: (_) => SSHprovider()),
        ChangeNotifierProvider(create: (_) => CurrentViewProvider()),
        ChangeNotifierProvider(create: (_) => MapTypeProvider()),
        ChangeNotifierProvider(create: (_) => ModelErrorProvider()),
        ChangeNotifierProvider(create: (_) => GoogleMapProvider()),
        ChangeNotifierProvider(create: (_) => DropdownState()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ColorProvider()),
        ChangeNotifierProvider(create: (_) => FontsProvider()),
        ChangeNotifierProvider(create: (_) => DisplayedListProvider()),
      ],
      child: Phoenix(child: AITouristicInfo(locale: locale)),
      // child: ShowCaseWidget(
      //   builder: (context) => const AITouristicInfo(),
      // ),
    ),
  );
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    final sshData =
        Provider.of<SSHprovider>(navigatorKey.currentContext!, listen: false);
    Connectionprovider connection = Provider.of<Connectionprovider>(
        navigatorKey.currentContext!,
        listen: false);

    String? result = await sshData.reconnectClient(
        SSHModel(
          username: LgConnectionSharedPref.getUserName() ?? '',
          host: LgConnectionSharedPref.getIP() ?? '',
          passwordOrKey: LgConnectionSharedPref.getPassword() ?? '',
          port: int.parse(LgConnectionSharedPref.getPort() ?? '22'),
        ),
        navigatorKey.currentContext!);
    if (result == '') {
      connection.isLgConnected = true;
    } else {
      connection.isLgConnected = false;
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AITouristicInfo extends StatelessWidget {
  final Locale locale;
  const AITouristicInfo({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    LgService(sshData).setLogos();
    buildAppBalloonOverlay(context);

    return MaterialApp(
      title: 'AI Touristic Info Tool',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
