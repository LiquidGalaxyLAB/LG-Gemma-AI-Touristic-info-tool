import 'package:ai_touristic_info_tool/constants.dart';
import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  final Widget child;
  const TopBarWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [
            PrimaryAppColors.gradient1,
            PrimaryAppColors.gradient2,
            PrimaryAppColors.gradient3,
            PrimaryAppColors.gradient4,
          ],
        ),
      ),
      child: child,
    );
  }
}
