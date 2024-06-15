import 'package:ai_touristic_info_tool/reusable_widgets/connection_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../state_management/connection_provider.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 15,
        left: 50,
        right: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/appLogo.png',
              width: 80,
              height: 80,
            ),
            Text(
              'LG Gemma AI Touristic info tool',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: fontType,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: FontAppColors.secondaryFont),
            ),
            Consumer<Connectionprovider>(builder: (context, connection, _) {
              return const ConnectionIndicator();
            }),
          ],
        ));
  }
}