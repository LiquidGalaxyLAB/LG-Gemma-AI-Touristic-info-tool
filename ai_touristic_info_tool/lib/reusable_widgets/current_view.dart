import 'package:ai_touristic_info_tool/screens/about_view.dart';
import 'package:ai_touristic_info_tool/screens/app_settings.dart';
import 'package:ai_touristic_info_tool/screens/favorites_view.dart';
import 'package:ai_touristic_info_tool/screens/home_view.dart';
import 'package:ai_touristic_info_tool/screens/lg_connection_view.dart';
import 'package:ai_touristic_info_tool/screens/lg_tasks_view.dart';
import 'package:ai_touristic_info_tool/state_management/current_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentView extends StatefulWidget {
  const CurrentView({super.key});

  @override
  State<CurrentView> createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentViewProvider>(
        builder: (context, viewProvider, child) {
      if (viewProvider.currentView == 'home') {
        return const HomeView();
      } else if (viewProvider.currentView == 'favs') {
        return const FavoritesView();
      } else if (viewProvider.currentView == 'connection') {
        return const ConnectionView();
      } else if (viewProvider.currentView == 'tasks') {
        return const LGTasksView();
      } else if (viewProvider.currentView == 'settings') {
        return const AppSettingsView();
      } else if (viewProvider.currentView == 'about') {
        return const AboutScreen();
      }
      return const Placeholder();
    });
  }
}
