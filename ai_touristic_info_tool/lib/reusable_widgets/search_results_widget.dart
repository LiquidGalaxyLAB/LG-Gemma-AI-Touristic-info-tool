import 'package:ai_touristic_info_tool/constants.dart';

import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:ai_touristic_info_tool/utils/show_link_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          Consumer<SearchProvider>(
            builder:
                (BuildContext context, SearchProvider value, Widget? child) {
              return Text(
                'Website Results for ${value.searchPoiSelected}',
                style: TextStyle(
                  fontSize: textSize + 4,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontType,
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Consumer<SearchProvider>(
            builder:
                (BuildContext context, SearchProvider value, Widget? child) {
              if (value.isLoading) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(112, 180, 150, 237),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      )
                      //child:  Padding(
                      //   padding: EdgeInsets.only(
                      //       right: MediaQuery.of(context).size.width * 0.325,
                      //       left: MediaQuery.of(context).size.width * 0.325,
                      //       top: MediaQuery.of(context).size.height * 0.15,
                      //       bottom:
                      //           MediaQuery.of(context).size.height * 0.15),
                      //   child: CircularProgressIndicator(),
                      //  ),
                      ),
                );
              } else if (value.webSearchResults.isEmpty) {
                return Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(112, 180, 150, 237),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('No URLs found')));
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(112, 180, 150, 237),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.webSearchResults.length,
                      itemBuilder: (context, index) {
                        WebViewController webController = WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..setBackgroundColor(const Color(0x00000000))
                          ..setNavigationDelegate(
                            NavigationDelegate(
                              onProgress: (int progress) {
                                // Update loading bar.
                              },
                              onPageStarted: (String url) {},
                              onPageFinished: (String url) {},
                              onHttpError: (HttpResponseError error) {},
                              onWebResourceError: (WebResourceError error) {},
                              // onNavigationRequest: (NavigationRequest request) {
                              //   if (request.url.startsWith('https://www.youtube.com/')) {
                              //     return NavigationDecision.prevent;
                              //   }
                              //   return NavigationDecision.navigate;
                              // },
                            ),
                          )
                          ..loadRequest(
                              Uri.parse(value.webSearchResults[index]));
                        return ListTile(
                            title: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: GestureDetector(
                            onTap: () {
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
                                      fontSize: textSize,
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
          Consumer<SearchProvider>(
            builder:
                (BuildContext context, SearchProvider value, Widget? child) {
              return Text(
                'Youtube Results for ${value.searchPoiSelected}',
                style: TextStyle(
                  fontSize: textSize + 4,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontType,
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Consumer<SearchProvider>(
            builder:
                (BuildContext context, SearchProvider value, Widget? child) {
              if (value.isLoading) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(106, 246, 120, 116),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       right: MediaQuery.of(context).size.width * 0.325,
                    //       left: MediaQuery.of(context).size.width * 0.325,
                    //       top: MediaQuery.of(context).size.height * 0.15,
                    //       bottom: MediaQuery.of(context).size.height * 0.15),
                    //   child: CircularProgressIndicator(
                    //     color: FontAppColors.secondaryFont,
                    //   ),
                    // ),
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
                          color: Color.fromARGB(106, 246, 120, 116),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('No URLs found')));
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(106, 246, 120, 116),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.youtubeSearchResults.length,
                      itemBuilder: (context, index) {
                        WebViewController youtubeController =
                            WebViewController()
                              ..setJavaScriptMode(JavaScriptMode.unrestricted)
                              ..setBackgroundColor(const Color(0x00000000))
                              ..setNavigationDelegate(
                                NavigationDelegate(
                                  onProgress: (int progress) {
                                    // Update loading bar.
                                  },
                                  onPageStarted: (String url) {},
                                  onPageFinished: (String url) {},
                                  onHttpError: (HttpResponseError error) {},
                                  onWebResourceError:
                                      (WebResourceError error) {},
                                  // onNavigationRequest: (NavigationRequest request) {
                                  //   if (request.url.startsWith('https://www.youtube.com/')) {
                                  //     return NavigationDecision.prevent;
                                  //   }
                                  //   return NavigationDecision.navigate;
                                  // },
                                ),
                              )
                              ..loadRequest(
                                  Uri.parse(value.youtubeSearchResults[index]));
                        return ListTile(
                            title: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: GestureDetector(
                            onTap: () {
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
                                      fontSize: textSize,
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
    //,
    // Positioned(
    //   bottom: 16,
    //   right: 0,
    //   child: Visibility(
    //     visible: true,
    //     child: FloatingActionButton(
    //       backgroundColor: PrimaryAppColors.buttonColors,
    //       onPressed: () {
    //         Provider.of<SearchProvider>(context, listen: false).showMap =
    //             true;
    //       },
    //       child: Icon(
    //         Icons.map_outlined,
    //         color: FontAppColors.secondaryFont,
    //       ),
    //     ),
    //   ),
    // ),
    // ],
    //  );
  }
}
