import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/custom_radio_button_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restart_app/restart_app.dart';

class LanguageWidget extends StatefulWidget {
  const LanguageWidget({super.key});

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  late int selectedOption = 1;

  @override
  void initState() {
    super.initState();
    _getLocale();
  }

  Future<void> _getLocale() async {
    Locale locale = await SettingsSharedPref.getLocale();
    if (locale.languageCode == 'en') {
      if (mounted) {
        setState(() {
          selectedOption = 1;
        });
      }
    } else if (locale.languageCode == 'es') {
      if (mounted) {
        setState(() {
          selectedOption = 2;
        });
      }
    } else if (locale.languageCode == 'de') {
      if (mounted) {
        setState(() {
          selectedOption = 3;
        });
      }
    } else if (locale.languageCode == 'fr') {
      if (mounted) {
        setState(() {
          selectedOption = 4;
        });
      }
    } else if (locale.languageCode == 'it') {
      if (mounted) {
        setState(() {
          selectedOption = 5;
        });
      }
    } else if (locale.languageCode == 'ja') {
      if (mounted) {
        setState(() {
          selectedOption = 6;
        });
      }
    } else if (locale.languageCode == 'hi') {
      if (mounted) {
        setState(() {
          selectedOption = 7;
        });
      }
    } else if (locale.languageCode == 'ar') {
      if (mounted) {
        setState(() {
          selectedOption = 8;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontProv,
          ColorProvider colorProv, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  // 'Help Page',
                  AppLocalizations.of(context)!.settingsLanguage_title,
                  style: TextStyle(
                    fontSize: fontProv.fonts.headingSize,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontType,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_eng,
                value: 1,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('en'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_esp,
                value: 2,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('es'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_german,
                value: 3,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('de'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_french,
                value: 4,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('fr'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_italian,
                value: 5,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('it'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_japanese,
                value: 6,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('ja'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_indian,
                value: 7,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('hi'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
              RadioButton(
                title: AppLocalizations.of(context)!.settingsLanguage_arabic,
                value: 8,
                groupValue: selectedOption,
                activeColor: colorProv.colors.buttonColors,
                onChanged: (value) {
                  dialogBuilder(
                      context,
                      AppLocalizations.of(context)!
                          .settingsLanguage_RestartWarning,
                      false,
                      AppLocalizations.of(context)!.defaults_restart, () async {
                    if (mounted) {
                      setState(() {
                        selectedOption = value!;
                      });
                    }
                    await SettingsSharedPref.setLocale(Locale('ar'));
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  }, () {});
                },
                fontSize: fontProv.fonts.textSize,
              ),
            ],
          ),
        );
      },
    );
  }
}
