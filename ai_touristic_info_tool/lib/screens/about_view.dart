import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Future<void> _launchUrl(Uri url) async {
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer2<ColorProvider, FontsProvider>(builder:
          (BuildContext context, ColorProvider value, FontsProvider font,
              Widget? child) {
        return Column(
          children: [
            TopBarWidget(
              // grad1: value.colors.gradient1,
              // grad2: value.colors.gradient2,
              // grad3: value.colors.gradient3,
              // grad4: value.colors.gradient4,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/appLogo.png",
                    scale: 0.5,
                  ),
                  Text(
                    "LG Gemma AI Touristic Info Tool",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        // fontSize: titleSize,
                        fontSize: font.fonts.titleSize,
                        // color: FontAppColors.secondaryFont,
                        color: SettingsSharedPref.getTheme() == 'dark'
                            ? font.fonts.primaryFontColor
                            : font.fonts.secondaryFontColor,
                        fontFamily: fontType,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(79, 229, 79, 62),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Be aware of AI hallucinations !\n\n',
                            style: TextStyle(
                                // fontSize: headingSize,
                                fontSize: font.fonts.headingSize,
                                color: LgAppColors.lgColor2,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'The state of the art of most AI tools as 2024 can give you sometimes incorrect answers, or even the so called Hallucinations:\n\n',
                            style: TextStyle(
                                // color: Colors.black,
                                // fontSize: textSize + 4,
                                color: font.fonts.primaryFontColor,
                                fontSize: font.fonts.textSize + 4,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontType),
                          ),
                          TextSpan(
                            text:
                                'AI hallucinations are incorrect or misleading results that AI models generate. These errors can be caused by a variety of factors, including insufficient training data, incorrect assumptions made by the model, or biases in the data used to train the model.\n\nThe Liquid Galaxy project has no control over this, and the contents responsibility is of the owners of the respective Large Language models used',
                            style: TextStyle(
                                // color: Colors.black,
                                // fontSize: textSize,
                                color: font.fonts.primaryFontColor,
                                fontSize: font.fonts.textSize,
                                fontFamily: fontType),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const AppDescriptionWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const DevelopersInfoWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => launchUrlString(
                      'https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool'),
                  // _launchUrl(Uri.parse(
                  //     'https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool')),
                  child: Text(
                    'Project Github',
                    style: TextStyle(
                        fontFamily: fontType,
                        // fontSize: textSize,
                        fontSize: font.fonts.textSize,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                GestureDetector(
                  onTap: () => launchUrlString('https://www.liquidgalaxy.eu/'),
                  //  _launchUrl(Uri.parse('https://www.liquidgalaxy.eu/')),
                  child: Text(
                    'Liquid Galaxy Website',
                    style: TextStyle(
                        fontFamily: fontType,
                        // fontSize: textSize,
                        fontSize: font.fonts.textSize,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                GestureDetector(
                  onTap: () => launchUrlString(
                      'https://www.linkedin.com/in/mahinour-elsarky-122958216/'),
                  // _launchUrl(Uri.parse(
                  //     'https://www.linkedin.com/in/mahinour-elsarky-122958216/')),
                  child: Text(
                    'My LinkedIn',
                    style: TextStyle(
                        fontFamily: fontType,
                        // fontSize: textSize,
                        fontSize: font.fonts.textSize,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Consumer2<ColorProvider, FontsProvider>(
              builder:
                  (BuildContext context, ColorProvider value, FontsProvider font,
                      Widget? child) {
                return LgElevatedButton(
                  elevatedButtonContent: 'App Guide',
                  // buttonColor: PrimaryAppColors.buttonColors,
                  buttonColor: value.colors.buttonColors,
                  onpressed: () {},
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.2,
                  // fontSize: textSize,
                  fontSize: font.fonts.textSize,
                  fontColor: FontAppColors.secondaryFont,
                  isLoading: false,
                  isBold: true,
                  isPrefixIcon: false,
                  isSuffixIcon: false,
                  curvatureRadius: 50,
                );
              },
            ),
            const Icon(Icons.ads_click_rounded, size: 50),
            SettingsSharedPref.getTheme() == 'dark'
                ? Image.asset(
                    'assets/images/dark-logos.jpg',
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                  )
                : Image.asset(
                    'assets/images/Logos_Screen.jpg',
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 1,
                  ),
          ],
        );
      }),
    );
  }
}

class AppDescriptionWidget extends StatelessWidget {
  const AppDescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider, FontsProvider>(
      builder: (BuildContext context, ColorProvider value, FontsProvider font,
          Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // color: PrimaryAppColors.innerBackground,
              color: value.colors.innerBackground),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🌍 Escape the Everyday",
                style: TextStyle(
                    fontFamily: fontType,
                    // fontSize: textSize + 2,
                    fontSize: font.fonts.textSize + 2,
                    color: font.fonts.primaryFontColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "In the hustle and bustle of daily life, many seek an escape through travel—a means of relaxation, renewal, and exploration. However, the sheer abundance of information available online can make trip planning overwhelming. Navigating multiple websites, guidebooks, and apps to research destinations, attractions, and experiences can be daunting.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: fontType,
                  // fontSize: textSize,
                  fontSize: font.fonts.textSize,
                  color: font.fonts.primaryFontColor,
                ),
              ),
              Text(
                "✨ Simplify Your Journey",
                style: TextStyle(
                    fontFamily: fontType,
                    // fontSize: textSize + 2,
                    fontSize: font.fonts.textSize + 2,
                    color: font.fonts.primaryFontColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Our application aims to simplify the travel planning process and inspire users to embark on memorable journeys. Discovering the most captivating points of interest (POIs) tailored to your preferences has never been easier.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: fontType,
                  // fontSize: textSize,
                  fontSize: font.fonts.textSize,
                  color: font.fonts.primaryFontColor,
                ),
              ),
              Text(
                "🤖 Smart AI Recommendations",
                style: TextStyle(
                    fontFamily: fontType,
                    // fontSize: textSize + 2,
                    fontSize: font.fonts.textSize + 2,
                    color: font.fonts.primaryFontColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Leveraging GEMMA, one of the latest open-source generative text AI models, our app generates personalized POIs, running locally on the AI server at Lleida Lab using Docker technology.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: fontType,
                  // fontSize: textSize,
                  fontSize: font.fonts.textSize,
                  color: font.fonts.primaryFontColor,
                ),
              ),
              Text(
                "🌐 Immersive Visualizations",
                style: TextStyle(
                    fontFamily: fontType,
                    // fontSize: textSize + 2,
                    fontSize: font.fonts.textSize + 2,
                    color: font.fonts.primaryFontColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Through the innovative Liquid Galaxy technology, users can visualize their entire trip on an LG rig with three or more screens. The tours and their information are presented via KML (Keyhole Markup Language), creating stunning and unique visualizations on the LG rig.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: fontType,
                  // fontSize: textSize,
                  fontSize: font.fonts.textSize,
                  color: font.fonts.primaryFontColor,
                ),
              ),
              Text(
                "📱 Seamless Experience",
                style: TextStyle(
                    fontFamily: fontType,
                    // fontSize: textSize + 2,
                    fontSize: font.fonts.textSize + 2,
                    color: font.fonts.primaryFontColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Even without an LG rig, users will enjoy a captivating experience through our app, enhanced by integrated Google Maps. Simplify your travel planning and set out to discover the world with confidence and ease.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: fontType,
                  // fontSize: textSize,
                  fontSize: font.fonts.textSize,
                  color: font.fonts.primaryFontColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DevelopersInfoWidget extends StatelessWidget {
  const DevelopersInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider, FontsProvider>(
      builder: (BuildContext context, ColorProvider value, FontsProvider font,
          Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // color: PrimaryAppColors.innerBackground,
              color: value.colors.innerBackground),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contributor:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Organization:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Main-Mentors:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Organization Admin:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Co-Mentors:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Listener Contributors:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Liquid Galaxy LAB testers:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                ],
              ),
              AppDividerWidget(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Mahinour Elsarky",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Liquid Galaxy Project",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Claudia Diosan , Andreu Ibañez, Laura Morillo",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Andreu Ibañez",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Emilie Ma , Irene",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Vertika Bajpai",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                  Text(
                    "Liquid Galaxy LAB testers:",
                    style: TextStyle(
                      fontFamily: fontType,
                      // fontSize: textSize,
                      // color: FontAppColors.primaryFont
                      fontSize: font.fonts.textSize,
                      color: font.fonts.primaryFontColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
