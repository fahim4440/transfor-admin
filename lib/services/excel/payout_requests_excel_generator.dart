import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:transfor_admin_dashboard/models/payout_request.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generatePayoutRequestsExcel({required List<PayoutRequest> payoutRequests}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, 'Payout Requests', [
    'No',
    'Request ID',
    'Name',
    'Mobile',
    'Amount',
    'Date',
  ]);

  for (final payoutRequest in payoutRequests) {
    sheet.appendRow([
      TextCellValue(payoutRequest.id),
      TextCellValue('TRANS${payoutRequest.id}'),
      TextCellValue(payoutRequest.name),
      TextCellValue('${payoutRequest.ccode}${payoutRequest.mobile}'),
      DoubleCellValue(payoutRequest.tAmount),
      TextCellValue(payoutRequest.updatedAt.toIso8601String().split('T').first),
    ]);
  }

  return saveExcelBytes(excel);
}
