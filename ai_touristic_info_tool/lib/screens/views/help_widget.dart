import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/help_button.dart';
import 'package:ai_touristic_info_tool/state_management/current_view_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HelpWidget extends StatefulWidget {
  const HelpWidget({super.key});

  @override
  State<HelpWidget> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  List<TargetFocus> appTargets = [];
  List<TargetFocus> lgConnectTargets = [];
  List<TargetFocus> lgControlTargets = [];
  List<TargetFocus> favsTargets = [];
  List<TargetFocus> appSettingsTargets = [];
  bool _isInitialized = false;

//init:
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      appTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyHome,
          keyTarget: GlobalKeys.showcaseKeyHome,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.right,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Navigate to your home page",
                        AppLocalizations.of(context)!.tutorialApp_title1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                        // "It is where you can type your prompt and generate AI recommendations worldwide or nearby your location",
                        AppLocalizations.of(context)!.tutorialApp_desc1,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionManager,
          keyTarget: GlobalKeys.showcaseKeyConnectionManager,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.right,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Connect to the Liquid Galaxy System",
                        AppLocalizations.of(context)!.tutorialApp_title2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                        // "To experience a multi-screen panoramic view of the world",
                        AppLocalizations.of(context)!.tutorialApp_desc2,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyLGTasks,
          keyTarget: GlobalKeys.showcaseKeyLGTasks,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.right,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Control the Liquid Galaxy",
                        AppLocalizations.of(context)!.tutorialApp_title3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                        // "Shutdown, restart, relaunch your LG and much more!",
                        AppLocalizations.of(context)!.tutorialApp_desc3,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyFavs,
          keyTarget: GlobalKeys.showcaseKeyFavs,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.right,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "View all your saved tours and places!",
                        AppLocalizations.of(context)!.tutorialApp_title4,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                        // "You can also make your own custom tour!",
                        AppLocalizations.of(context)!.tutorialApp_desc4,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeySettings,
          keyTarget: GlobalKeys.showcaseKeySettings,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.right,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "All your App settings in one place",
                        AppLocalizations.of(context)!.tutorialApp_title5,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                        // "For a more personalized experience!",
                        AppLocalizations.of(context)!.tutorialApp_desc5,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyAbout,
          keyTarget: GlobalKeys.showcaseKeyAbout,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.right,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Learn more about the app!",
                        AppLocalizations.of(context)!.tutorialApp_title6,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));

      //2. LG Connection:
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionManager,
          keyTarget: GlobalKeys.showcaseKeyConnectionManager,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Navigate to LG Connection Manager",
                        AppLocalizations.of(context)!.tutorialLGConnect_title1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionUsername,
          keyTarget: GlobalKeys.showcaseKeyConnectionUsername,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Enter your LG username",
                        AppLocalizations.of(context)!.tutorialLGConnect_title2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionPassword,
          keyTarget: GlobalKeys.showcaseKeyConnectionPassword,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Enter your LG password",
                        AppLocalizations.of(context)!.tutorialLGConnect_title3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionIP,
          keyTarget: GlobalKeys.showcaseKeyConnectionIP,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Enter your LG Master IP address",
                        AppLocalizations.of(context)!.tutorialLGConnect_title4,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                          // "It usually starts with 192.xxx.xxx.x",
                          AppLocalizations.of(context)!.tutorialLGConnect_desc4,
                          style: TextStyle(color: Colors.white, fontSize: 30.0))
                    ],
                  ),
                ))
          ]));
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionPort,
          keyTarget: GlobalKeys.showcaseKeyConnectionPort,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Enter your LG Port Number",
                        AppLocalizations.of(context)!.tutorialLGConnect_title5,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                          //"It is usually 22",
                          AppLocalizations.of(context)!.tutorialLGConnect_desc5,
                          style: TextStyle(color: Colors.white, fontSize: 30.0))
                    ],
                  ),
                ))
          ]));
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionNumScreens,
          keyTarget: GlobalKeys.showcaseKeyConnectionNumScreens,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Enter the number of LG Screens in your Rig",
                        AppLocalizations.of(context)!.tutorialLGConnect_title6,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyConnectionConnect,
          keyTarget: GlobalKeys.showcaseKeyConnectionConnect,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Click here to connect after you fill your data!",
                        AppLocalizations.of(context)!.tutorialLGConnect_title7,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgConnectTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyLGconnectionIndicator,
          keyTarget: GlobalKeys.showcaseKeyLGconnectionIndicator,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Check your LG connection status from here",
                        AppLocalizations.of(context)!.tutorialLGConnect_title8,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));

      //3. Tasks:
      lgControlTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyLGTasks,
          keyTarget: GlobalKeys.showcaseKeyLGTasks,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Navigate to LG Tasks",
                        AppLocalizations.of(context)!.tutorialTasls_titl1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgControlTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyTasksRelaunch,
          keyTarget: GlobalKeys.showcaseKeyTasksRelaunch,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Click here to relaunch your LG",
                        AppLocalizations.of(context)!.tutorialTasls_title2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgControlTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyTasksReboot,
          keyTarget: GlobalKeys.showcaseKeyTasksReboot,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Click here to reboot your LG",
                        AppLocalizations.of(context)!.tutorialTasls_title3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgControlTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyTasksShutDown,
          keyTarget: GlobalKeys.showcaseKeyTasksShutDown,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Click here to shutdown your LG",
                        AppLocalizations.of(context)!.tutorialTasls_title4,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgControlTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyTasksShowLogos,
          keyTarget: GlobalKeys.showcaseKeyTasksShowLogos,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Click here to show the app logos on LG left most screen",
                        AppLocalizations.of(context)!.tutorialTasls_title5,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgControlTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyTasksHideLogos,
          keyTarget: GlobalKeys.showcaseKeyTasksHideLogos,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Click here to hide the app logos from LG left most screen",
                        AppLocalizations.of(context)!.tutorialTasls_title6,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      lgControlTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyTasksCleanKmls,
          keyTarget: GlobalKeys.showcaseKeyTasksCleanKmls,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Click here to clean all KMLs on LG Rig",
                        AppLocalizations.of(context)!.tutorialTasls_title7,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      //4. favs:
      favsTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyFavs,
          keyTarget: GlobalKeys.showcaseKeyFavs,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.right,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Navigate to your Favorites",
                        AppLocalizations.of(context)!.tutorialFavs_navigate,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      favsTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeySavedTours,
          keyTarget: GlobalKeys.showcaseKeySavedTours,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Your saved tours from previous visualizations",
                        AppLocalizations.of(context)!.tutorialFavs_titl1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                        // "You can find tours generated by AI or customized by you.",
                        AppLocalizations.of(context)!.tutorialFavs_desc1,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      )
                    ],
                  ),
                ))
          ]));
      favsTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeySavedPlaces,
          keyTarget: GlobalKeys.showcaseKeySavedPlaces,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Your Saved Places in one place!",
                        AppLocalizations.of(context)!.tutorialFavs_title2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                        // "You can customize your own tour from your saved places.",
                        AppLocalizations.of(context)!.tutorialFavs_desc2,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      )
                    ],
                  ),
                ))
          ]));
      //5. Settings:
      appSettingsTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyLanguages,
          keyTarget: GlobalKeys.showcaseKeyLanguages,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Change the app language from here",
                        AppLocalizations.of(context)!.tutorialSettings_title1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appSettingsTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyAppearance,
          keyTarget: GlobalKeys.showcaseKeyAppearance,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Change the app appearance from here",
                        AppLocalizations.of(context)!.tutorialSettings_title2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appSettingsTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyFontSize,
          keyTarget: GlobalKeys.showcaseKeyFontSize,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Change the app font size from here",
                        AppLocalizations.of(context)!.tutorialSettings_title3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                ))
          ]));
      appSettingsTargets.add(TargetFocus(
          identify: GlobalKeys.showcaseKeyAPIKeys,
          keyTarget: GlobalKeys.showcaseKeyAPIKeys,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // "Manage your API keys from here",
                        AppLocalizations.of(context)!.tutorialSettings_title4,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Text(
                          // "You can add, edit or delete your API keys of different services.",
                          AppLocalizations.of(context)!.tutorialSettings_desc4,
                          style: TextStyle(color: Colors.white, fontSize: 30.0))
                    ],
                  ),
                ))
          ]));

      _isInitialized = true;
    }
  }

  void showAppTutorial() {
    TutorialCoachMark(
      targets: appTargets,
      colorShadow: Colors.black,
      alignSkip: Alignment.bottomRight,

      textSkip: AppLocalizations.of(context)!.defaults_skip,
      useSafeArea: true,
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 30),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {
        return true;
      },
      onFinish: () {},
      // );
    )..show(context: context);
  }

  void showLGConnectionTutorial() {
    TutorialCoachMark(
      targets: lgConnectTargets,
      colorShadow: Colors.black,
      alignSkip: Alignment.bottomRight,

      textSkip: AppLocalizations.of(context)!.defaults_skip,
      useSafeArea: true,
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 30),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {
        return true;
      },
      onFinish: () {},
      // );
    )..show(context: context);
  }

  void showLGControlTutorial() {
    TutorialCoachMark(
      targets: lgControlTargets,
      colorShadow: Colors.black,
      alignSkip: Alignment.bottomRight,

      textSkip: AppLocalizations.of(context)!.defaults_skip,
      useSafeArea: true,
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 30),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {
        return true;
      },
      onFinish: () {},
      // );
    )..show(context: context);
  }

  void showFavTutorial() {
    TutorialCoachMark(
      targets: favsTargets,
      colorShadow: Colors.black,
      alignSkip: Alignment.bottomRight,

      textSkip: AppLocalizations.of(context)!.defaults_skip,
      useSafeArea: true,
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 30),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {
        return true;
      },
      onFinish: () {},
      // );
    )..show(context: context);
  }

  void showSettingsTutorial() {
    TutorialCoachMark(
      targets: appSettingsTargets,
      colorShadow: Colors.black,
      alignSkip: Alignment.bottomRight,

      textSkip: AppLocalizations.of(context)!.defaults_skip,
      useSafeArea: true,
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 30),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {
        return true;
      },
      onFinish: () {},
      // );
    )..show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontProv,
          ColorProvider colorProv, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                // 'Help Page',
                AppLocalizations.of(context)!.settingsHelp_title,
                style: TextStyle(
                  fontSize: fontProv.fonts.headingSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontType,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              //1. Home guide
              HelpButton(
                  bgColor: colorProv.colors.innerBackground,
                  textColor: fontProv.fonts.primaryFontColor,
                  textSize: fontProv.fonts.textSize - 4,
                  text: AppLocalizations.of(context)!.settingsHelp_button1,
                  onTap: () {
                    showAppTutorial();
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              HelpButton(
                bgColor: colorProv.colors.innerBackground,
                textColor: fontProv.fonts.primaryFontColor,
                textSize: fontProv.fonts.textSize - 4,
                text: AppLocalizations.of(context)!.settingsHelp_button2,
                onTap: () {
                  //navigate currview to LG connection:
                  CurrentViewProvider currViewProv =
                      Provider.of<CurrentViewProvider>(context, listen: false);
                  currViewProv.currentView = 'connection';
                  showLGConnectionTutorial();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              HelpButton(
                bgColor: colorProv.colors.innerBackground,
                textColor: fontProv.fonts.primaryFontColor,
                textSize: fontProv.fonts.textSize - 4,
                text: AppLocalizations.of(context)!.settingsHelp_button3,
                onTap: () {
                  //navigate currview to LG control:
                  CurrentViewProvider currViewProv =
                      Provider.of<CurrentViewProvider>(context, listen: false);
                  currViewProv.currentView = 'tasks';
                  showLGControlTutorial();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              HelpButton(
                bgColor: colorProv.colors.innerBackground,
                textColor: fontProv.fonts.primaryFontColor,
                textSize: fontProv.fonts.textSize - 4,
                text: AppLocalizations.of(context)!.settingsHelp_button6,
                onTap: () {
                  //navigate currview to favs:
                  CurrentViewProvider currViewProv =
                      Provider.of<CurrentViewProvider>(context, listen: false);
                  currViewProv.currentView = 'favs';
                  showFavTutorial();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              HelpButton(
                bgColor: colorProv.colors.innerBackground,
                textColor: fontProv.fonts.primaryFontColor,
                textSize: fontProv.fonts.textSize - 4,
                text: AppLocalizations.of(context)!.settingsHelp_button8,
                onTap: () {
                  showSettingsTutorial();
                },
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ],
          ),
        );
      },
    );
  }
}
