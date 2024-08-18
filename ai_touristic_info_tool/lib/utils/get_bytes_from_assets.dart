import 'dart:ui' as ui;
import 'package:flutter/services.dart';

/// This function loads an image from the asset bundle, resizes it to the specified width,
/// and then returns the image as a `Uint8List` of bytes in PNG format.
///
/// Parameters:
/// - `path`: The file path to the asset image within the project.
/// - `width`: The desired width for the image. The image will be resized proportionally to this width.
///
/// Returns:
/// - A `Future<Uint8List>` that completes with the image bytes in PNG format.
///
/// Usage:
/// ```dart
/// Uint8List imageBytes = await getBytesFromAsset(path: 'assets/my_image.png', width: 100);
/// 
/// 
Future<Uint8List> getBytesFromAsset({required String path, required int width}) async {
  final ByteData _data = await rootBundle.load(path);
  final ui.Codec _codec = await ui.instantiateImageCodec(_data.buffer.asUint8List(), targetWidth: width);
  final ui.FrameInfo _fi = await _codec.getNextFrame();
  final Uint8List _bytes = (await _fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  return _bytes;
}