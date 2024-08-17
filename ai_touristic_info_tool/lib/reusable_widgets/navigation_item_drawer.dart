import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class NavigationItem extends StatelessWidget {
  final String imagePath;
  final IconData icondata;
  final String title;
  final Color color;
  final Color containerColor;
  final VoidCallback? onPressed;
  final double topLeftCurve;
  final double topRightCurve;
  final double bottomLeftCurve;
  final double bottomRightCurve;

  const NavigationItem({
    super.key,
    required this.imagePath,
    required this.icondata,
    required this.title,
    required this.color,
    this.onPressed,
    required this.containerColor,
    required this.topLeftCurve,
    required this.topRightCurve,
    required this.bottomLeftCurve,
    required this.bottomRightCurve,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Consumer<FontsProvider>(
        builder: (BuildContext context, FontsProvider value, Widget? child) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftCurve),
              topRight: Radius.circular(topRightCurve),
              bottomLeft: Radius.circular(bottomLeftCurve),
              bottomRight: Radius.circular(bottomRightCurve),
            ),
            child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: containerColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Icon(
                        icondata,
                        color: color,
                        size: 40,
                      ),
                      // Image.asset(
                      //   imagePath,
                      //   color: color,
                      //   height: 40,
                      //   width: 40,
                      // ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: fontType,
                            // fontSize: textSize - 10,
                            fontSize: textSize - 5,
                            // fontSize: value.fonts.textSize - 10,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
