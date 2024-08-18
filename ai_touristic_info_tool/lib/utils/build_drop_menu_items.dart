import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// This function creates a `DropdownMenuItem` widget for use in a dropdown menu.
/// Each menu item is built using the provided `item` string and the `fontSize`.
/// The text color for the item is dynamically set based on the current font
/// settings from the `FontsProvider` state management.
///
/// Parameters:
/// - `item`: The string value that will be displayed in the dropdown menu item.
/// - `fontSize`: The font size to be used for the text in the dropdown menu item.
///
/// Returns:
/// - A `DropdownMenuItem<String>` widget with the specified `item` value and text style.

DropdownMenuItem<String> buildMenuItem(String item, double fontSize) =>
    DropdownMenuItem(
        value: item,
        child: Consumer<FontsProvider>(
          builder: (BuildContext context, FontsProvider value, Widget? child) {
            return Text(
              item,
              style: TextStyle(
                color: value.fonts.primaryFontColor,
              ),
            );
          },
        ));
