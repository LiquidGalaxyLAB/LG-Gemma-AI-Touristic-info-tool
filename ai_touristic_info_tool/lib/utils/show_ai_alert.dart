import 'package:ai_touristic_info_tool/constants.dart';
import 'package:flutter/material.dart';

Future<void> showAIAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: FontAppColors.secondaryFont,
          title: Center(
            child: Text(
              'Be aware of AI hallucinations !',
              style: TextStyle(
                  fontSize: headingSize,
                  color: LgAppColors.lgColor2,
                  fontFamily: fontType,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      'The state of the art of most AI tools as 2024 can give you sometimes incorrect answers, or even the so called Hallucinations:\n\n',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: textSize + 4,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontType),
                ),
                TextSpan(
                  text:
                      'AI hallucinations are incorrect or misleading results that AI models generate. These errors can be caused by a variety of factors, including insufficient training data, incorrect assumptions made by the model, or biases in the data used to train the model.\n\nThe Liquid Galaxy project has no control over this, and the contents responsibility is of the owners of the respective Large Language models used',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: textSize,
                      fontFamily: fontType),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text('I understand',
                    style: const TextStyle(
                        fontSize: textSize, color: LgAppColors.lgColor4))),
          ],
        );
      },
    );
  }