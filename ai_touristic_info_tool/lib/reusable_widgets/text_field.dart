import 'package:flutter/material.dart';

import '../constants.dart';

/// A custom [TextFormField] widget that can be used to input text with validation.

class TextFormFieldWidget extends StatelessWidget {
  /// Creates a new instance of [TextFormFieldWidget].
  ///
  /// * [textController] - A [TextEditingController] to display the text the user enters
  /// * [label] - A [String] to show as the label for the text field.
  /// * [hint] - A [String] to show as the hint for the text field.
  /// * [onChanged] - An optional callback function that might be needed in some textfields to display something in the same page
  /// * [maxlines]  - an optional maxlines of type [int]
  /// * [maxLength] - an optional maxlength of type [int]
  /// * [isPrefixIconrequired] -an optional [bool] to check if a prefix icon is required for that field
  /// * [prefixIcon]  - an optional prefix icon
  /// * [isSuffixRequired] - to check if the field is required or not to display a red (*)
  /// * [enabled] - optional enabled to check if the textfield will be enabled or not
  /// *[onEditingComplete] -optional callback function to be called when we want to do something when user finish editing the field
  ///  `fontSize` for the responsive layout

  const TextFormFieldWidget({
    super.key,
    required TextEditingController textController,
    String? label,
    String? hint,
    required bool? isSuffixRequired,
    int? maxLength,
    int? maxlines,
    bool? isPrefixIconrequired,
    Icon? prefixIcon,
    bool? enabled,
    bool? isHidden,
    required this.width,
    this.onChanged,
    this.onEditingComplete,
    required this.fontSize,
    this.fillColor,
  })  : _textController = textController,
        _label = label,
        _hint = hint,
        _isSuffixRequired = isSuffixRequired,
        _maxLength = maxLength,
        _maxlines = maxlines,
        _isPrefixIconRequired = isPrefixIconrequired,
        _prefixIcon = prefixIcon,
        _enabled = enabled,
        _isHidden = isHidden;

  final TextEditingController _textController;
  final String? _label;
  final String? _hint;
  final bool? _isSuffixRequired;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final int? _maxLength;
  final int? _maxlines;
  final bool? _isPrefixIconRequired;
  final Icon? _prefixIcon;
  final bool? _enabled;
  final bool? _isHidden;
  final double fontSize;
  final Color? fillColor;
  final double width;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        autofocus: true,
        enabled: _enabled,
        controller: _textController,
        maxLength: _maxLength,
        maxLines: _maxlines,
        obscureText: _isHidden!,
        decoration: InputDecoration(
          labelText: _label,
          labelStyle: TextStyle(
            fontSize: textSize + 4,
            fontFamily: fontType,
            fontWeight: FontWeight.bold,
            color: FontAppColors.primaryFont,
          ),
          hintText: _hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 5.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: PrimaryAppColors.buttonColors,
              width: 3.0,
            ),
          ),
          filled: true,
          fillColor: fillColor ?? PrimaryAppColors.innerBackground,
          suffixIcon: _isSuffixRequired!
              ? const Text(
                  '*',
                  style: TextStyle(
                      color: LgAppColors.lgColor2, fontSize: textSize),
                )
              : null,
          prefixIcon: _isPrefixIconRequired ?? false ? _prefixIcon : null,
        ),
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.black,
          fontFamily: fontType,
          fontSize: fontSize,
        ),
        onEditingComplete: onEditingComplete,
        validator: (value) {
          if (_isSuffixRequired == true) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
