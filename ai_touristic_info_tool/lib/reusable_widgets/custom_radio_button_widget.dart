import 'package:ai_touristic_info_tool/constants.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  final String title;
  final int value;
  final int groupValue;
  final Color activeColor;
  final double scale;
  final double fontSize;
  final ValueChanged<int?> onChanged;

  const RadioButton({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.activeColor,
    required this.onChanged,
    this.scale = 1.5,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontFamily: fontType,
        ),
      ),
      leading: Transform.scale(
        scale: scale,
        child: Radio<int>(
          value: value,
          groupValue: groupValue,
          activeColor: activeColor,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
