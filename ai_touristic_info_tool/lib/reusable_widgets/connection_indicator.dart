import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../state_management/connection_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A widget that displays an indicator to show the connection status.
class ConnectionIndicator extends StatefulWidget {
  const ConnectionIndicator({
    super.key,
  });

  @override
  State<ConnectionIndicator> createState() => _ConnectionIndicatorState();
}

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<Connectionprovider, ColorProvider, FontsProvider>(
      builder: (BuildContext context, Connectionprovider connection,
          ColorProvider colorProv, FontsProvider fontsProv, Widget? child) {
        return Align(
          alignment: Alignment.topRight,
          child: Container(
            //Local:

            // width: MediaQuery.of(context).size.width * 0.2,
            // height: MediaQuery.of(context).size.height * 0.05,
            //Gemini:
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: colorProv.colors.innerBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              key: GlobalKeys.showcaseKeyLGconnectionIndicator,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      // 'LG Rig',
                      AppLocalizations.of(context)!.appBar_Lgrig,
                      style: TextStyle(
                          fontFamily: fontType,
                          fontSize: fontsProv.fonts.textSize - 5,
                          color: fontsProv.fonts.primaryFontColor),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: connection.isLgConnected
                      ? LgAppColors.lgColor4
                      : LgAppColors.lgColor2,
                  radius: 10,
                ),
                //Localllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll
                // Flexible(
                //   child: FittedBox(
                //     fit: BoxFit.scaleDown,
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       'AI Server',
                //       style: TextStyle(
                //           fontFamily: fontType,
                //           // fontSize: textSize - 5
                //           fontSize: fontsProv.fonts.textSize - 5,
                //           color: fontsProv.fonts.primaryFontColor),
                //     ),
                //   ),
                // ),
                // CircleAvatar(
                //   backgroundColor: connection.isAiConnected
                //       ? LgAppColors.lgColor4
                //       : LgAppColors.lgColor2,
                //   radius: 10,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
