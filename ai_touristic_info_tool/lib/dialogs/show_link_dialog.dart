import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


/// Displays a dialog containing a web view and action buttons.
///
/// This function shows an `AlertDialog` that includes a `WebViewWidget` for
/// displaying a webpage and two action buttons. One button opens the URL
/// in the default web browser, and the other closes the dialog.
///
/// [context] - The BuildContext used to display the dialog.
/// [url] - The URL to open in the web view and when the "Open" button is pressed.
/// [webController] - The `WebViewController` used to manage the web view within the dialog.
///
/// The dialog contains:
/// - A `WebViewWidget` displaying the specified URL.
/// - A button to open the URL in the default web browser.
/// - A button to close the dialog.
/// 

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
                children: [
                  LgElevatedButton(
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
