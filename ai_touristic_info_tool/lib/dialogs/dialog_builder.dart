import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


/// Displays a customizable alert dialog with a message and action buttons.
///
/// This function presents an `AlertDialog` with a customizable message and action buttons.
/// It uses the `ColorProvider` and `FontsProvider` for dynamic styling and localization
/// through `AppLocalizations`. The dialog can have one or two buttons based on the `isOne` parameter.
///
/// [context] - The `BuildContext` used to locate the `ColorProvider` and `FontsProvider`.
/// [dialogMessage] - The message displayed in the content area of the dialog.
/// [isOne] - A boolean indicating whether the dialog should have only one button (true) or two buttons (false).
/// [confirmMessage] - The text displayed on the confirmation button. Used if `isOne` is true or for the second button if `isOne` is false.
/// [onConfirm] - A callback function executed when the confirmation button is pressed. If null, no action is taken.
/// [onCancel] - A callback function executed when the cancel button is pressed. If null, no action is taken.
///
/// The dialog includes:
/// - A title with a fixed text for the alert title.
/// - A content area displaying the provided `dialogMessage`.
/// - One or two buttons based on the `isOne` parameter:
///   - A confirmation button with the text provided by `confirmMessage`.
///   - A cancel button with the text provided by `AppLocalizations.defaults_cancel` (only if `isOne` is false).
///
/// The `dialogBuilder` function performs the following actions:
/// - Displays the dialog with the specified message and buttons.
/// - Executes the `onConfirm` callback if provided, when the confirmation button is pressed.
/// - Executes the `onCancel` callback if provided, when the cancel button is pressed (only if `isOne` is false).


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
            backgroundColor: colorVal.colors.innerBackground,
            title: Text(
              AppLocalizations.of(context)!.defaults_alert,
              style: TextStyle(
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
                  child: Text(
                    AppLocalizations.of(context)!.defaults_cancel,
                      style: TextStyle(
                          fontSize: fontVal.fonts.textSize,
                          color: LgAppColors.lgColor2)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCancel != null) {
                      try {
                        onCancel();
                      } catch (e) {
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
                        print(e);
                      }
                    }
                  },
                  child: Text(confirmMessage,
                      style: TextStyle(
                          fontSize: fontVal.fonts.textSize,
                          color: LgAppColors.lgColor4))),
            ],
          );
        },
      );
    },
  );
}
