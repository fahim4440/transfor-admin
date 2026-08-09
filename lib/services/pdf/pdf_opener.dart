// Default (non-web) impl uses dart:io + system default PDF viewer; web impl
// opens a real browser tab via dart:html. Both define `openPdf` with an
// identical signature so callers never branch on platform.
export 'pdf_opener_io.dart' if (dart.library.html) 'pdf_opener_web.dart';
