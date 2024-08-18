import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A custom [TextFormField] widget that can be used to input text with validation.

class TextFormFieldWidget extends StatefulWidget {
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
    required bool isPassword,
    int? maxLength,
    int? maxlines,
    bool? isPrefixIconrequired,
    Icon? prefixIcon,
    bool? enabled,
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
        _isPassword = isPassword;

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
  final double fontSize;
  final Color? fillColor;
  final double width;
  final bool _isPassword;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider value,
            FontsProvider fontProv, Widget? child) {
          return TextFormField(
            autofocus: true,
            enabled: widget._enabled,
            controller: widget._textController,
            maxLength: widget._maxLength,
            maxLines: widget._maxlines,
            obscureText: widget._isPassword && _isHidden,
            decoration: InputDecoration(
              labelText: widget._label,
              labelStyle: TextStyle(
                fontSize: fontProv.fonts.textSize + 2,
                fontFamily: fontType,
                color: fontProv.fonts.primaryFontColor,
              ),
              hintText: widget._hint,
              hintStyle: TextStyle(
                fontSize: fontProv.fonts.textSize,
                fontFamily: fontType,
                color: fontProv.fonts.primaryFontColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: fontProv.fonts.primaryFontColor,
                  width: 5.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: value.colors.buttonColors,
                  width: 3.0,
                ),
              ),
              filled: true,
              fillColor: widget.fillColor ?? value.colors.innerBackground,
              suffixIcon: (widget._isSuffixRequired! && widget._isPassword)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isHidden
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: LgAppColors.lgColor2,
                            fontSize: textSize,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03),
                      ],
                    )
                  : (widget._isSuffixRequired! && !widget._isPassword)
                      ? const Text(
                          '*',
                          style: TextStyle(
                            color: LgAppColors.lgColor2,
                            fontSize: textSize,
                          ),
                        )
                      : null,
              prefixIcon: widget._isPrefixIconRequired ?? false
                  ? widget._prefixIcon
                  : null,
            ),
            onChanged: widget.onChanged,
            style: TextStyle(
              color: fontProv.fonts.primaryFontColor,
              fontFamily: fontType,
              fontSize: widget.fontSize,
            ),
            onEditingComplete: widget.onEditingComplete,
            validator: (value) {
              if (widget._isSuffixRequired == true) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.textfield_error;
                }
                return null;
              } else {
                return null;
              }
            },
          );
        },
      ),
    );
  }
}
