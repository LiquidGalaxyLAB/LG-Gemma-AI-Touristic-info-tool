import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (BuildContext context, ColorProvider value, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                value.colors.gradient1,
                value.colors.gradient2,
                value.colors.gradient3,
                value.colors.gradient4,
              ],
            ),
          ),
        );
      },
    );
  }
}
