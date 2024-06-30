

import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> _getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/samples.kml';
}


Future<void> overwriteKmlFile(String newContent) async {
  try {
    final path = await _getFilePath();
    final file = File(path);

    // Write the new content to the file
    await file.writeAsString(newContent);
    print('File content overwritten successfully.');
  } catch (e) {
    print('Error writing to the file: $e');
  }
}
