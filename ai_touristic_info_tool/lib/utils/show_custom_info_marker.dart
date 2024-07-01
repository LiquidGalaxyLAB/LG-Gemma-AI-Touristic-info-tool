// import 'package:flutter/material.dart';

// void showCustomInfoWindow(BuildContext context, String title, String snippet) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.0,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               snippet,
//               style: TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   ).then((_) {
//     // Additional actions can be handled here if needed
//   });
// }

// void closeCustomInfoWindow(BuildContext? dialogContext) {
//   if (dialogContext != null) {
//     Navigator.of(dialogContext, rootNavigator: true).pop();
//   }
// }
