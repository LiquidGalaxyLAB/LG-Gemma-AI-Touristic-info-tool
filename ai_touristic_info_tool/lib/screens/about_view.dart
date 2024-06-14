import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopBarWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "assets/images/appLogo.png",
                ),
                Text(
                  "LG Gemma \nAI Touristic Info Tool",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: titleSize,
                      color: FontAppColors.secondaryFont,
                      fontFamily: fontType,
                      fontWeight: FontWeight.bold),
                )
              ],
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
                onTap: () => _launchUrl(Uri.parse(
                    'https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool')),
                child: Text(
                  'Project Github',
                  style: TextStyle(
                      fontFamily: fontType,
                      fontSize: textSize,
                      color: Colors.blue,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    _launchUrl(Uri.parse('https://www.liquidgalaxy.eu/')),
                child: Text(
                  'Liquid Galaxy Website',
                  style: TextStyle(
                      fontFamily: fontType,
                      fontSize: textSize,
                      color: Colors.blue,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(Uri.parse(
                    'https://www.linkedin.com/in/mahinour-elsarky-122958216/')),
                child: Text(
                  'My LinkedIn',
                  style: TextStyle(
                      fontFamily: fontType,
                      fontSize: textSize,
                      color: Colors.blue,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          LgElevatedButton(
            elevatedButtonContent: 'Start App Tour!',
            buttonColor: PrimaryAppColors.buttonColors,
            onpressed: () {},
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.2,
            fontSize: textSize,
            fontColor: FontAppColors.secondaryFont,
            isLoading: false,
            isBold: true,
            isPrefixIcon: false,
            isSuffixIcon: false,
          ),
          const Icon(Icons.ads_click_rounded, size: 50),
          Image.asset(
            'assets/images/Logos_Screen.jpg',
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 1,
          ),
        ],
      ),
    );
  }
}

class AppDescriptionWidget extends StatelessWidget {
  const AppDescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: PrimaryAppColors.innerBackground),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🌍 Escape the Everyday",
            style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize + 2,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "In the hustle and bustle of daily life, many seek an escape through travel—a means of relaxation, renewal, and exploration. However, the sheer abundance of information available online can make trip planning overwhelming. Navigating multiple websites, guidebooks, and apps to research destinations, attractions, and experiences can be daunting.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: fontType,
              fontSize: textSize,
            ),
          ),
          Text(
            "✨ Simplify Your Journey",
            style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize + 2,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Our application aims to simplify the travel planning process and inspire users to embark on memorable journeys. Discovering the most captivating points of interest (POIs) tailored to your preferences has never been easier.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: fontType,
              fontSize: textSize,
            ),
          ),
          Text(
            "🤖 Smart AI Recommendations",
            style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize + 2,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Leveraging GEMMA, one of the latest open-source generative text AI models, our app generates personalized POIs, running locally on the AI server at Lleida Lab using Docker technology.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: fontType,
              fontSize: textSize,
            ),
          ),
          Text(
            "🌐 Immersive Visualizations",
            style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize + 2,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Through the innovative Liquid Galaxy technology, users can visualize their entire trip on an LG rig with three or more screens. The tours and their information are presented via KML (Keyhole Markup Language), creating stunning and unique visualizations on the LG rig.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: fontType,
              fontSize: textSize,
            ),
          ),
          Text(
            "📱 Seamless Experience",
            style: TextStyle(
                fontFamily: fontType,
                fontSize: textSize + 2,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Even without an LG rig, users will enjoy a captivating experience through our app, enhanced by integrated Google Maps. Simplify your travel planning and set out to discover the world with confidence and ease.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: fontType,
              fontSize: textSize,
            ),
          ),
        ],
      ),
    );
  }
}

class DevelopersInfoWidget extends StatelessWidget {
  const DevelopersInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: PrimaryAppColors.innerBackground,
      ),
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
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Organization:",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Main-Mentors:",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Organization Admin:",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Co-Mentors:",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Listener Contributors:",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Liquid Galaxy LAB testers:",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
            ],
          ),
          AppDividerWidget(height: MediaQuery.of(context).size.height * 0.2,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Mahinour Elsarky",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Liquid Galaxy Project",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Claudia Diosan , Andreu Ibañez, Laura Morillo",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Andreu Ibañez",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Emilie Ma , Irene",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Vertika Bajpai",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
              Text(
                "Liquid Galaxy LAB testers:",
                style: TextStyle(
                    fontFamily: fontType,
                    fontSize: textSize,
                    color: FontAppColors.primaryFont),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

