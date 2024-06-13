import 'package:flutter/material.dart';

import '../constants.dart';

class NavigationItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color color;
  final Color containerColor;
  final VoidCallback? onPressed;

  const NavigationItem(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.color,
      this.onPressed,
      required this.containerColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: containerColor,
        child: Column(
          children: [
            Image.asset(
              imagePath,
              color: color,
              height: 40,
              width: 40,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize - 10,
                color: color,
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
