import 'package:ai_touristic_info_tool/models/dynamic_colors_model.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

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
                // PrimaryAppColors.gradient1,
                // PrimaryAppColors.gradient2,
                // PrimaryAppColors.gradient3,
                // PrimaryAppColors.gradient4,
              ],
            ),
          ),
        );
      },
    );
  }
}
