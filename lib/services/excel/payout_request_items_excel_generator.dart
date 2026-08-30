import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:transfor_admin_dashboard/models/payout_request_item.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generatePayoutRequestItemsExcel({required List<PayoutRequestItem> items}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, 'Payout Items', [
    'Order #',
    'Amount',
    'Status',
    'Date',
  ]);

  for (final item in items) {
    sheet.appendRow([
      TextCellValue(item.orderNumber),
      DoubleCellValue(item.amount),
      TextCellValue(item.status),
      TextCellValue(item.date.split(' ').first),
    ]);
  }

  return saveExcelBytes(excel);
}
