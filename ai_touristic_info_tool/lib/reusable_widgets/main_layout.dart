import 'package:ai_touristic_info_tool/reusable_widgets/current_view.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

import 'app_bar_widget.dart';
import 'drawer.dart';
import 'gradient_background.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          const AppBarWidget(),
          const DrawerWidget(),
          Positioned(
            top: 100,
            bottom: 30,
            left: 150,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: PrimaryAppColors.innerBackground),
              child: const CurrentView(),
            ),
          ),
        ],
      ),
    );
  }
}
