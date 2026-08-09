import 'dart:html' as html;
import 'dart:typed_data';

Future<void> openPdf(Uint8List bytes, String fileName) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  // Give the new tab time to load the blob before revoking it.
  Future.delayed(const Duration(minutes: 1), () => html.Url.revokeObjectUrl(url));
}
