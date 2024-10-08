import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsOptionButton extends StatefulWidget {
  final String buttonText;
  final String buttonDescription;
  final IconData icon;
  final Widget view;
  final int index;
  final int selectedIndex;
  final Function(Widget, int) onPressed;
  const SettingsOptionButton({
    super.key,
    required this.buttonText,
    required this.buttonDescription,
    required this.icon,
    required this.view,
    required this.index,
    required this.selectedIndex,
    required this.onPressed,
  });

  @override
  State<SettingsOptionButton> createState() => _SettingsOptionButtonState();
}

class _SettingsOptionButtonState extends State<SettingsOptionButton> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = (widget.index == widget.selectedIndex);
    return GestureDetector(
      onTap: () {
        widget.onPressed(widget.view, widget.index);
      },
      child: Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider value,
            FontsProvider fontProv, Widget? child) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: isPressed ? value.colors.midShadow : value.colors.shadow,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                isPressed
                    ? BoxShadow(
                        color: value.colors.gradient4.withOpacity(0.9),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(1.5, 1.5),
                      )
                    : BoxShadow(
                        color: Colors.black.withOpacity(0),
                        spreadRadius: 0,
                        blurRadius: 0,
                      ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.04,
                  decoration: BoxDecoration(
                    color: value.colors.darkShadow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        widget.icon,
                        size: MediaQuery.of(context).size.width * 0.025,
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        widget.buttonText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: fontType,
                          fontSize: fontProv.fonts.textSize + 3,
                          color: FontAppColors.primaryFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        widget.buttonDescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: fontType,
                          fontSize: textSize,
                          color: FontAppColors.primaryFont,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.arrow_forward_ios),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
