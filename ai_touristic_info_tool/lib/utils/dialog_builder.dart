import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

Future<void> dialogBuilder(
    BuildContext context,
    String dialogMessage,
    bool isOne,
    String confirmMessage,
    VoidCallback? onConfirm,
    VoidCallback? onCancel) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider colorVal,
            FontsProvider fontVal, Widget? child) {
          return AlertDialog(
            // backgroundColor: FontAppColors.secondaryFont,
            backgroundColor: colorVal.colors.innerBackground,
            title: Text(
              'Alert!',
              style: TextStyle(
                  // fontSize: textSize,
                  fontSize: fontVal.fonts.textSize,
                  color: LgAppColors.lgColor2),
            ),
            content: Text(dialogMessage,
                style: TextStyle(
                    fontSize: fontVal.fonts.textSize,
                    color: fontVal.fonts.primaryFontColor)),
            actions: <Widget>[
              if (isOne == false)
                TextButton(
                  child: Text('CANCEL',
                      style: TextStyle(
                          // fontSize: textSize,
                          fontSize: fontVal.fonts.textSize,
                          color: LgAppColors.lgColor2)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCancel != null) {
                      try {
                        onCancel();
                      } catch (e) {
                        // ignore: avoid_print
                        print(e);
                      }
                    }
                  },
                ),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (onConfirm != null) {
                      try {
                        onConfirm();
                      } catch (e) {
                        // ignore: avoid_print
                        print(e);
                      }
                    }
                  },
                  child: Text(confirmMessage,
                      style: TextStyle(
                          // fontSize: textSize,
                          fontSize: fontVal.fonts.textSize,
                          color: LgAppColors.lgColor4))),
            ],
          );
        },
      );
    },
  );
}
