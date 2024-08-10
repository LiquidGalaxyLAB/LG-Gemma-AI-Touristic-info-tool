import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
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
                  // height: MediaQuery.of(context).size.height * 0.15,
                  // width: MediaQuery.of(context).size.width * 0.6,
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


  //  Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     Text(
          //       widget.title,
          //       style: TextStyle(
          //           fontSize: fontProv.fonts.headingSize,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(top: 8.0),
          //       child: Container(
          //         width: MediaQuery.of(context).size.width * 0.3,
          //         height: MediaQuery.of(context).size.height * 0.1,
          //         child: Text(
          //           widget.description,
          //           maxLines: 3,
          //           style: TextStyle(
          //               fontSize: fontProv.fonts.textSize,
          //               color: Colors.white),
          //         ),
          //       ),
          //     ),
          //     Row(
          //       children: [
          //         LgElevatedButton(
          //             elevatedButtonContent: 'skip',
          //             buttonColor: LgAppColors.lgColor2,
          //             onpressed: () {
          //               ShowCaseWidget.of(context).dismiss();
          //             },
          //             height: MediaQuery.of(context).size.height * 0.05,
          //             width: MediaQuery.of(context).size.width * 0.1,
          //             fontSize: fontProv.fonts.textSize,
          //             fontColor: Colors.white,
          //             isLoading: false,
          //             isBold: false,
          //             isPrefixIcon: false,
          //             isSuffixIcon: false,
          //             curvatureRadius: 10),
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width * 0.01,
          //         ),
          //         LgElevatedButton(
          //             elevatedButtonContent: 'back',
          //             buttonColor: LgAppColors.lgColor3,
          //             onpressed: () {
          //               ShowCaseWidget.of(context).previous();
          //             },
          //             height: MediaQuery.of(context).size.height * 0.05,
          //             width: MediaQuery.of(context).size.width * 0.1,
          //             fontSize: fontProv.fonts.textSize,
          //             fontColor: Colors.white,
          //             isLoading: false,
          //             isBold: false,
          //             isPrefixIcon: false,
          //             isSuffixIcon: false,
          //             curvatureRadius: 10),
          //         SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          //         LgElevatedButton(
          //             elevatedButtonContent: 'next',
          //             buttonColor: LgAppColors.lgColor4,
          //             onpressed: () {
          //               ShowCaseWidget.of(context).next();
          //             },
          //             height: MediaQuery.of(context).size.height * 0.05,
          //             width: MediaQuery.of(context).size.width * 0.1,
          //             fontSize: fontProv.fonts.textSize,
          //             fontColor: Colors.white,
          //             isLoading: false,
          //             isBold: false,
          //             isPrefixIcon: false,
          //             isSuffixIcon: false,
          //             curvatureRadius: 10),
          //       ],
          //     ),
          //     if (widget.customContent != null) widget.customContent!,
          //   ],
          // ),

/*
(new) Showcase Showcase.withWidget({
  required GlobalKey<State<StatefulWidget>> key,
  required double? height,
  required double? width,
  required Widget? container,
  required Widget child,
  ShapeBorder targetShapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  Color overlayColor = Colors.black45,
  BorderRadius? targetBorderRadius,
  double overlayOpacity = 0.75,
  Widget scrollLoadingWidget = const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
  void Function()? onTargetClick,
  bool? disposeOnTap,
  Duration movingAnimationDuration = const Duration(milliseconds: 2000),
  bool? disableMovingAnimation,
  EdgeInsets targetPadding = EdgeInsets.zero,
  double? blurValue,
  void Function()? onTargetLongPress,
  void Function()? onTargetDoubleTap,
  bool disableDefaultTargetGestures = false,
  TooltipPosition? tooltipPosition,
  void Function()? onBarrierClick,
  bool disableBarrierInteraction = false,
  double toolTipSlideEndDistance = 7,
})
*/