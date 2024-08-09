import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/main_layout.dart';
import 'package:flutter/material.dart';

///This is a splash screen for displaying the logos and the name of the app for 3 seconds, then navigate to home page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const MainLayout()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SettingsSharedPref.getTheme() == 'dark'
            ? Colors.black
            : Colors.white,
        body: Center(
            child: SettingsSharedPref.getTheme() == 'dark'
                ? 
                //Local
                // Image.asset('assets/images/dark-logos-gemma.jpg')
                //Gemini
                Image.asset('assets/images/dark-logos-gemini.jpg')
                : 
                //Local
                // Image.asset('assets/images/Logos_Screen-gemma.jpg')
                //Gemini
                 Image.asset('assets/images/Logos_Screen-gemini.jpg')
                ));
  }
}
