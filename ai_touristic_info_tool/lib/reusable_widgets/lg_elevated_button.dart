import 'package:ai_touristic_info_tool/constants.dart';
import 'package:flutter/material.dart';

///This is a customer elevated button which is reused in many views through our app
///[OptimileElevatedButton] takes as parameters:
///   * [elevatedButtonContent] - A [String] for displaying the content of each elevated button
///   * [buttonColor] - A [Color] to display different colors for the buttons through the app
///   * [onpressed]  - A [Function] to be displayed when the button is pressed
///   * [height] - A [double] parameter for adjusting the height of the button
///   * [width] - A [double] parameter for adjusting the width of the button
///   * [fontSize] - A [double] parameter for adjusting the fontSize of the button
///   * [isLoading]  - An optional indicator of loading
///
class LgElevatedButton extends StatelessWidget {
  final String elevatedButtonContent;
  final Color buttonColor;
  final Function onpressed;
  final double height;
  final double width;
  final double fontSize;
  final Color fontColor;
  final bool isLoading;
  final bool isBold;
  final bool isPrefixIcon;
  final bool isSuffixIcon;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final double? prefixIconSize;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final double? suffixIconSize;
  final double curvatureRadius;

  const LgElevatedButton({
    required this.elevatedButtonContent,
    required this.buttonColor,
    required this.onpressed,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.fontColor,
    required this.isLoading,
    required this.isBold,
    required this.isPrefixIcon,
    required this.isSuffixIcon,
    required this.curvatureRadius,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixIconSize,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixIconSize,
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {
          onpressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(curvatureRadius),
          ),
        ),
        child: Stack(
          children: [
            if (isLoading)
              const Positioned.fill(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (isPrefixIcon)
                  Icon(
                    prefixIcon,
                    color: prefixIconColor,
                    size: prefixIconSize,
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    elevatedButtonContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: fontType,
                      color: fontColor,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSuffixIcon)
                  Icon(
                    suffixIcon,
                    color: suffixIconColor,
                    size: suffixIconSize,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
