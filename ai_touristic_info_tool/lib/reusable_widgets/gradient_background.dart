
import 'package:flutter/material.dart';

import '../constants.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PrimaryAppColors.gradient1,
            PrimaryAppColors.gradient2,
            PrimaryAppColors.gradient3,
            PrimaryAppColors.gradient4,
          ],
        ),
      ),
    );
  }
}