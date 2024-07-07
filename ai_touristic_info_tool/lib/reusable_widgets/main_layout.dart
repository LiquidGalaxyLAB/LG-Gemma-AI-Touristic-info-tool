import 'package:ai_touristic_info_tool/reusable_widgets/current_view.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/show_ai_alert.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

import 'app_bar_widget.dart';
import 'drawer.dart';
import 'gradient_background.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({
    super.key,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAIAlert(context);
    });
  }

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
