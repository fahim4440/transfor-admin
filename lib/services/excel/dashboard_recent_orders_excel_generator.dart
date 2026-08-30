import 'dart:typed_data';

import 'package:excel/excel.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generateRecentOrdersExcel({required List<dynamic> orders}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, 'Recent Orders', [
    'Order ID',
    'Customer',
    'Amount',
    'Status',
    'Date',
  ]);

  for (final order in orders) {
    sheet.appendRow([
      TextCellValue('#${order.orderNumber}'),
      TextCellValue(order.customerName as String),
      DoubleCellValue((order.amount as num).toDouble()),
      TextCellValue(order.getStatusLabel() as String),
      TextCellValue((order.date as String).substring(0, 10)),
    ]);
  }

  return saveExcelBytes(excel);
}
