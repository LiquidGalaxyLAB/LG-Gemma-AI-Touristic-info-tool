import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDividerWidget extends StatelessWidget {
  final double height;
  const AppDividerWidget({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (BuildContext context, ColorProvider value, Widget? child) {
        return Container(
          width: 4,
          height: height,
          color: value.colors.buttonColors,
        );
      },
    );
  }
}
