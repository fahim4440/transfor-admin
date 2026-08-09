import 'dart:typed_data';

import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:transfor_admin_dashboard/models/payout_request.dart';

const _headers = ['Request ID', 'Name', 'Mobile', 'Amount', 'Date'];
const _cellStyle = pw.TextStyle(fontSize: 9);
const _cellPadding = pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4);

Future<Uint8List> generatePayoutRequestsPdf({
  required List<PayoutRequest> payoutRequests,
  required String categoryLabel,
  DateTime? filterFrom,
  DateTime? filterTo,
}) async {
  final arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);
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
        pw.Text('Payout Requests', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text('Category: $categoryLabel', style: const pw.TextStyle(fontSize: 12)),
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
            for (final payoutRequest in payoutRequests)
              pw.TableRow(
                children: [
                  _cell('TRANS${payoutRequest.id}'),
                  _nameCell(payoutRequest.name),
                  _cell('${payoutRequest.ccode}${payoutRequest.mobile}'),
                  _amountCell(payoutRequest.tAmount.toStringAsFixed(2), riyalFont),
                  _cell(payoutRequest.updatedAt.toIso8601String().split('T').first),
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
  return pw.Padding(
    padding: _cellPadding,
    child: pw.Text(text, style: _cellStyle),
  );
}

pw.Widget _nameCell(String name) {
  final isArabic = ArabicReshaper.isArabic(name);
  final display = isArabic ? ArabicReshaper.instance.reshape(name) : name;
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
