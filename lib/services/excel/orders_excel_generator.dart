import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:transfor_admin_dashboard/models/order.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generateOrdersExcel({required List<Order> orders}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, 'Orders', [
    'No',
    'Order #',
    'Name',
    'Mobile',
    'Email',
    'Amount',
    'Type',
    'Status',
    'Date',
  ]);

  for (final order in orders) {
    sheet.appendRow([
      TextCellValue(order.id.toString()),
      TextCellValue(order.orderNumber),
      TextCellValue(order.userName),
      TextCellValue(order.userMobile),
      TextCellValue(order.userEmail),
      TextCellValue(order.totalAmount),
      TextCellValue(order.type),
      TextCellValue(order.status),
      TextCellValue(order.createdAt.toIso8601String().split('T').first),
    ]);
  }

  return saveExcelBytes(excel);
}
