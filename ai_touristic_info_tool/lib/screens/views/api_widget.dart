import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/add_api_key_dialog.dart';
import 'package:ai_touristic_info_tool/dialogs/edit_api_key_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class APIWidget extends StatefulWidget {
  const APIWidget({super.key});

  @override
  State<APIWidget> createState() => _APIWidgetState();
}

class _APIWidgetState extends State<APIWidget> {
  final ScrollController _scrollController = ScrollController();
  final _formKeyAddKey = GlobalKey<FormState>();
  final _formKeyEditKey = GlobalKey<FormState>();
  final TextEditingController _keyNameController = TextEditingController();
  final TextEditingController _keyValueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontProv,
          ColorProvider colorProv, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Center(
                  child: Text(
                    // 'API Keys Settings',
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!.settings_apiKeySettings,
                    style: TextStyle(
                      fontSize: fontProv.fonts.headingSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontType,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // 'Your Saved API Keys:',
                      AppLocalizations.of(context)!.settings_apiKeySavedAPIKey,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: fontProv.fonts.textSize,
                        color: Colors.black,
                        fontFamily: fontType,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: colorProv.colors.buttonColors,
                            radius: 20,
                            child: Icon(
                              CupertinoIcons.refresh,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          // Text('refresh')
                          Text(AppLocalizations.of(context)!.settings_Refresh)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10, top: 5),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: colorProv.colors.darkShadow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RawScrollbar(
                    controller: _scrollController,
                    trackVisibility: true,
                    thumbVisibility: true,
                    thickness: 10,
                    trackColor: colorProv.colors.buttonColors,
                    thumbColor: Colors.white,
                    radius: const Radius.circular(10),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          getSavedAPIKeysWidget(
                            context,
                            _formKeyEditKey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: LgElevatedButton(
                    // elevatedButtonContent: 'Add Key',
                    elevatedButtonContent:
                        AppLocalizations.of(context)!.settings_AddKey,
                    buttonColor: colorProv.colors.buttonColors,
                    onpressed: () async {
                      await addAPIKeyDialog(context, colorProv, _formKeyAddKey,
                          fontProv, _keyNameController, _keyValueController);
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.18,
                    fontSize: fontProv.fonts.textSize,
                    fontColor: Colors.white,
                    isLoading: false,
                    isBold: false,
                    isPrefixIcon: true,
                    isSuffixIcon: false,
                    curvatureRadius: 30,
                    prefixIcon: Icons.key,
                    prefixIconColor: Colors.white,
                    prefixIconSize: 30,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget getSavedAPIKeysWidget(
  BuildContext context,
  GlobalKey<FormState> formKey,
) {
  return Consumer2<FontsProvider, ColorProvider>(
    builder: (BuildContext context, FontsProvider fontProv,
        ColorProvider colorProv, Widget? child) {
      return FutureBuilder<List<ApiKeyModel>>(
        future: APIKeySharedPref.getApiKeys(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ApiKeyModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              // 'Error: ${snapshot.error}',
              AppLocalizations.of(context)!
                  .settings_errorSnapshot(snapshot.error.toString()),
              style: TextStyle(
                fontSize: fontProv.fonts.textSize,
                color: Colors.black,
                fontFamily: fontType,
              ),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              // 'No API Keys Found',
              AppLocalizations.of(context)!.settings_noApiKeyFound,
              style: TextStyle(
                fontSize: fontProv.fonts.textSize,
                color: Colors.black,
                fontFamily: fontType,
              ),
            ));
          } else {
            List<ApiKeyModel> apiKeys = snapshot.data!;

            Map<String, List<ApiKeyModel>> groupedApiKeys = {};
            for (var apiKey in apiKeys) {
              if (groupedApiKeys.containsKey(apiKey.serviceType)) {
                groupedApiKeys[apiKey.serviceType]!.add(apiKey);
              } else {
                groupedApiKeys[apiKey.serviceType] = [apiKey];
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: groupedApiKeys.entries.map((service) {
                  String serviceType = service.key;
                  List<ApiKeyModel> serviceApiKeys = service.value;

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: colorProv.colors.shadow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceType,
                          style: TextStyle(
                            fontSize: fontProv.fonts.textSize + 2,
                            color: Colors.black,
                            fontFamily: fontType,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Column(
                          children: serviceApiKeys.map((apiKey) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      apiKey.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: fontProv.fonts.textSize,
                                        color: Colors.black,
                                        fontFamily: fontType,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(CupertinoIcons.eye, size: 30),
                                  onPressed: () async {
                                    await editAPIKeyDialog(
                                      context,
                                      colorProv,
                                      formKey,
                                      fontProv,
                                      apiKey.name,
                                      apiKey.key,
                                      apiKey.serviceType,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(CupertinoIcons.delete, size: 30),
                                  onPressed: () async {
                                    await APIKeySharedPref.removeApiKey(
                                        apiKey.name, serviceType);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: LgAppColors.lgColor4,
                                          content: Text(
                                            // 'API Key deleted. Please refresh your API keys',
                                            AppLocalizations.of(context)!
                                                .settings_apiKeyDeleteNotification,
                                            style: TextStyle(
                                              fontSize: fontProv.fonts.textSize,
                                              color: Colors.white,
                                              fontFamily: fontType,
                                            ),
                                          )),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                      apiKey.isDefault
                                          ? CupertinoIcons.star_fill
                                          : CupertinoIcons.star,
                                      size: 30,
                                      color: apiKey.isDefault
                                          ? LgAppColors.lgColor3
                                          : Colors.grey),
                                  onPressed: () async {
                                    await APIKeySharedPref.saveDefaultApiKey(
                                        serviceType, apiKey.name);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: LgAppColors.lgColor4,
                                          content: Text(
                                            // 'API Key is set as default. Please refresh your API keys',
                                            AppLocalizations.of(context)!
                                                .settings_apiKeySetDefaultNotification,
                                            style: TextStyle(
                                              fontSize: fontProv.fonts.textSize,
                                              color: Colors.white,
                                              fontFamily: fontType,
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      );
    },
  );
}
