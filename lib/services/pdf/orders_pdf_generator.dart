import 'dart:typed_data';

import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:transfor_admin_dashboard/models/order.dart';

const _headers = ['No', 'Order #', 'Name', 'Mobile', 'Email', 'Amount', 'Type', 'Status', 'Date'];
const _cellStyle = pw.TextStyle(fontSize: 9);
const _cellPadding = pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4);

Future<Uint8List> generateOrdersPdf({
  required List<Order> orders,
  required String tabLabel,
  DateTime? filterFrom,
  DateTime? filterTo,
}) async {
  // Names/emails can contain Arabic text - the pdf package's default base font
  // (Helvetica) has no Arabic glyphs, so use a font with both Latin and Arabic
  // coverage as the whole document's base font.
  final arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);

  // The Riyal symbol font also has to be scoped to just the '⃁' glyph - its
  // cmap maps A-D to unrelated glyphs, so it must never be a document-wide font.
  final riyalFontData = await rootBundle.load('assets/fonts/saudi_riyal.ttf');
  final riyalFont = pw.Font.ttf(riyalFontData);

  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFont),
  );
  final dateFormat = DateFormat('yyyy-MM-dd');

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => [
        pw.Text('Orders Report', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text('Tab: $tabLabel', style: const pw.TextStyle(fontSize: 12)),
        if (filterFrom != null && filterTo != null)
          pw.Text(
            'Date range: ${dateFormat.format(filterFrom)} to ${dateFormat.format(filterTo)}',
            style: const pw.TextStyle(fontSize: 12),
          ),
        pw.Text(
          'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              children: [
                for (final header in _headers)
                  pw.Padding(
                    padding: _cellPadding,
                    child: pw.Text(
                      header,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
                    ),
                  ),
              ],
            ),
            for (int i = 0; i < orders.length; i++)
              pw.TableRow(
                children: [
                  _cell('${i + 1}'),
                  _cell(orders[i].orderNumber),
                  _cell(orders[i].userName),
                  _cell(orders[i].userMobile),
                  _cell(orders[i].userEmail),
                  _amountCell(orders[i].totalAmount, riyalFont),
                  _cell(orders[i].type),
                  _cell(orders[i].status),
                  _cell(orders[i].createdAt.toIso8601String().split('T').first),
                ],
              ),
          ],
        ),
      ],
    ),
  );

  return doc.save();
}

pw.Widget _cell(String text) {
  // pdf's own Arabic shaping is off by default (compile-time flag), so reshape
  // disjointed Arabic letters into connected forms ourselves; textDirection:
  // rtl then makes pdf's (on-by-default) bidi pass put them in visual order.
  final isArabic = ArabicReshaper.isArabic(text);
  final display = isArabic ? ArabicReshaper.instance.reshape(text) : text;
  return pw.Padding(
    padding: _cellPadding,
    child: pw.Text(
      display,
      style: _cellStyle,
      textDirection: isArabic ? pw.TextDirection.rtl : null,
    ),
  );
}

pw.Widget _amountCell(String amount, pw.Font riyalFont) {
  return pw.Padding(
    padding: _cellPadding,
    child: pw.RichText(
      text: pw.TextSpan(
        style: _cellStyle,
        children: [
          pw.TextSpan(text: '⃁', style: pw.TextStyle(font: riyalFont, fontSize: 9)),
          pw.TextSpan(text: ' $amount'),
        ],
      ),
    ),
  );
}
