import 'package:flutter/material.dart';
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
      return AlertDialog(
        backgroundColor: FontAppColors.secondaryFont,
        title: const Text(
          'Alert!',
          style: TextStyle(fontSize: textSize, color: LgAppColors.lgColor2),
        ),
        content:
            Text(dialogMessage, style: const TextStyle(fontSize: textSize)),
        actions: <Widget>[
          if (isOne == false)
            TextButton(
              child: const Text('CANCEL',
                  style: TextStyle(
                      fontSize: textSize, color: LgAppColors.lgColor2)),
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
                  style: const TextStyle(
                      fontSize: textSize, color: LgAppColors.lgColor4))),
        ],
      );
    },
  );
}
