
import 'package:ai_touristic_info_tool/constants.dart';
import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final double textSize;
  final String text;
  final Function()? onTap;
  const HelpButton({
    super.key, required this.bgColor, required this.textColor, required this.textSize, required this.text, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: LgAppColors.lgColor3,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Expanded(
                child: Text(
                 text,
                  style: TextStyle(
                    fontSize: textSize,
                    color: textColor,
                    fontFamily: fontType,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
