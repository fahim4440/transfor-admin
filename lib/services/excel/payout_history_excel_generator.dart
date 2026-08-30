import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:transfor_admin_dashboard/models/payout_history.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generatePayoutHistoryExcel({required List<PayoutHistory> payoutHistories}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, 'Payout History', [
    'No',
    'Request ID',
    'Order #',
    'Name',
    'Mobile',
    'Amount',
    'Date',
  ]);

  for (final payoutHistory in payoutHistories) {
    sheet.appendRow([
      TextCellValue(payoutHistory.id),
      TextCellValue('TRANS${payoutHistory.id}'),
      TextCellValue(payoutHistory.orderNumber),
      TextCellValue(payoutHistory.name),
      TextCellValue('${payoutHistory.ccode}${payoutHistory.mobile}'),
      DoubleCellValue(payoutHistory.tAmount),
      TextCellValue(payoutHistory.updatedAt.toIso8601String().split('T').first),
    ]);
  }

  return saveExcelBytes(excel);
}
