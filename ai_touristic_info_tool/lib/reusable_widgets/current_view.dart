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
        return const Placeholder();
      } else if (viewProvider.currentView == 'animal') {
        return const Placeholder();
      } else if (viewProvider.currentView == 'connection') {
        return const ConnectionView();
      } else if (viewProvider.currentView == 'tasks') {
        return const LGTasksView();
      } else if (viewProvider.currentView == 'settings') {
        return const Placeholder();
      }
      return const Placeholder();
    });
  }
}
