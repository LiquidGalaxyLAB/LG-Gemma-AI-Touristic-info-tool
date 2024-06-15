
import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/state_management/map_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapTypeChoicesWidget extends StatelessWidget {
  const MapTypeChoicesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MapTypeProvider>(
      builder:
          (BuildContext context, MapTypeProvider value, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
            ),
            Text(
              'Satellite',
              style: TextStyle(fontFamily: fontType, fontSize: textSize),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            GestureDetector(
              onTap: () => value.currentView = 'satellite',
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: value.currentView == 'satellite'
                      ? PrimaryAppColors.buttonColors
                      : FontAppColors.secondaryFont,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    width: 3,
                    color: value.currentView == 'satellite'
                        ? FontAppColors.secondaryFont
                        : PrimaryAppColors.buttonColors,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              'Normal',
              style: TextStyle(fontFamily: fontType, fontSize: textSize),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            GestureDetector(
              onTap: () => value.currentView = 'normal',
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: value.currentView == 'normal'
                      ? PrimaryAppColors.buttonColors
                      : FontAppColors.secondaryFont,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    width: 3,
                    color: value.currentView == 'normal'
                        ? FontAppColors.secondaryFont
                        : PrimaryAppColors.buttonColors,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              'Terrain',
              style: TextStyle(fontFamily: fontType, fontSize: textSize),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            GestureDetector(
              onTap: () => value.currentView = 'terrain',
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: value.currentView == 'terrain'
                      ? PrimaryAppColors.buttonColors
                      : FontAppColors.secondaryFont,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    width: 3,
                    color: value.currentView == 'terrain'
                        ? FontAppColors.secondaryFont
                        : PrimaryAppColors.buttonColors,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
          ],
        );
      },
    );
  }
}