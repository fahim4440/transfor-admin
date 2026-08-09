import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openPdf(Uint8List bytes, String fileName) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes, flush: true);

  final uri = Uri.file(file.path);
  final opened = await launchUrl(uri);
  if (!opened) {
    throw Exception('Could not open PDF at ${file.path}');
  }
}
