import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeWidget extends StatefulWidget {
  const ThemeWidget({super.key});

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  int selectedColor = -1;
  String selectedTheme = SettingsSharedPref.getTheme() ?? 'default';

  Color pickerColor = Color(0xff443a49);
  // Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    ColorProvider colorProv =
        Provider.of<ColorProvider>(context, listen: false);
    colorProv.updateButtonColor(color);
    SettingsSharedPref.setAccentTheme(color.toHexString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Consumer<FontsProvider>(
                builder:
                    (BuildContext context, FontsProvider value, Widget? child) {
                  return Text(
                    // 'Appearance',
                    AppLocalizations.of(context)!.settingsTheme_title,
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize + 3,
                      fontSize: value.fonts.textSize + 3,
                      color: FontAppColors.primaryFont,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Consumer<FontsProvider>(
                builder:
                    (BuildContext context, FontsProvider value, Widget? child) {
                  return Text(
                    // 'Change how UI looks and feels',
                    AppLocalizations.of(context)!.settingsTheme_subtitle,
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      fontSize: value.fonts.textSize,
                      color: FontAppColors.primaryFont,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Consumer<FontsProvider>(
              builder:
                  (BuildContext context, FontsProvider value, Widget? child) {
                return Text(
                  // 'Interface theme',
                  AppLocalizations.of(context)!.settingsTheme_interface,
                  style: TextStyle(
                    fontFamily: fontType,
                    // fontSize: textSize,
                    fontSize: value.fonts.textSize,
                    color: FontAppColors.primaryFont,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Consumer2<ColorProvider, FontsProvider>(
              builder: (BuildContext context, ColorProvider value,
                  FontsProvider fontProv, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            // color: PrimaryAppColors.darkShadow,
                            color: value.colors.innerBackground,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedTheme = 'default';
                                });
                                SettingsSharedPref.setTheme('default');

                                ColorProvider colorProv =
                                    Provider.of<ColorProvider>(context,
                                        listen: false);
                                colorProv.updateButtonColor(
                                    PrimaryAppColors.buttonColors);
                                colorProv.updateTheme('default');

                                FontsProvider fontProvv =
                                    Provider.of<FontsProvider>(context,
                                        listen: false);

                                fontProvv.updateFont(
                                    SettingsSharedPref.getTitleFont() ?? 40);
                                fontProvv.fonts.updateFontColor();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 30, // Set the elevation value here
                                backgroundColor: selectedTheme == 'default'
                                    ? Colors.black.withOpacity(0.5)
                                    : value.colors.innerBackground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      0), // Optional: Set button shape
                                ),
                              ),
                              child: Image.asset(
                                  "assets/images/system-default.png")),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            // 'System Default',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.settingsTheme_default,
                            style: TextStyle(
                                fontFamily: fontType,
                                // fontSize: textSize - 4,
                                fontSize: fontProv.fonts.textSize - 4,
                                color: FontAppColors.primaryFont),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            // color: PrimaryAppColors.darkShadow,
                            color: value.colors.innerBackground,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedTheme = 'light';
                              });
                              SettingsSharedPref.setTheme('light');
                              ColorProvider colorProv =
                                  Provider.of<ColorProvider>(context,
                                      listen: false);
                              colorProv.updateButtonColor(
                                  colorProv.colors.buttonColors);
                              colorProv.updateTheme('light');

                              FontsProvider fontProvv =
                                  Provider.of<FontsProvider>(context,
                                      listen: false);

                              fontProvv.updateFont(
                                  SettingsSharedPref.getTitleFont() ?? 40);
                              fontProvv.fonts.updateFontColor();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 30, // Set the elevation value here
                              backgroundColor: selectedTheme == 'light'
                                  ? Colors.black.withOpacity(0.5)
                                  : value.colors.innerBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Optional: Set button shape
                              ),
                            ),
                            child: Image.asset("assets/images/light-theme.png"),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          // 'Light Theme',
                          AppLocalizations.of(context)!.settingsTheme_light,
                          style: TextStyle(
                              fontFamily: fontType,
                              // fontSize: textSize - 4,
                              fontSize: fontProv.fonts.textSize - 4,
                              color: FontAppColors.primaryFont),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            color: PrimaryAppColors.innerBackground,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedTheme = 'dark';
                              });
                              SettingsSharedPref.setTheme('dark');
                              ColorProvider colorProv =
                                  Provider.of<ColorProvider>(context,
                                      listen: false);
                              colorProv.updateButtonColor(
                                  colorProv.colors.buttonColors);
                              colorProv.updateTheme('dark');

                              FontsProvider fontProvv =
                                  Provider.of<FontsProvider>(context,
                                      listen: false);

                              fontProvv.updateFont(
                                  SettingsSharedPref.getTitleFont() ?? 40);
                              fontProvv.fonts.updateFontColor();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 30, // Set the elevation value here
                              backgroundColor: selectedTheme == 'dark'
                                  ? Colors.black.withOpacity(0.5)
                                  : value.colors.innerBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Optional: Set button shape
                              ),
                            ),
                            child: Image.asset("assets/images/dark-theme.png"),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          // 'Dark Theme',
                          AppLocalizations.of(context)!.settingsTheme_dark,
                          style: TextStyle(
                              fontFamily: fontType,
                              // fontSize: textSize - 4,
                              fontSize: fontProv.fonts.textSize - 4,
                              color: FontAppColors.primaryFont),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            if (SettingsSharedPref.getTheme() != 'dark')
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
            if (SettingsSharedPref.getTheme() != 'dark')
              Consumer<FontsProvider>(
                builder:
                    (BuildContext context, FontsProvider value, Widget? child) {
                  return Text(
                    // 'Accent Color',
                    AppLocalizations.of(context)!.settingsTheme_accent,
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      fontSize: value.fonts.textSize,
                      color: FontAppColors.primaryFont,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            if (SettingsSharedPref.getTheme() != 'dark')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 0;
                        // currentColor = PrimaryAppColors.buttonColors;
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      // colorProv.updateButtonColor(PrimaryAppColors.buttonColors);
                      colorProv
                          .updateButtonColor(PrimaryAppColors.buttonColors);
                      SettingsSharedPref.setAccentTheme(
                          PrimaryAppColors.buttonColors.toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 0
                          ? PrimaryAppColors.buttonColors.withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 0 ? 15 : 20,
                        backgroundColor: PrimaryAppColors.buttonColors,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 1;
                        // currentColor = Color(0xFFAB87C7);
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      colorProv.updateButtonColor(Color(0xFFAB87C7));
                      SettingsSharedPref.setAccentTheme(
                          Color(0xFFAB87C7).toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 1
                          ? Color(0xFFAB87C7).withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 1 ? 15 : 20,
                        backgroundColor: Color(0xFFAB87C7),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 2;
                        // currentColor = Color(0xFF1D6F9A);
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      colorProv.updateButtonColor(Color(0xFF1D6F9A));
                      SettingsSharedPref.setAccentTheme(
                          Color(0xFF1D6F9A).toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 2
                          ? Color(0xFF1D6F9A).withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 2 ? 15 : 20,
                        backgroundColor: Color(0xFF1D6F9A),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 3;
                        // currentColor = Color(0xFF2E8B57);
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      colorProv.updateButtonColor(Color(0xFF2E8B57));
                      SettingsSharedPref.setAccentTheme(
                          Color(0xFF2E8B57).toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 3
                          ? Color(0xFF2E8B57).withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 3 ? 15 : 20,
                        backgroundColor: Color(0xFF2E8B57),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 4;
                        // currentColor = Color(0xFFAB4C4C);
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      colorProv.updateButtonColor(Color(0xFFAB4C4C));
                      SettingsSharedPref.setAccentTheme(
                          Color(0xFFAB4C4C).toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 4
                          ? Color(0xFFAB4C4C).withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 4 ? 15 : 20,
                        backgroundColor: Color(0xFFB03A2E),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 5;
                        // currentColor = Color(0xFFCE6C2F);
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      colorProv.updateButtonColor(Color(0xFFCE6C2F));
                      SettingsSharedPref.setAccentTheme(
                          Color(0xFFCE6C2F).toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 5
                          ? Color(0xFFCE6C2F).withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 5 ? 15 : 20,
                        backgroundColor: Color(0xFFCE6C2F),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 6;
                        // currentColor = Color(0xFFD81B60);
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      colorProv.updateButtonColor(Color(0xFFD81B60));
                      SettingsSharedPref.setAccentTheme(
                          Color(0xFFD81B60).toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 6
                          ? Color(0xFFD81B60).withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 6 ? 15 : 20,
                        backgroundColor: Color(0xFFD81B60),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 7;
                        // currentColor = Color(0xFF00796B);
                      });
                      ColorProvider colorProv =
                          Provider.of<ColorProvider>(context, listen: false);
                      colorProv.updateButtonColor(Color(0xFF00796B));
                      SettingsSharedPref.setAccentTheme(
                          Color(0xFF00796B).toHexString());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: selectedColor == 7
                          ? Color(0xFF00796B).withOpacity(0.5)
                          : Colors.transparent,
                      child: CircleAvatar(
                        radius: selectedColor == 7 ? 15 : 20,
                        backgroundColor: Color(0xFF00796B),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            if (SettingsSharedPref.getTheme() != 'dark')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<ColorProvider>(
                    builder: (BuildContext context, ColorProvider value,
                        Widget? child) {
                      return Container(
                        decoration: BoxDecoration(
                          // color: PrimaryAppColors.innerBackground,
                          color: value.colors.innerBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Consumer<FontsProvider>(
                                builder: (BuildContext context,
                                    FontsProvider value, Widget? child) {
                                  return Text(
                                    // 'Current Color',
                                    AppLocalizations.of(context)!
                                        .settingsTheme_current,
                                    style: TextStyle(
                                      fontFamily: fontType,
                                      // fontSize: textSize,
                                      fontSize: value.fonts.textSize,
                                      // color: FontAppColors.primaryFont,
                                      color: value.fonts.primaryFontColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Consumer<ColorProvider>(
                                builder: (BuildContext context,
                                    ColorProvider value, Widget? child) {
                                  return CircleAvatar(
                                    radius: 10,
                                    backgroundColor: value.colors.buttonColors,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Consumer2<ColorProvider, FontsProvider>(
                    builder: (BuildContext context, ColorProvider value,
                        FontsProvider fontProv, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = 8;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: value.colors.innerBackground,
                                  title: Text(
                                    // 'Pick a color!',
                                    AppLocalizations.of(context)!
                                        .settingsTheme_pick,
                                    style: TextStyle(
                                      fontFamily: fontType,
                                      // fontSize: textSize,
                                      fontSize: fontProv.fonts.textSize,
                                      // color: FontAppColors.primaryFont,
                                      color: fontProv.fonts.primaryFontColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: changeColor,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // setState(() => currentColor = pickerColor);
                                        ColorProvider colorProv =
                                            Provider.of<ColorProvider>(context,
                                                listen: false);
                                        colorProv
                                            .updateButtonColor(pickerColor);
                                        SettingsSharedPref.setAccentTheme(
                                            pickerColor.toHexString());
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        // 'Done',
                                        AppLocalizations.of(context)!
                                            .defaults_done,
                                        style: TextStyle(
                                            // color: FontAppColors.primaryFont,
                                            color:
                                                fontProv.fonts.primaryFontColor,
                                            fontFamily: fontType,
                                            // fontSize: textSize,
                                            fontSize: fontProv.fonts.textSize),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Image.asset(
                          "assets/images/colors.png",
                          scale: 10,
                        ),
                      );
                    },
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
