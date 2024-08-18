import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/custom_recording_wave_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomRecordingButton extends StatefulWidget {
  const CustomRecordingButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  final bool isRecording;
  final VoidCallback onPressed;

  @override
  State<CustomRecordingButton> createState() => _CustomRecordingButtonState();
}

class _CustomRecordingButtonState extends State<CustomRecordingButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider, FontsProvider>(
      builder: (BuildContext context, ColorProvider colorProvv,
          FontsProvider fontProv, Widget? child) {
        return Center(
            child: GestureDetector(
          onTap: widget.onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (40 + 5) * 2,
                height: (40 + 5) * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorProvv.colors.buttonColors,
                    width: 5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: colorProvv.colors.innerBackground,
                  child: widget.isRecording
                      ? CustomRecordingWaveWidget()
                      : Icon(Icons.mic,
                          size: 50, color: colorProvv.colors.buttonColors),
                ),
              ),
              Text(
                widget.isRecording ? 'Stop' : 'Start',
                style: TextStyle(
                    fontSize: fontProv.fonts.textSize,
                    color: colorProvv.colors.buttonColors,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontType),
              ),
            ],
          ),
        ));
      },
    );
  }
}
