import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class LGShowCaseWidget extends StatefulWidget {
  final showCaseKey;
  final double height;
  final double width;
  final ShapeBorder targetShape;
  final Widget showCaseWidget;
  final String title;
  final String description;
  final Widget? customContent;
  const LGShowCaseWidget(
      {super.key,
      required this.showCaseKey,
      required this.height,
      required this.width,
      required this.targetShape,
      required this.showCaseWidget,
      required this.title,
      required this.description,
      this.customContent});

  @override
  State<LGShowCaseWidget> createState() => _LGShowCaseWidgetState();
}

class _LGShowCaseWidgetState extends State<LGShowCaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontProv,
          ColorProvider colorProv, Widget? child) {
        return Showcase.withWidget(
          key: widget.showCaseKey,
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 0.2,
          targetShapeBorder: widget.targetShape,
          overlayColor: Colors.black.withOpacity(1),
          tooltipPosition: TooltipPosition.top,
          toolTipSlideEndDistance: 50,
          container: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: colorProv.colors.buttonColors.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: fontProv.fonts.textSize,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: widget.showCaseWidget,
        );
      },
    );
  }
}
