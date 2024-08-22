import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';

class CustomRecordingWaveWidget extends StatefulWidget {
  const CustomRecordingWaveWidget({super.key});

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  final List<double> _heights = [0.04, 0.06, 0.08, 0.06, 0.04];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      if (mounted) {
        setState(() => _heights.add(_heights.removeAt(0)));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, value, _) => Center(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _heights.map((height) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 10, // Reduce the width
                height: MediaQuery.sizeOf(context).height * height * 0.5,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: value.colors.buttonColors,
                  borderRadius: BorderRadius.circular(25),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
