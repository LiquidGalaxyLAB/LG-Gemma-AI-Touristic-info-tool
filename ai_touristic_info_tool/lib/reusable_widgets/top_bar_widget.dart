import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color grad1;
  final Color grad2;
  final Color grad3;
  final Color grad4;
  const TopBarWidget({
    super.key,
    required this.child,
    required this.height,
    required this.width,
    required this.grad1,
    required this.grad2,
    required this.grad3,
    required this.grad4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [
            grad1,
            grad2,
            grad3,
            grad4,
          ],
        ),
      ),
      child: child,
    );
  }
}
