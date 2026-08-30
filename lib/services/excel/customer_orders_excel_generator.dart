import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:transfor_admin_dashboard/models/customer_order.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generateCustomerOrdersExcel({
  required List<CustomerOrder> orders,
  required String sheetName,
}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, sheetName, [
    'Order #',
    'Amount',
    'Type',
    'Date',
    'Rating',
    'Feedback',
  ]);

  for (final order in orders) {
    sheet.appendRow([
      TextCellValue(order.orderNumber),
      DoubleCellValue(order.amount),
      TextCellValue(order.type),
      TextCellValue(order.date.toString().split(' ').first),
      TextCellValue(order.rating?.toStringAsFixed(1) ?? '-'),
      TextCellValue(order.feedback ?? '-'),
    ]);
  }

  return saveExcelBytes(excel);
}
