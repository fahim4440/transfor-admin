import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:transfor_admin_dashboard/models/wallet_transaction.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generateWalletTransactionsExcel({required List<WalletTransaction> transactions}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, 'Transactions', [
    'Type',
    'Amount',
    'Description',
    'Date',
    'Balance',
  ]);

  for (final tx in transactions) {
    sheet.appendRow([
      TextCellValue(tx.type),
      DoubleCellValue(tx.amount),
      TextCellValue(tx.description),
      TextCellValue(tx.date.toString().split(' ').first),
      DoubleCellValue(tx.balanceAfter),
    ]);
  }

  return saveExcelBytes(excel);
}
