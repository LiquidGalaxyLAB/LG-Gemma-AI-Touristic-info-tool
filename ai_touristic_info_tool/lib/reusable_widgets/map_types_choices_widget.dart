import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/map_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapTypeChoicesWidget extends StatelessWidget {
  const MapTypeChoicesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<MapTypeProvider, ColorProvider>(
      builder: (BuildContext context, MapTypeProvider value,
          ColorProvider colorProv, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Satellite',
              style: TextStyle(fontFamily: fontType, fontSize: textSize),
            ),
            GestureDetector(
              onTap: () => value.currentView = 'satellite',
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  // color: value.currentView == 'satellite'
                  //     ? PrimaryAppColors.buttonColors
                  //     : FontAppColors.secondaryFont,
                  color: value.currentView == 'satellite'
                      ? colorProv.colors.buttonColors
                      : FontAppColors.secondaryFont,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    width: 3,
                    // color: value.currentView == 'satellite'
                    //     ? FontAppColors.secondaryFont
                    //     : PrimaryAppColors.buttonColors,
                    color: value.currentView == 'satellite'
                        ? FontAppColors.secondaryFont
                        : colorProv.colors.buttonColors,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            Text(
              'Normal',
              style: TextStyle(fontFamily: fontType, fontSize: textSize),
            ),
            GestureDetector(
              onTap: () => value.currentView = 'normal',
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  // color: value.currentView == 'normal'
                  //     ? PrimaryAppColors.buttonColors
                  //     : FontAppColors.secondaryFont,
                  color: value.currentView == 'normal'
                      ? colorProv.colors.buttonColors
                      : FontAppColors.secondaryFont,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    width: 3,
                    // color: value.currentView == 'normal'
                    //     ? FontAppColors.secondaryFont
                    //     : PrimaryAppColors.buttonColors,
                    color: value.currentView == 'normal'
                        ? FontAppColors.secondaryFont
                        : colorProv.colors.buttonColors,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            Text(
              'Terrain',
              style: TextStyle(fontFamily: fontType, fontSize: textSize),
            ),
            GestureDetector(
              onTap: () => value.currentView = 'terrain',
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  // color: value.currentView == 'terrain'
                  //     ? PrimaryAppColors.buttonColors
                  //     : FontAppColors.secondaryFont,
                  color: value.currentView == 'terrain'
                      ? colorProv.colors.buttonColors
                      : FontAppColors.secondaryFont,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    width: 3,
                    // color: value.currentView == 'terrain'
                    //     ? FontAppColors.secondaryFont
                    //     : PrimaryAppColors.buttonColors,
                    color: value.currentView == 'terrain'
                        ? FontAppColors.secondaryFont
                        : colorProv.colors.buttonColors,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
