import 'package:ai_touristic_info_tool/constants.dart';
import 'package:flutter/material.dart';

class LgTasksButton extends StatelessWidget {
  final Color buttonColor;
  final Color borderColor;
  final double fontSize;
  final String text;
  final Function() onTap;
  final String imgPath;
  const LgTasksButton({
    super.key,
    required this.buttonColor,
    required this.borderColor,
    required this.fontSize,
    required this.text,
    required this.onTap,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Image.asset(
                  imgPath,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // AppLocalizations.of(context)!.lgTasks_relaunch,
                    text,
                    style: TextStyle(
                      fontFamily: fontType,
                      fontSize: fontSize,
                      color: FontAppColors.primaryFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
