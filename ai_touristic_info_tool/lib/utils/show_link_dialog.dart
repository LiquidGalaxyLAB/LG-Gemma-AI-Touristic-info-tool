import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showLinkDialog(
    BuildContext context, String url, WebViewController webController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FontAppColors.secondaryFont,
        shadowColor: FontAppColors.secondaryFont,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        iconPadding: EdgeInsets.zero,
        titlePadding: const EdgeInsets.only(bottom: 20),
        contentPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.only(bottom: 10),
        surfaceTintColor: FontAppColors.secondaryFont,
        content: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: WebViewWidget(controller: webController),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LgElevatedButton(
                    // elevatedButtonContent: 'Open in Browser',
                      elevatedButtonContent: AppLocalizations.of(context)!.link_open,
                    buttonColor: FontAppColors.secondaryFont,
                    onpressed: () async {
                      launchUrlString(url);
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.4,
                    fontSize: textSize,
                    fontColor: FontAppColors.primaryFont,
                    isLoading: false,
                    isBold: true,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 0,
                    elevation: 5,
                  ),
                  LgElevatedButton(
                    // elevatedButtonContent: 'Close',
                    elevatedButtonContent: AppLocalizations.of(context)!.defaults_close,
                    buttonColor: FontAppColors.secondaryFont,
                    onpressed: () async {
                      Navigator.of(context).pop();
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.4,
                    fontSize: textSize,
                    fontColor: FontAppColors.primaryFont,
                    isLoading: false,
                    isBold: true,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 0,
                    elevation: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
