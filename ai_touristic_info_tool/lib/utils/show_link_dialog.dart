import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

void showLinkDialog(
    BuildContext context, String url, WebViewController webController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FontAppColors.secondaryFont,
        shadowColor: FontAppColors.secondaryFont,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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
              Divider(
                color: const Color.fromARGB(197, 158, 158, 158),
                thickness: 2,
                height: 1,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                // decoration: BoxDecoration(
                //     // color: FontAppColors.secondaryFont,
                //     borderRadius: BorderRadius.circular(30),
                //     border: Border.all(
                //         color: const Color.fromARGB(197, 158, 158, 158))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // GestureDetector(
                    //   onTap: () => launchUrlString(url),
                    //   child: Text(
                    //     'Open in Browser',
                    //     style: TextStyle(
                    //       color: FontAppColors.primaryFont,
                    //       fontSize: textSize,
                    //       fontFamily: fontType,
                    //     ),
                    //   ),
                    // ),
                    LgElevatedButton(
                      elevatedButtonContent: 'Open in Browser',
                      buttonColor: FontAppColors.secondaryFont,
                      onpressed: () async {
                        launchUrlString(url);
                      },
                      height: MediaQuery.of(context).size.height * 0.035,
                      width: MediaQuery.of(context).size.width * 0.2,
                      fontSize: textSize,
                      fontColor: FontAppColors.primaryFont,
                      isLoading: false,
                      isBold: false,
                      isPrefixIcon: false,
                      isSuffixIcon: false,
                      curvatureRadius: 0,
                    ),
                    VerticalDivider(
                      color: const Color.fromARGB(197, 158, 158, 158),
                      thickness: 2,
                      width: 1,
                    ),
                    LgElevatedButton(
                      elevatedButtonContent: 'Close',
                      buttonColor: FontAppColors.secondaryFont,
                      onpressed: () async {
                        Navigator.of(context).pop();
                      },
                      height: MediaQuery.of(context).size.height * 0.035,
                      width: MediaQuery.of(context).size.width * 0.2,
                      fontSize: textSize,
                      fontColor: FontAppColors.primaryFont,
                      isLoading: false,
                      isBold: false,
                      isPrefixIcon: false,
                      isSuffixIcon: false,
                      curvatureRadius: 0,
                    ),
                    // GestureDetector(
                    //   onTap: () => Navigator.of(context).pop(),
                    //   child: Text(
                    //     'close',
                    //     style: TextStyle(
                    //       color: FontAppColors.primaryFont,
                    //       fontSize: textSize,
                    //       fontFamily: fontType,
                    //     ),
                    //   ),
                    // ),
                    // LgElevatedButton(
                    //   elevatedButtonContent: 'Open in Browser',
                    //   buttonColor: LgAppColors.lgColor3,
                    //   onpressed: () async {
                    //     launchUrlString(url);
                    //   },
                    //   height: MediaQuery.of(context).size.height * 0.035,
                    //   width: MediaQuery.of(context).size.width * 0.2,
                    //   fontSize: textSize,
                    //   fontColor: FontAppColors.secondaryFont,
                    //   isLoading: false,
                    //   isBold: false,
                    //   isPrefixIcon: false,
                    //   isSuffixIcon: false,
                    //   curvatureRadius: 30,
                    // ),
                    // LgElevatedButton(
                    //   elevatedButtonContent: 'Close',
                    //   buttonColor: LgAppColors.lgColor2,
                    //   onpressed: () async {
                    //     Navigator.of(context).pop();
                    //   },
                    //   height: MediaQuery.of(context).size.height * 0.035,
                    //   width: MediaQuery.of(context).size.width * 0.2,
                    //   fontSize: textSize,
                    //   fontColor: FontAppColors.secondaryFont,
                    //   isLoading: false,
                    //   isBold: false,
                    //   isPrefixIcon: false,
                    //   isSuffixIcon: false,
                    //   curvatureRadius: 30,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
