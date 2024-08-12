import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                          // fontSize: textSize,
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
                            // 'API Key edited. Please refresh your API keys',
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
                  // 'DONE',
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
                  // 'CANCEL',
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
