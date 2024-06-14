import 'package:ai_touristic_info_tool/constants.dart';
import 'package:flutter/material.dart';

class AppDividerWidget extends StatelessWidget {
  final double height;
  const AppDividerWidget({
    super.key, required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: height,
      color: PrimaryAppColors.buttonColors,
    );
  }
}
