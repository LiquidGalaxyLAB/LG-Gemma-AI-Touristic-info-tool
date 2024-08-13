import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/tasks_container.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../services/lg_functionalities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LGTasksView extends StatefulWidget {
  const LGTasksView({super.key});

  @override
  State<LGTasksView> createState() => _LGTasksViewState();
}

class _LGTasksViewState extends State<LGTasksView> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider, FontsProvider>(builder:
        (BuildContext context, ColorProvider value, FontsProvider fontProv,
            Widget? child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TopBarWidget(
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
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/lgTasks.png",
                  width: MediaQuery.of(context).size.width * 0.05,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: FontAppColors.secondaryFont,
                ),
                Center(
                  child: Text(
                    // 'LG Tasks',
                    AppLocalizations.of(context)!.lgTasks_title,
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: headingSize,
                      fontSize: fontProv.fonts.headingSize,
                      color: SettingsSharedPref.getTheme() == 'dark'
                          ? fontProv.fonts.primaryFontColor
                          : fontProv.fonts.secondaryFontColor,
                      // color: FontAppColors.secondaryFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LgTasksButton(
                    key: GlobalKeys.showcaseKeyTasksRelaunch,
                    buttonColor: value.colors.shadow,
                    borderColor: value.colors.buttonColors,
                    fontSize: fontProv.fonts.textSize,
                    text: AppLocalizations.of(context)!.lgTasks_relaunch,
                    imgPath: "assets/images/relaunch.png",
                    onTap: () {
                      /// retrieving the ssh data from the `ssh provider`
                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      Connectionprovider connection =
                          Provider.of<Connectionprovider>(context,
                              listen: false);

                      ///checking the connection status first
                      if (sshData.client != null && connection.isLgConnected) {
                        /// calling `reboot` from `LGService`

                        dialogBuilder(
                            context,
                            // 'Are you sure you want to Relaunch?',
                            AppLocalizations.of(context)!
                                .lgTasks_confirmRelaunch,
                            false,
                            // 'YES',
                            AppLocalizations.of(context)!.defaults_yes, () {
                          LgService(sshData).relaunch();
                        }, () {});
                      } else {
                        dialogBuilder(
                            context,
                            // 'NOT connected to LG !! \n Please Connect to LG',
                            AppLocalizations.of(context)!
                                .lgTasks_notConnectedError,
                            true,
                            // 'OK',
                            AppLocalizations.of(context)!.defaults_ok,
                            null,
                            null);
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  LgTasksButton(
                    key: GlobalKeys.showcaseKeyTasksReboot,
                    buttonColor: value.colors.shadow,
                    borderColor: value.colors.buttonColors,
                    fontSize: fontProv.fonts.textSize,
                    text: AppLocalizations.of(context)!.lgTasks_reboot,
                    imgPath: "assets/images/reboot.png",
                    onTap: () {
                      /// retrieving the ssh data from the `ssh provider`
                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      Connectionprovider connection =
                          Provider.of<Connectionprovider>(context,
                              listen: false);

                      ///checking the connection status first
                      if (sshData.client != null && connection.isLgConnected) {
                        /// calling `reboot` from `LGService`

                        dialogBuilder(
                            context,
                            // 'Are you sure you want to Reboot?',
                            AppLocalizations.of(context)!.lgTasks_confirmReboot,
                            false,
                            // 'YES'
                            AppLocalizations.of(context)!.defaults_yes, () {
                          LgService(sshData).reboot();
                        }, () {});
                      } else {
                        ///Showing error message

                        dialogBuilder(
                            context,
                            // 'NOT connected to LG !! \n Please Connect to LG',
                            AppLocalizations.of(context)!
                                .lgTasks_notConnectedError,
                            true,
                            // 'OK',
                            AppLocalizations.of(context)!.defaults_ok,
                            null,
                            null);
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  LgTasksButton(
                    key: GlobalKeys.showcaseKeyTasksShutDown,
                    buttonColor: value.colors.shadow,
                    borderColor: value.colors.buttonColors,
                    fontSize: fontProv.fonts.textSize,
                    text: AppLocalizations.of(context)!.lgTasks_shutdown,
                    imgPath: "assets/images/shutdown.png",
                    onTap: () {
                      /// retrieving the ssh data from the `ssh provider`
                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      Connectionprovider connection =
                          Provider.of<Connectionprovider>(context,
                              listen: false);

                      ///checking the connection status first
                      if (sshData.client != null && connection.isLgConnected) {
                        //warning message first

                        dialogBuilder(
                            context,
                            // 'Are you sure you want to Shut Down?',
                            AppLocalizations.of(context)!
                                .lgTasks_confirmShutdown,
                            false,
                            // 'YES',
                            AppLocalizations.of(context)!.defaults_yes, () {
                          try {
                            LgService(sshData).shutdown();
                          } catch (e) {
                            // ignore: avoid_print
                            print(e);
                          }
                        }, () {});
                      } else {
                        ///Showing error message

                        dialogBuilder(
                            context,
                            // 'NOT connected to LG !! \n Please Connect to LG',
                            AppLocalizations.of(context)!
                                .lgTasks_notConnectedError,
                            true,
                            // 'OK',
                            AppLocalizations.of(context)!.defaults_ok,
                            null,
                            null);
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  // LgTasksButton(
                  //     buttonColor: value.colors.shadow,
                  //     borderColor: value.colors.buttonColors,
                  //     fontSize: fontProv.fonts.textSize,
                  //     text: AppLocalizations.of(context)!.lgTasks_setRefresh,
                  //     onTap: () {
                  //       /// retrieving the ssh data from the `ssh provider`
                  //       final sshData =
                  //           Provider.of<SSHprovider>(context, listen: false);

                  //       Connectionprovider connection =
                  //           Provider.of<Connectionprovider>(context,
                  //               listen: false);

                  //       ///checking the connection status first
                  //       if (sshData.client != null &&
                  //           connection.isLgConnected) {
                  //         //warning message first

                  //         dialogBuilder(
                  //             context,
                  //             // 'Are you sure you want to set Refresh?',
                  //             AppLocalizations.of(context)!
                  //                 .lgTasks_confirmRefresh,
                  //             false,
                  //             // 'YES',
                  //             AppLocalizations.of(context)!.defaults_yes, () {
                  //           try {
                  //             LgService(sshData).setRefresh();
                  //           } catch (e) {
                  //             // ignore: avoid_print
                  //             print(e);
                  //           }
                  //         }, () {});
                  //       } else {
                  //         ///Showing error message

                  //         dialogBuilder(
                  //             context,
                  //             // 'NOT connected to LG !! \n Please Connect to LG',
                  //             AppLocalizations.of(context)!
                  //                 .lgTasks_notConnectedError,
                  //             true,
                  //             // 'OK',
                  //             AppLocalizations.of(context)!.defaults_ok,
                  //             null,
                  //             null);
                  //       }
                  //     }),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height *0.01,
                  // ),
                  // LgTasksButton(
                  //     buttonColor: value.colors.shadow,
                  //     borderColor: value.colors.buttonColors,
                  //     fontSize: fontProv.fonts.textSize,
                  //     text: AppLocalizations.of(context)!.lgTasks_resetRefresh,
                  //     onTap: () {
                  //       /// retrieving the ssh data from the `ssh provider`
                  //       final sshData =
                  //           Provider.of<SSHprovider>(context, listen: false);

                  //       Connectionprovider connection =
                  //           Provider.of<Connectionprovider>(context,
                  //               listen: false);

                  //       ///checking the connection status first
                  //       if (sshData.client != null &&
                  //           connection.isLgConnected) {
                  //         //warning message first

                  //         dialogBuilder(
                  //             context,
                  //             // 'Are you sure you want to Reset Refresh?',
                  //             AppLocalizations.of(context)!
                  //                 .lgTasks_confirmResetRefresh,
                  //             false,
                  //             // 'YES',
                  //             AppLocalizations.of(context)!.defaults_yes, () {
                  //           try {
                  //             LgService(sshData).resetRefresh();
                  //           } catch (e) {
                  //             // ignore: avoid_print
                  //             print(e);
                  //           }
                  //         }, () {});
                  //       } else {
                  //         ///Showing error message

                  //         dialogBuilder(
                  //             context,
                  //             // 'NOT connected to LG !! \n Please Connect to LG',
                  //             AppLocalizations.of(context)!
                  //                 .lgTasks_notConnectedError,
                  //             true,
                  //             // 'OK',
                  //             AppLocalizations.of(context)!.defaults_ok,
                  //             null,
                  //             null);
                  //       }
                  //     }),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height *0.01,
                  // ),
                  LgTasksButton(
                      key: GlobalKeys.showcaseKeyTasksShowLogos,
                      buttonColor: value.colors.shadow,
                      borderColor: value.colors.buttonColors,
                      fontSize: fontProv.fonts.textSize,
                      text: AppLocalizations.of(context)!.lgTasks_showLogos,
                      imgPath: "assets/images/show.png",
                      onTap: () {
                        /// retrieving the ssh data from the `ssh provider`
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        Connectionprovider connection =
                            Provider.of<Connectionprovider>(context,
                                listen: false);

                        ///checking the connection status first
                        if (sshData.client != null &&
                            connection.isLgConnected) {
                          LgService(sshData).setLogos();
                        } else {
                          dialogBuilder(
                              context,
                              // 'NOT connected to LG !! \n Please Connect to LG',
                              AppLocalizations.of(context)!
                                  .lgTasks_notConnectedError,
                              true,
                              // 'OK',
                              AppLocalizations.of(context)!.defaults_ok,
                              null,
                              null);
                        }
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  LgTasksButton(
                      key: GlobalKeys.showcaseKeyTasksHideLogos,
                      buttonColor: value.colors.shadow,
                      borderColor: value.colors.buttonColors,
                      fontSize: fontProv.fonts.textSize,
                      text: AppLocalizations.of(context)!.lgTasks_hideLogos,
                      imgPath: "assets/images/hide.png",
                      onTap: () {
                        /// retrieving the ssh data from the `ssh provider`
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        Connectionprovider connection =
                            Provider.of<Connectionprovider>(context,
                                listen: false);

                        ///checking the connection status first
                        if (sshData.client != null &&
                            connection.isLgConnected) {
                          LgService(sshData).clearKml(keepLogos: false);
                        } else {
                          dialogBuilder(
                              context,
                              // 'NOT connected to LG !! \n Please Connect to LG',
                              AppLocalizations.of(context)!
                                  .lgTasks_notConnectedError,
                              true,
                              // 'OK',
                              AppLocalizations.of(context)!.defaults_ok,
                              null,
                              null);
                        }
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  LgTasksButton(
                      key: GlobalKeys.showcaseKeyTasksCleanKmls,
                      buttonColor: value.colors.shadow,
                      borderColor: value.colors.buttonColors,
                      fontSize: fontProv.fonts.textSize,
                      text: AppLocalizations.of(context)!.lgTasks_cleanKMLs,
                      imgPath: "assets/images/clear.png",
                      onTap: () {
                        /// retrieving the ssh data from the `ssh provider`
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        Connectionprovider connection =
                            Provider.of<Connectionprovider>(context,
                                listen: false);

                        ///checking the connection status first
                        if (sshData.client != null &&
                            connection.isLgConnected) {
                          LgService(sshData).clearKml();
                        } else {
                          dialogBuilder(
                              context,
                              // 'NOT connected to LG !! \n Please Connect to LG',
                              AppLocalizations.of(context)!
                                  .lgTasks_notConnectedError,
                              true,
                              // 'OK',
                              AppLocalizations.of(context)!.defaults_ok,
                              null,
                              null);
                        }
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
