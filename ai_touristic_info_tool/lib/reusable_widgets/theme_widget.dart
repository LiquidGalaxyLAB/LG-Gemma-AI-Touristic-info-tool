import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class ThemeWidget extends StatefulWidget {
  const ThemeWidget({super.key});

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  int selectedColor = -1;

  Color pickerColor = Color(0xff443a49);
  // Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    ColorProvider colorProv =
        Provider.of<ColorProvider>(context, listen: false);
    colorProv.updateButtonColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Appearance',
              style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize + 3,
                color: FontAppColors.primaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              'Change how UI looks and feels',
              style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize,
                color: FontAppColors.primaryFont,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text(
            'Interface theme',
            style: TextStyle(
              fontFamily: fontType,
              fontSize: textSize,
              color: FontAppColors.primaryFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Consumer<ColorProvider>(
            builder:
                (BuildContext context, ColorProvider value, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.12,
                        decoration: BoxDecoration(
                          // color: PrimaryAppColors.darkShadow,
                          color: value.colors.shadow,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        'System Default',
                        style: TextStyle(
                            fontFamily: fontType,
                            fontSize: textSize - 4,
                            color: FontAppColors.primaryFont),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.12,
                        decoration: BoxDecoration(
                          // color: PrimaryAppColors.darkShadow,
                          color: value.colors.innerBackground,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        'Light Theme',
                        style: TextStyle(
                            fontFamily: fontType,
                            fontSize: textSize - 4,
                            color: FontAppColors.primaryFont),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.12,
                        decoration: BoxDecoration(
                          color: PrimaryAppColors.darkShadow,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        'Dark Theme',
                        style: TextStyle(
                            fontFamily: fontType,
                            fontSize: textSize - 4,
                            color: FontAppColors.primaryFont),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          Text(
            'Accent Color',
            style: TextStyle(
              fontFamily: fontType,
              fontSize: textSize,
              color: FontAppColors.primaryFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
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
                  colorProv.updateButtonColor(PrimaryAppColors.buttonColors);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<ColorProvider>(
                builder:
                    (BuildContext context, ColorProvider value, Widget? child) {
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
                          Text(
                            'Current Color',
                            style: TextStyle(
                              fontFamily: fontType,
                              fontSize: textSize,
                              color: FontAppColors.primaryFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Consumer<ColorProvider>(
                            builder: (BuildContext context, ColorProvider value,
                                Widget? child) {
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
              Consumer<ColorProvider>(
                builder:
                    (BuildContext context, ColorProvider value, Widget? child) {
                  return LgElevatedButton(
                    elevatedButtonContent: 'Pick a color',
                    // buttonColor: PrimaryAppColors.buttonColors,
                    buttonColor: value.colors.buttonColors,
                    onpressed: () {
                      setState(() {
                        selectedColor = 8;
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
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
                                    colorProv.updateButtonColor(pickerColor);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                        color: FontAppColors.primaryFont,
                                        fontFamily: fontType,
                                        fontSize: textSize),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.15,
                    fontSize: textSize,
                    fontColor: FontAppColors.secondaryFont,
                    isLoading: false,
                    isBold: false,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 30,
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
