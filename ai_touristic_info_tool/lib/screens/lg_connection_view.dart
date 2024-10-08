import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../helpers/lg_connection_shared_pref.dart';
import '../services/lg_functionalities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectionView extends StatefulWidget {
  const ConnectionView({super.key});

  @override
  State<ConnectionView> createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  /// `form key` for our configuration form
  final _form1Key = GlobalKey<FormState>();
  // final _form2Key = GlobalKey<FormState>();

  /// `is loading` to Track the loading state
  bool _isLoading1 = false;
  // bool _isLoading2 = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _ipController =
      TextEditingController(text: LgConnectionSharedPref.getIP());
  final TextEditingController _portController =
      TextEditingController(text: LgConnectionSharedPref.getPort() ?? '22');
  final TextEditingController _userNameController =
      TextEditingController(text: LgConnectionSharedPref.getUserName());
  final TextEditingController _passwordController =
      TextEditingController(text: LgConnectionSharedPref.getPassword());
  final TextEditingController _screenAmountController = TextEditingController(
      text: LgConnectionSharedPref.getScreenAmount().toString() == 'null'
          ? '3'
          : LgConnectionSharedPref.getScreenAmount().toString());

  // final TextEditingController _aiIpAddressController =
  //     TextEditingController(text: LgConnectionSharedPref.getAiIp());
  // final TextEditingController _aiPortController =
  //     TextEditingController(text: LgConnectionSharedPref.getAiPort());

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider, FontsProvider>(builder:
        (BuildContext context, ColorProvider value, FontsProvider fontProv,
            Widget? child) {
      return RawScrollbar(
        controller: _scrollController,
        trackVisibility: true,
        thumbVisibility: true,
        thickness: 10,
        trackColor: value.colors.buttonColors,
        thumbColor: Colors.white,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Consumer<Connectionprovider>(
            builder: (BuildContext context, model, Widget? child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      TopBarWidget(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 1,
                        grad1: SettingsSharedPref.getTheme() == 'light'
                            ? value.colors.buttonColors
                            : value.colors.gradient1,
                        grad2: SettingsSharedPref.getTheme() == 'light'
                            ? value.colors.buttonColors
                            : value.colors.gradient2,
                        grad3: SettingsSharedPref.getTheme() == 'light'
                            ? value.colors.buttonColors
                            : value.colors.gradient3,
                        grad4: SettingsSharedPref.getTheme() == 'light'
                            ? value.colors.buttonColors
                            : value.colors.gradient4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/connection.png",
                              width: MediaQuery.of(context).size.width * 0.05,
                              height: MediaQuery.of(context).size.height * 0.05,
                              color: FontAppColors.secondaryFont,
                            ),
                            Center(
                              child: Text(
                                // 'Liquid Galaxy Connection Manager',
                                AppLocalizations.of(context)!
                                    .lgConnection_title,
                                style: TextStyle(
                                  fontFamily: fontType,
                                  fontSize: fontProv.fonts.headingSize,
                                  color: SettingsSharedPref.getTheme() == 'dark'
                                      ? fontProv.fonts.primaryFontColor
                                      : fontProv.fonts.secondaryFontColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Consumer<FontsProvider>(
                        builder: (BuildContext context, FontsProvider value,
                            Widget? child) {
                          return Text(
                            // 'LG Connection',
                            AppLocalizations.of(context)!.lgConnection_subtitle,
                            style: TextStyle(
                              fontFamily: fontType,
                              fontSize: value.fonts.headingSize - 8,
                              color: value.fonts.primaryFontColor,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),

                      Consumer<FontsProvider>(
                        builder: (BuildContext context, FontsProvider value,
                            Widget? child) {
                          return Form(
                            key: _form1Key,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormFieldWidget(
                                        key: GlobalKeys
                                            .showcaseKeyConnectionUsername,
                                        fontSize: value.fonts.textSize,
                                        label: AppLocalizations.of(context)!
                                            .lgConnection_userName,
                                        textController: _userNameController,
                                        isSuffixRequired: true,
                                        isPassword: false,
                                        maxLength: 50,
                                        maxlines: 1,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormFieldWidget(
                                        key: GlobalKeys
                                            .showcaseKeyConnectionPassword,
                                        isPassword: true,
                                        fontSize: value.fonts.textSize,
                                        // label: 'LG Password',
                                        label: AppLocalizations.of(context)!
                                            .lgConnection_password,

                                        textController: _passwordController,
                                        isSuffixRequired: true,

                                        maxLength: 50,
                                        maxlines: 1,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormFieldWidget(
                                        key: GlobalKeys.showcaseKeyConnectionIP,

                                        fontSize: value.fonts.textSize,
                                        // label: 'LG Master IP Address',
                                        label: AppLocalizations.of(context)!
                                            .lgConnection_ip,

                                        textController: _ipController,
                                        isSuffixRequired: true,

                                        isPassword: false,
                                        maxLength: 50,
                                        maxlines: 1,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormFieldWidget(
                                        key: GlobalKeys
                                            .showcaseKeyConnectionPort,

                                        fontSize: value.fonts.textSize,
                                        // label: 'LG Port Number',
                                        label: AppLocalizations.of(context)!
                                            .lgConnection_port,

                                        textController: _portController,
                                        isSuffixRequired: true,

                                        isPassword: false,
                                        maxLength: 50,
                                        maxlines: 1,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormFieldWidget(
                                        key: GlobalKeys
                                            .showcaseKeyConnectionNumScreens,

                                        fontSize: value.fonts.textSize,
                                        // label: 'Number of LG screens',
                                        label: AppLocalizations.of(context)!
                                            .lgConnection_numScreens,

                                        textController: _screenAmountController,
                                        isSuffixRequired: true,

                                        isPassword: false,
                                        maxLength: 50,
                                        maxlines: 1,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                AppDividerWidget(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                ),
                                // Consumer<Connectionprovider>(
                                //   builder: (BuildContext context,
                                //       Connectionprovider conn, Widget? child) {
                                //     // if (!conn.isLgConnected) {
                                //       return
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    LgElevatedButton(
                                      key: GlobalKeys
                                          .showcaseKeyConnectionConnect,
                                      // elevatedButtonContent: 'CONNECT LG',
                                      elevatedButtonContent:
                                          AppLocalizations.of(context)!
                                              .lgConnection_connect,
                                      buttonColor: LgAppColors.lgColor4,
                                      fontColor: FontAppColors.secondaryFont,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,

                                      fontSize: value.fonts.textSize + 2,
                                      isLoading: false,
                                      isBold: true,
                                      isPrefixIcon: true,
                                      prefixIcon: Icons.cast_connected,
                                      prefixIconColor:
                                          FontAppColors.secondaryFont,
                                      prefixIconSize: 30,
                                      isSuffixIcon: false,
                                      curvatureRadius: 50,
                                      onpressed: () async {
                                        /// checking first if form is valid
                                        if (_form1Key.currentState!
                                            .validate()) {
                                          //saving date in shared pref
                                          await LgConnectionSharedPref
                                              .setUserName(
                                                  _userNameController.text);
                                          await LgConnectionSharedPref.setIP(
                                              _ipController.text);
                                          await LgConnectionSharedPref
                                              .setPassword(
                                                  _passwordController.text);
                                          await LgConnectionSharedPref.setPort(
                                              _portController.text);
                                          await LgConnectionSharedPref
                                              .setScreenAmount(int.parse(
                                                  _screenAmountController
                                                      .text));
                                        }

                                        final sshData =
                                            Provider.of<SSHprovider>(context,
                                                listen: false);

                                        ///start the loading process by setting `isloading` to true
                                        if (mounted) {
                                          setState(() {
                                            _isLoading1 = true;
                                          });
                                        }

                                        /// Call the init function to set up the SSH client with the connection data
                                        String? result =
                                            await sshData.init(context);

                                        Connectionprovider connection =
                                            Provider.of<Connectionprovider>(
                                                context,
                                                listen: false);

                                        ///checking on the connection status:
                                        if (result == '') {
                                          connection.isLgConnected = true;

                                          ///If connected, the logos should appear by calling `setLogos` from the `LGService` calss
                                          await LgService(sshData).setLogos();
                                          await buildAppBalloonOverlay(context);
                                          //show snackbar that its connected:
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                // 'You are now connected to the Liquid Galaxy successfully!',
                                                AppLocalizations.of(context)!
                                                    .lgConnection_success,
                                                style: TextStyle(
                                                    fontFamily: fontType,
                                                    fontSize:
                                                        fontProv.fonts.textSize,
                                                    color: Colors.white),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor:
                                                  LgAppColors.lgColor4,
                                            ),
                                          );
                                        } else {
                                          connection.isLgConnected = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                result!,
                                                style: TextStyle(
                                                    fontFamily: fontType,
                                                    fontSize:
                                                        fontProv.fonts.textSize,
                                                    color: Colors.white),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor:
                                                  LgAppColors.lgColor2,
                                            ),
                                          );
                                        }

                                        ///stop the loading process by setting `isloading` to false
                                        if (mounted) {
                                          setState(() {
                                            _isLoading1 = false;
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                    ),
                                    LgElevatedButton(
                                      // elevatedButtonContent: 'DISCONNECT LG',
                                      elevatedButtonContent:
                                          AppLocalizations.of(context)!
                                              .lgConnection_disconnect,
                                      buttonColor: LgAppColors.lgColor2,
                                      fontColor: FontAppColors.secondaryFont,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,

                                      fontSize: value.fonts.textSize + 2,
                                      isLoading: false,
                                      isBold: true,
                                      isPrefixIcon: true,
                                      prefixIcon: Icons
                                          .signal_wifi_connected_no_internet_4,
                                      prefixIconColor:
                                          FontAppColors.secondaryFont,
                                      prefixIconSize: 30,
                                      isSuffixIcon: false,
                                      curvatureRadius: 50,
                                      onpressed: () async {
                                        final sshData =
                                            Provider.of<SSHprovider>(context,
                                                listen: false);
                                        Connectionprovider connection =
                                            Provider.of<Connectionprovider>(
                                                context,
                                                listen: false);
                                        dialogBuilder(
                                            context,
                                            // 'Are you sure you want to disconnect?',
                                            AppLocalizations.of(context)!
                                                .lgConnection_confirmDisconnect,
                                            false,
                                            // 'YES'
                                            AppLocalizations.of(context)!
                                                .defaults_yes, () {
                                          if (connection.isLgConnected) {
                                            sshData.disconnect();
                                            connection.isLgConnected = false;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  // 'You are now disconnected from the Liquid Galaxy!',
                                                  AppLocalizations.of(context)!
                                                      .lgConnection_disconnectMsg,
                                                  style: TextStyle(
                                                      fontFamily: fontType,
                                                      fontSize: fontProv
                                                          .fonts.textSize,
                                                      color: Colors.white),
                                                ),
                                                duration:
                                                    const Duration(seconds: 3),
                                                backgroundColor:
                                                    LgAppColors.lgColor4,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  // 'You are already disconnected!',
                                                  AppLocalizations.of(context)!
                                                      .lgConnection_errorDisconnect,
                                                  style: TextStyle(
                                                      fontFamily: fontType,
                                                      fontSize: fontProv
                                                          .fonts.textSize,
                                                      color: Colors.white),
                                                ),
                                                duration:
                                                    const Duration(seconds: 3),
                                                backgroundColor:
                                                    LgAppColors.lgColor2,
                                              ),
                                            );
                                          }
                                        }, null);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      //Locallllllllllllllllllllllllllllllllllllllll GEMMMAAAAAAAAAAAAAAAAAAA

                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      // ),
                      // Consumer<FontsProvider>(
                      //   builder: (BuildContext context, FontsProvider value,
                      //       Widget? child) {
                      //     return Text(
                      //       'AI Server Connection',
                      //       style: TextStyle(
                      //         fontFamily: fontType,
                      //         // fontSize: headingSize - 8,
                      //         fontSize: value.fonts.headingSize - 8,
                      //         // color: FontAppColors.primaryFont,
                      //         color: value.fonts.primaryFontColor,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     );
                      //   },
                      // ),
                      // // SizedBox(
                      // //   height: MediaQuery.of(context).size.height * 0.05,
                      // // ),
                      // Consumer<FontsProvider>(
                      //   builder: (BuildContext context, FontsProvider value,
                      //       Widget? child) {
                      //     return Form(
                      //       key: _form2Key,
                      //       child: Row(
                      //         children: [
                      //           Column(
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.all(5.0),
                      //                 child: TextFormFieldWidget(
                      //                   // fontSize: textSize,
                      //                   fontSize: value.fonts.textSize,
                      //                   label: 'AI IP Address',
                      //                   key: const ValueKey("aiIP"),
                      //                   textController: _aiIpAddressController,
                      //                   isSuffixRequired: true,
                      //                   // isHidden: false,
                      //                   isPassword: false,
                      //                   maxLength: 50,
                      //                   maxlines: 1,
                      //                   width:
                      //                       MediaQuery.sizeOf(context).width *
                      //                           0.5,
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.all(5.0),
                      //                 child: TextFormFieldWidget(
                      //                   // fontSize: textSize,
                      //                   fontSize: value.fonts.textSize,
                      //                   label: 'AI Port',
                      //                   key: const ValueKey("aiPort"),
                      //                   textController: _aiPortController,
                      //                   isSuffixRequired: true,
                      //                   // isHidden: false,
                      //                   isPassword: false,
                      //                   maxLength: 50,
                      //                   maxlines: 1,
                      //                   width:
                      //                       MediaQuery.sizeOf(context).width *
                      //                           0.5,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             width:
                      //                 MediaQuery.of(context).size.width * 0.05,
                      //           ),
                      //           AppDividerWidget(
                      //             height:
                      //                 MediaQuery.of(context).size.height * 0.2,
                      //           ),
                      //           SizedBox(
                      //             width:
                      //                 MediaQuery.of(context).size.width * 0.05,
                      //           ),
                      //           Column(
                      //             children: [
                      //               LgElevatedButton(
                      //                 elevatedButtonContent: 'CONNECT AI',
                      //                 buttonColor: LgAppColors.lgColor4,
                      //                 fontColor: FontAppColors.secondaryFont,
                      //                 height:
                      //                     MediaQuery.of(context).size.height *
                      //                         0.05,
                      //                 width: MediaQuery.of(context).size.width *
                      //                     0.25,
                      //                 // fontSize: textSize + 2,
                      //                 fontSize: value.fonts.textSize + 2,
                      //                 isLoading: false,
                      //                 isBold: true,
                      //                 isPrefixIcon: true,
                      //                 prefixIcon: Icons.cast_connected,
                      //                 prefixIconColor:
                      //                     FontAppColors.secondaryFont,
                      //                 prefixIconSize: 30,
                      //                 isSuffixIcon: false,
                      //                 curvatureRadius: 50,
                      //                 onpressed: () async {
                      //                   /// checking first if form is valid
                      //                   if (_form2Key.currentState!
                      //                       .validate()) {
                      //                     //saving date in shared pref
                      //                     await LgConnectionSharedPref.setAiIp(
                      //                         _aiIpAddressController.text);
                      //                     await LgConnectionSharedPref
                      //                         .setAiPort(
                      //                             _aiPortController.text);
                      //                   }
                      //                   final stringUrl =
                      //                       'http://${_aiIpAddressController.text}:${_aiPortController.text}/health';
                      //                   final url = Uri.parse(stringUrl);

                      //                   ///start the loading process by setting `isloading` to true
                      //                   setState(() {
                      //                     _isLoading2 = true;
                      //                   });

                      //                   Connectionprovider connection =
                      //                       Provider.of<Connectionprovider>(
                      //                           context,
                      //                           listen: false);

                      //                   String result = '';

                      //                   if (!await Api().isServerAvailable()) {
                      //                     result =
                      //                         'The server is currently unavailable. Please try again later.';
                      //                   } else {
                      //                     String res =
                      //                         await Api().isEndpointAvailable();

                      //                     if (res != 'Success') {
                      //                       result = res;
                      //                     }
                      //                   }

                      //                   ///checking on the connection status:
                      //                   if (result == '') {
                      //                     connection.isAiConnected = true;
                      //                   } else {
                      //                     connection.isAiConnected = false;

                      //                     // ignore: use_build_context_synchronously
                      //                     dialogBuilder(context, result, true,
                      //                         'OK', null, null);
                      //                   }

                      //                   ///stop the loading process by setting `isloading` to false
                      //                   setState(() {
                      //                     _isLoading2 = false;
                      //                   });
                      //                 },
                      //               ),
                      //               SizedBox(
                      //                 height:
                      //                     MediaQuery.of(context).size.height *
                      //                         0.05,
                      //               ),
                      //               // LgElevatedButton(
                      //               //   elevatedButtonContent: 'DISCONNECT AI',
                      //               //   buttonColor: LgAppColors.lgColor2,
                      //               //   fontColor: FontAppColors.secondaryFont,
                      //               //   height: MediaQuery.of(context).size.height * 0.05,
                      //               //   width: MediaQuery.of(context).size.width * 0.25,
                      //               //   fontSize: textSize + 2,
                      //               //   isLoading: false,
                      //               //   isBold: true,
                      //               //   isPrefixIcon: true,
                      //               //   curvatureRadius: 50,
                      //               //   prefixIcon:
                      //               //       Icons.signal_wifi_connected_no_internet_4,
                      //               //   prefixIconColor: FontAppColors.secondaryFont,
                      //               //   prefixIconSize: 30,
                      //               //   isSuffixIcon: false,
                      //               //   onpressed: () async {},
                      //               // ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      // ),
                    ],
                  ),
                  if ((_isLoading1 && _form1Key.currentState!.validate())

                      //LOCAL: || (_isLoading2 && _form2Key.currentState!.validate())
                      )

                    /// Show the loading indicator if `_isLoading` is true

                    Consumer<ColorProvider>(
                      builder: (BuildContext context, ColorProvider value,
                          Widget? child) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: CircularProgressIndicator(
                            color: value.colors.innerBackground,
                            backgroundColor: value.colors.buttonColors,
                            semanticsLabel:
                                AppLocalizations.of(context)!.defaults_loading,
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
