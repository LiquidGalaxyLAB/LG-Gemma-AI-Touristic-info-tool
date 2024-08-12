import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class FontWidget extends StatefulWidget {
  const FontWidget({super.key});

  @override
  State<FontWidget> createState() => _FontWidgetState();
}

class _FontWidgetState extends State<FontWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer2<FontsProvider, ColorProvider>(
        builder: (BuildContext context, FontsProvider value,
            ColorProvider colorval, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  // 'Font Settings',
                  AppLocalizations.of(context)!.settingsFont_title,
                  style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize + 3,
                      fontSize: value.fonts.textSize + 3,
                      // color: FontAppColors.primaryFont,
                      // color: value.fonts.primaryFontColor,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  // 'Change the font size',
                  AppLocalizations.of(context)!.settingsFont_subtitle,
                  style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      fontSize: value.fonts.textSize,
                      // color: FontAppColors.primaryFont,
                      // color: value.fonts.primaryFontColor,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Slider(
                activeColor: colorval.colors.buttonColors,
                value: value.fonts.titleSize,
                min: 40,
                max: 50,
                divisions: 20,
                label: value.fonts.titleSize.round().toString(),
                onChanged: (double newVal) {
                  FontsProvider fontProv =
                      Provider.of<FontsProvider>(context, listen: false);

                  fontProv.updateFont(newVal);
                  fontProv.fonts.updateFontColor();
                  SettingsSharedPref.setTitleFont(newVal);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Center(
                child: Text(
                  // 'Aa',
                  AppLocalizations.of(context)!.settingsFont_trial,
                  style: TextStyle(
                      fontSize: value.fonts.titleSize,
                      fontFamily: fontType,
                      // color: value.fonts.primaryFontColor,
                      color: Colors.black),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
