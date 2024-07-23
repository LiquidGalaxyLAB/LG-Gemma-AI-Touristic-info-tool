import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// a function for building the menu item in a dropdown menu with a customized `fontSize` and  `item`
DropdownMenuItem<String> buildMenuItem(String item, double fontSize) =>
    DropdownMenuItem(
        value: item,
        child: Consumer<FontsProvider>(
          builder: (BuildContext context, FontsProvider value, Widget? child) {
            return Text(
              item,
              style: TextStyle(
                // fontSize: fontSize,
                color: value.fonts.primaryFontColor,
              ),
            );
          },
        ));
