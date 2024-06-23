// import 'package:ai_touristic_info_tool/constants.dart';
// import 'package:flutter/material.dart';

// class PopularActivitiesContainer extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   const PopularActivitiesContainer({super.key, required this.title, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.3,
//       width: MediaQuery.of(context).size.width * 0.2,
//       decoration: BoxDecoration(
//         color: PrimaryAppColors.accentColor,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Column(
//         children: [
//           ClipRRect(
//               borderRadius: BorderRadius.circular(26),
//               child: Image.asset(
//                 imagePath,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),),
//           Text(title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: PrimaryAppColors.gradient1,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: fontType,
//                 fontSize: textSize + 4,
//               ))
//         ],
//       ),
//     );
//   }
// }
