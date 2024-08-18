import 'package:ai_touristic_info_tool/reusable_widgets/current_view.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/show_ai_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            // top: 100,
            // bottom: 30,
            // left: 150,
            // right: 20,
            top: MediaQuery.of(context).size.height * 0.13,
            bottom: MediaQuery.of(context).size.height * 0.03,
            left: MediaQuery.of(context).size.width * 0.12,
            right: MediaQuery.of(context).size.width * 0.02,

            child: Consumer<ColorProvider>(
              builder:
                  (BuildContext context, ColorProvider value, Widget? child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // color: PrimaryAppColors.innerBackground,
                    color: value.colors.innerBackground,
                  ),
                  child: const CurrentView(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
