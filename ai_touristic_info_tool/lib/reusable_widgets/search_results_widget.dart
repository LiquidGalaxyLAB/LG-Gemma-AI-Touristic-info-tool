import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';

import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/dialogs/show_link_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchResultsContainer extends StatelessWidget {
  const SearchResultsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //Stack(
        //  children: [
        SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer3<SearchProvider, ColorProvider, FontsProvider>(
            builder: (BuildContext context,
                SearchProvider value,
                ColorProvider colorProv,
                FontsProvider fontProv,
                Widget? child) {
              return Center(
                child: Text(
                  // 'Website Results for ${value.searchPoiSelected}',
                  AppLocalizations.of(context)!
                      .searchResults_web(value.searchPoiSelected),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontSize: textSize + 4,
                    fontSize: fontProv.fonts.textSize + 4,
                    color: fontProv.fonts.primaryFontColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontType,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Consumer3<SearchProvider, ColorProvider, FontsProvider>(
            builder: (BuildContext context,
                SearchProvider value,
                ColorProvider colorProv,
                FontsProvider fontProv,
                Widget? child) {
              if (value.isLoading) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(110, 210, 209, 209),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      )),
                );
              } else if (value.webSearchResults.isEmpty) {
                return Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(110, 210, 209, 209),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            // 'No URLs found',
                            AppLocalizations.of(context)!
                                .searchResults_noneFound,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontProv.fonts.textSize,
                              color: FontAppColors.primaryFont,
                              fontFamily: fontType,
                            ),
                          ),
                        )));
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(110, 210, 209, 209),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.webSearchResults.length,
                      itemBuilder: (context, index) {
                        bool isLoading = true;
                        WebViewController webController = WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..setBackgroundColor(const Color(0x00000000))
                          ..setNavigationDelegate(
                            NavigationDelegate(
                              onProgress: (int progress) {
                                if (progress == 100) {
                                  isLoading = false;
                                }
                              },
                              onPageStarted: (String url) {},
                              onPageFinished: (String url) {
                                isLoading = false;
                              },
                              onHttpError: (HttpResponseError error) {
                                isLoading = false;
                              },
                              onWebResourceError: (WebResourceError error) {
                                isLoading = false;
                              },
                              onNavigationRequest: (NavigationRequest request) {
                                return NavigationDecision.navigate;
                              },
                            ),
                          )
                          ..loadRequest(
                              Uri.parse(value.webSearchResults[index]));
                        return ListTile(
                            title: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: GestureDetector(
                            onTap: () async {
                              final sshData = Provider.of<SSHprovider>(context,
                                  listen: false);

                              Connectionprovider connection =
                                  Provider.of<Connectionprovider>(context,
                                      listen: false);

                              ///checking the connection status first
                              if (sshData.client != null &&
                                  connection.isLgConnected) {
                                await buildWebsiteLinkBallon(
                                    value.searchPoiSelected,
                                    value.searchPoiCity,
                                    value.searchPoiCountry,
                                    value.poiLat,
                                    value.poiLong,
                                    value.youtubeSearchResults[index],
                                    context);
                              }
                              showLinkDialog(context,
                                  value.webSearchResults[index], webController);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.link,
                                    color: FontAppColors.primaryFont),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                Expanded(
                                  child: Text(
                                    value.webSearchResults[index],
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // fontSize: textSize,
                                      fontSize: fontProv.fonts.textSize,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      fontFamily: fontType,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                      },
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Consumer3<SearchProvider, ColorProvider, FontsProvider>(
            builder: (BuildContext context,
                SearchProvider value,
                ColorProvider colorProv,
                FontsProvider fontProv,
                Widget? child) {
              return Center(
                child: Text(
                  // 'Youtube Results for ${value.searchPoiSelected}',
                  AppLocalizations.of(context)!
                      .searchResults_youtube(value.searchPoiSelected),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontSize: textSize + 4,
                    fontSize: fontProv.fonts.textSize + 4,
                    color: fontProv.fonts.primaryFontColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontType,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Consumer3<SearchProvider, ColorProvider, FontsProvider>(
            builder: (BuildContext context,
                SearchProvider value,
                ColorProvider colorProv,
                FontsProvider fontProv,
                Widget? child) {
              if (value.isLoading) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(110, 210, 209, 209),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (value.youtubeSearchResults.isEmpty) {
                return Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(110, 210, 209, 209),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          // 'No URLs found',
                          AppLocalizations.of(context)!.searchResults_noneFound,
                          style: TextStyle(
                            fontSize: fontProv.fonts.textSize,
                            color: FontAppColors.primaryFont,
                            fontFamily: fontType,
                          ),
                        )));
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(110, 210, 209, 209),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.youtubeSearchResults.length,
                      itemBuilder: (context, index) {
                        bool isLoading = true;
                        WebViewController youtubeController =
                            WebViewController()
                              ..setJavaScriptMode(JavaScriptMode.unrestricted)
                              ..setBackgroundColor(const Color(0x00000000))
                              ..setNavigationDelegate(
                                NavigationDelegate(
                                  onProgress: (int progress) {
                                    if (progress == 100) {
                                      isLoading = false;
                                    }
                                  },
                                  onPageStarted: (String url) {},
                                  onPageFinished: (String url) {
                                    isLoading = false;
                                  },
                                  onHttpError: (HttpResponseError error) {
                                    isLoading = false;
                                  },
                                  onWebResourceError: (WebResourceError error) {
                                    isLoading = false;
                                  },
                                  onNavigationRequest:
                                      (NavigationRequest request) {
                                    return NavigationDecision.navigate;
                                  },
                                ),
                              )
                              ..loadRequest(
                                  Uri.parse(value.youtubeSearchResults[index]));
                        return ListTile(
                            title: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: GestureDetector(
                            onTap: () async {
                              final sshData = Provider.of<SSHprovider>(context,
                                  listen: false);

                              Connectionprovider connection =
                                  Provider.of<Connectionprovider>(context,
                                      listen: false);

                              ///checking the connection status first
                              if (sshData.client != null &&
                                  connection.isLgConnected) {
                                await buildYoutubeLinkBallon(
                                    value.searchPoiSelected,
                                    value.searchPoiCity,
                                    value.searchPoiCountry,
                                    value.poiLat,
                                    value.poiLong,
                                    extractVideoId(
                                        value.youtubeSearchResults[index]),
                                    context);
                              }

                              showLinkDialog(
                                  context,
                                  value.youtubeSearchResults[index],
                                  youtubeController);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.link,
                                    color: FontAppColors.primaryFont),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                Expanded(
                                  child: Text(
                                    value.youtubeSearchResults[index],
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // fontSize: textSize,
                                      fontSize: fontProv.fonts.textSize,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      fontFamily: fontType,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                      },
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
}

String extractVideoId(String youtubeUrl) {
  if (youtubeUrl.contains("youtube.com")) {
    return youtubeUrl.split("v=")[1].substring(0, 11);
  } else if (youtubeUrl.contains("youtu.be")) {
    return youtubeUrl.split("/")[3];
  }
  return '';
}
