import 'dart:html' as html;
import 'dart:typed_data';

Future<void> openPdf(Uint8List bytes, String fileName) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  // Give the new tab time to load the blob before revoking it.
  Future.delayed(const Duration(minutes: 1), () => html.Url.revokeObjectUrl(url));
}

Future<void> openExcel(Uint8List bytes, String fileName) async {
  final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  final url = html.Url.createObjectUrlFromBlob(blob);
  // Browsers can't render xlsx inline, so this downloads it under fileName
  // instead of opening a blank tab.
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  Future.delayed(const Duration(minutes: 1), () => html.Url.revokeObjectUrl(url));
}
