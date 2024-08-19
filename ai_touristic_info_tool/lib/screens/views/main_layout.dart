import 'package:ai_touristic_info_tool/screens/views/current_view.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/show_ai_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../reusable_widgets/app_bar_widget.dart';
import '../../reusable_widgets/drawer.dart';
import '../../reusable_widgets/gradient_background.dart';

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
