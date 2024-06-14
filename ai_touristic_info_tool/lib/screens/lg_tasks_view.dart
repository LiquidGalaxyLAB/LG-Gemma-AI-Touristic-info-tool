import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../services/lg_functionalities.dart';

class LGTasksView extends StatefulWidget {
  const LGTasksView({super.key});

  @override
  State<LGTasksView> createState() => _LGTasksViewState();
}

class _LGTasksViewState extends State<LGTasksView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopBarWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/lgTasks.png",
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                color: FontAppColors.secondaryFont,
              ),
              Center(
                child: Text(
                  'LG Tasks',
                  style: TextStyle(
                    fontFamily: fontType,
                    fontSize: headingSize,
                    color: FontAppColors.secondaryFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'RELAUNCH',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.launch_rounded,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                onpressed: () async {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    /// calling `reboot` from `LGService`

                    dialogBuilder(context, 'Are you sure you want to Relaunch?',
                        false, 'YES', () {
                      LgService(sshData).relaunch();
                    }, () {});
                  } else {
                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'REBOOT',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.replay_rounded,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                onpressed: () {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    /// calling `reboot` from `LGService`

                    dialogBuilder(context, 'Are you sure you want to Reboot?',
                        false, 'YES', () {
                      LgService(sshData).reboot();
                    }, () {});
                  } else {
                    ///Showing error message

                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'SHUT DOWN',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.power_settings_new_rounded,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                onpressed: () async {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    //warning message first

                    dialogBuilder(
                        context,
                        'Are you sure you want to Shut Down?',
                        false,
                        'YES', () {
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
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'SET REFRESH',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.refresh,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                onpressed: () async {
                                   /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    //warning message first

                    dialogBuilder(
                        context,
                        'Are you sure you want to set Refresh?',
                        false,
                        'YES', () {
                      try {
                        LgService(sshData).setRefresh();
                      } catch (e) {
                        // ignore: avoid_print
                        print(e);
                      }
                    }, () {});
                  } else {
                    ///Showing error message

                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'RESET REFRESH',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.settings_backup_restore,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.26,
                onpressed: () async {
                                    /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    //warning message first

                    dialogBuilder(
                        context,
                        'Are you sure you want to Reset Refresh?',
                        false,
                        'YES', () {
                      try {
                        LgService(sshData).resetRefresh();
                      } catch (e) {
                        // ignore: avoid_print
                        print(e);
                      }
                    }, () {});
                  } else {
                    ///Showing error message

                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'SHOW LOGOS',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.visibility,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                onpressed: () async {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    LgService(sshData).setLogos();
                  } else {
                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'HIDE LOGOS',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.visibility_off,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                onpressed: () async {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    LgService(sshData).clearKml(keepLogos: false);
                  } else {
                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'CLEAN KMLS',
                buttonColor: PrimaryAppColors.buttonColors,
                fontColor: FontAppColors.secondaryFont,
                fontSize: textSize + 4,
                isLoading: false,
                isBold: false,
                isSuffixIcon: false,
                isPrefixIcon: true,
                prefixIcon: Icons.cleaning_services,
                prefixIconSize: 30,
                prefixIconColor: FontAppColors.secondaryFont,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                onpressed: () async {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  Connectionprovider connection =
                      Provider.of<Connectionprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null && connection.isLgConnected) {
                    LgService(sshData).clearKml();
                  } else {
                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null,
                        null);
                  }
                }),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
      ],
    );
  }
}
