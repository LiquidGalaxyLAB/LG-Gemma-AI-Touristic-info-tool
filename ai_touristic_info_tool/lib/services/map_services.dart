

import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class MapService{
Future<Uint8List> getBytesFromAsset({required String path, required int width}) async {
  final ByteData _data = await rootBundle.load(path);
  final ui.Codec _codec = await ui.instantiateImageCodec(_data.buffer.asUint8List(), targetWidth: width);
  final ui.FrameInfo _fi = await _codec.getNextFrame();
  final Uint8List _bytes = (await _fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  return _bytes;
}
}
