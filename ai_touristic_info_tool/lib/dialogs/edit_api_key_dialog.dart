import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Displays a dialog for editing an API key.
///
/// This function presents an `AlertDialog` where the user can edit the value of an API key.
/// It includes a text field for input, pre-populated with the current API key value.
/// The dialog's appearance is dynamically styled based on the provided `ColorProvider`
/// and `FontsProvider`, and it supports localization through `AppLocalizations`.
///
/// [context] - The `BuildContext` used to locate the `ColorProvider` and `FontsProvider`.
/// [colorProv] - The `ColorProvider` used to style the dialog's background color.
/// [_formKey] - A `GlobalKey<FormState>` used for form validation.
/// [fontProv] - The `FontsProvider` used to style text and form elements.
/// [apiKeyName] - The name of the API key being edited.
/// [apiKeyValue] - The current value of the API key, used to pre-populate the text field.
/// [serviceType] - The type of service associated with the API key.
///
/// The dialog includes:
/// - A title displaying the API key name and service type.
/// - A text field for entering the new API key value.
/// - Two buttons: one for saving the changes and one for canceling.
///
/// The `editAPIKeyDialog` function performs the following actions:
/// - Validates the input when the "Done" button is pressed.
/// - Updates the API key value using `APIKeySharedPref.editApiKey`.
/// - Shows a `SnackBar` notification upon successful update.
/// - Closes the dialog upon successful update or when the "Cancel" button is pressed
/// 


Future<dynamic> editAPIKeyDialog(
  BuildContext context,
  ColorProvider colorProv,
  GlobalKey<FormState> _formKey,
  FontsProvider fontProv,
  String apiKeyName,
  String apiKeyValue,
  String serviceType,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          TextEditingController _keyValueController =
              TextEditingController(text: apiKeyValue);
          return AlertDialog(
            backgroundColor: colorProv.colors.innerBackground,
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('$apiKeyName - $serviceType',
                          style: TextStyle(
                              color: fontProv.fonts.primaryFontColor,
                              fontSize: fontProv.fonts.textSize,
                              fontFamily: fontType)),
                      Center(
                        child: TextFormFieldWidget(
                          fontSize: fontProv.fonts.textSize,
                          key: const ValueKey("key-value-edit"),
                          textController: _keyValueController,
                          isSuffixRequired: true,
                          isPassword: true,
                          maxLength: 100,
                          maxlines: 1,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await APIKeySharedPref.editApiKey(
                      apiKeyName,
                      _keyValueController.text,
                      serviceType,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: LgAppColors.lgColor4,
                          content: Text(
                            AppLocalizations.of(context)!.settings_apiKeyEditedNotification,
                            style: TextStyle(
                              fontSize: fontProv.fonts.textSize,
                              color: Colors.white,
                              fontFamily: fontType,
                            ),
                          )),
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.defaults_done,
                    style: TextStyle(
                        color: LgAppColors.lgColor4,
                        fontSize: fontProv.fonts.textSize,
                        fontFamily: fontType)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.defaults_cancel,
                    style: TextStyle(
                        color: LgAppColors.lgColor2,
                        fontSize: fontProv.fonts.textSize,
                        fontFamily: fontType)),
              ),
            ],
          );
        },
      );
    },
  );
}
