import 'dart:typed_data';

import 'package:excel/excel.dart';

/// Creates a single-sheet workbook with a bold header row - shared by every
/// xxx_excel_generator.dart so each one only has to describe its own columns/rows.
Sheet buildSheet(Excel excel, String sheetName, List<String> headers) {
  // Excel.createExcel() always starts with one pre-existing sheet named
  // 'Sheet1'. excel[sheetName] creates a *new* sheet alongside it, so drop
  // the leftover default once ours exists - delete() only refuses when it's
  // the last remaining sheet, which is no longer true at that point.
  final sheet = excel[sheetName];
  if (sheetName != 'Sheet1' && excel.sheets.containsKey('Sheet1')) {
    excel.delete('Sheet1');
  }

  // ExcelColor.fromHexString expects 8 hex digits (ARGB), no '#'.
  final headerStyle = CellStyle(bold: true, backgroundColorHex: ExcelColor.fromHexString('FFFF6B00'), fontColorHex: ExcelColor.white);
  for (var i = 0; i < headers.length; i++) {
    final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
    cell.value = TextCellValue(headers[i]);
    cell.cellStyle = headerStyle;
  }
  return sheet;
}

Uint8List saveExcelBytes(Excel excel) {
  // encode() returns the same bytes as save() without save()'s Flutter-Web-only
  // side effect of auto-downloading via a hardcoded 'FlutterExcel.xlsx' name -
  // callers open/download the bytes themselves (see pdf_opener.dart's openExcel).
  final bytes = excel.encode();
  if (bytes == null) {
    throw Exception('Failed to generate Excel file');
  }
  return Uint8List.fromList(bytes);
}
