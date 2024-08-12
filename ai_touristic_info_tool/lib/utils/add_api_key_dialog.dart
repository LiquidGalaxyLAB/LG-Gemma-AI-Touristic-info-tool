import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/drop_down_list_component.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<dynamic> addAPIKeyDialog(
    BuildContext context,
    ColorProvider colorProv,
    GlobalKey<FormState> _formKey,
    FontsProvider fontProv,
    TextEditingController _keyNameController,
    TextEditingController _keyValueController) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      bool nameExists = false;
      final _serviceController = TextEditingController(text: keyServicesAPI[0]);
      String? _chosenService;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          int serviceIndex = keyServicesAPI.indexOf(_serviceController.text);
          return AlertDialog(
            backgroundColor: colorProv.colors.innerBackground,
            content: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        // 'Choose a name for your Key:',
                        AppLocalizations.of(context)!.settings_addApiKeyName,
                          style: TextStyle(
                              color: fontProv.fonts.primaryFontColor,
                              fontSize: fontProv.fonts.textSize,
                              fontFamily: fontType)),
                      Center(
                        child: TextFormFieldWidget(
                          // fontSize: textSize,
                          fontSize: fontProv.fonts.textSize,
                          key: const ValueKey("key-name"),
                          textController: _keyNameController,
                          isSuffixRequired: true,

                          isPassword: false,
                          maxLength: 100,
                          maxlines: 1,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                          onChanged: (value) {
                            setState(() {
                              nameExists = false;
                            });
                          },
                        ),
                      ),
                      if (nameExists)
                        Text(
                          // 'Name already exists',
                          AppLocalizations.of(context)!.settings_nameExist,
                            style: TextStyle(
                                color: LgAppColors.lgColor2,
                                fontSize: fontProv.fonts.textSize,
                                fontFamily: fontType)),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      // ),
                      Text(
                        // 'Enter your key:',
                        AppLocalizations.of(context)!.settings_enterKey,
                          style: TextStyle(
                              color: fontProv.fonts.primaryFontColor,
                              fontSize: fontProv.fonts.textSize,
                              fontFamily: fontType)),
                      Center(
                        child: TextFormFieldWidget(
                          // fontSize: textSize,
                          fontSize: fontProv.fonts.textSize,
                          key: const ValueKey("key-value"),
                          textController: _keyValueController,
                          isSuffixRequired: true,
                          isPassword: true,
                          maxLength: 100,
                          maxlines: 1,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                        ),
                      ),
                      Text(
                        // 'Choose the API Key service type',
                        AppLocalizations.of(context)!.settings_chooseServiceAPI,
                          style: TextStyle(
                              color: fontProv.fonts.primaryFontColor,
                              fontSize: fontProv.fonts.textSize,
                              fontFamily: fontType)),

                      DropDownListWidget(
                        key: const ValueKey("APIservices"),
                        items: keyServicesAPI,
                        fontSize: fontProv.fonts.textSize,
                        selectedValue: keyServicesAPI != -1
                            ? keyServicesAPI[serviceIndex]
                            : countries[0],
                        hinttext: 'API Services',
                        onChanged: (value) {
                          setState(() {
                            _serviceController.text = value;
                            _chosenService = value;
                            print(_chosenService);
                          });
                        },
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
                    print(nameExists);
                    List<ApiKeyModel> keys =
                        await APIKeySharedPref.getApiKeys();

                    if (keys.length > 0) {
                      for (int i = 0; i < keys.length; i++) {
                        if (keys[i].name == _keyNameController.text) {
                          setState(() {
                            nameExists = true;
                          });
                        } else {
                          setState(() {
                            nameExists = false;
                          });
                        }
                      }
                    }
                    if (!nameExists) {
                      if (keys.length == 0) {
                        await APIKeySharedPref.addApiKey(ApiKeyModel(
                            name: _keyNameController.text,
                            key: _keyValueController.text,
                            serviceType: _chosenService ?? keyServicesAPI[0],
                            isDefault: true));
                      } else {
                        await APIKeySharedPref.addApiKey(ApiKeyModel(
                          name: _keyNameController.text,
                          key: _keyValueController.text,
                          serviceType: _chosenService ?? keyServicesAPI[0],
                        ));
                      }

                      print('added');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: LgAppColors.lgColor4,
                            content: Text(
                              // 'API Key added. Please refresh your API keys',
                              AppLocalizations.of(context)!.settings_apiKeyAddedNotification,
                              style: TextStyle(
                                fontSize: fontProv.fonts.textSize,
                                color: Colors.white,
                                fontFamily: fontType,
                              ),
                            )),
                      );
                      Navigator.of(context).pop();
                    }
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
