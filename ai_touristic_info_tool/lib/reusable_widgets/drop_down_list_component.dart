import 'package:ai_touristic_info_tool/state_management/drop_down_state.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../utils/build_drop_menu_items.dart';

/// A custom [DropDownListWidget]  that displays a dropdown list with provided [items]
///
/// The dropdown widget is built using [DropdownButtonFormField] and is wrapped in a [Consumer] widget that listens to changes in the [DropdownState] object.
///
/// The selected item is determined by the [selectedIndex] property of the [DropdownState] object.
///
/// The selected item is managed by a [DropdownState] instance.
///
/// The items in the dropdown list are generated from the `items` list provided to the widget.
///
///we have: * [items] : A list of items to be displayed in the dropdown list.
///         * [prefixIcon] : An optional icon to be displayed as a prefix in the input field.
///         * [selectedValue] : the currently selected item in the dropdown list
///         * [hinttext] :for hints
///         * [onChanged] : A callback function that will be called whenever the selected item changes.

class DropDownListWidget extends StatelessWidget {
  /// A list of items to be displayed in the dropdown list.
  final List<String> items;

  /// An optional icon to be displayed as a prefix in the input field.
  final Widget? prefixIcon;

  /// The currently selected item in the dropdown list.
  final String? selectedValue;

  ///For hint text"
  final String? hinttext;

  final double fontSize;

  /// A callback function that will be called whenever the selected item changes.
  final void Function(String)? onChanged;

  /// Creates a new instance of [DropDownListWidget].
  /// The [items] parameter is required.
  const DropDownListWidget({
    Key? key,
    required this.items,
    this.prefixIcon,
    this.selectedValue,
    this.hinttext,
    this.onChanged,
    required this.fontSize,
  }) : super(key: key);

  @override
  Key? get key => super.key;

  @override
  Widget build(BuildContext context) {
    return Consumer3<DropdownState, ColorProvider, FontsProvider>(
      key: key,
      builder: (BuildContext context,
              DropdownState state,
              ColorProvider colorProv,
              FontsProvider fontsProv,
              Widget? child) =>
          Container(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 10.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colorProv.colors.buttonColors,
                width: 5.0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            prefixIcon: prefixIcon,
            hintText: hinttext,
            fillColor: colorProv.colors.innerBackground,
            filled: true,
          ),
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: colorProv.colors.buttonColors,
            size: 36,
          ),
          items: items.map((String item) {
            return buildMenuItem(item, fontSize);
          }).toList(),
          value: selectedValue ?? items[0],
          onChanged: (value) {
            // ignore: unused_local_variable
            int index = state.selectedIndex = items.indexOf(value!);
            // ignore: unused_local_variable
            int length = items.length;
            onChanged?.call(value);
          },
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: fontType,
              textBaseline: TextBaseline.alphabetic),
          dropdownColor: colorProv.colors.innerBackground,
          validator: (value) {
            if (value == null || value == 'None') {
              return 'Please select an item';
            }
            return null;
          },
          
        ),
      
      ),
    );
  }
}
