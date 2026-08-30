import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:transfor_admin_dashboard/models/users_profile.dart';

import 'excel_generator_helpers.dart';

Future<Uint8List> generateUsersExcel({
  required List<UserProfile> users,
  bool showProviderTypeColumn = false,
}) async {
  final excel = Excel.createExcel();
  final sheet = buildSheet(excel, 'Users', [
    'No',
    'Name',
    'Mobile',
    'Email',
    'Date',
    if (showProviderTypeColumn) 'Provider Type',
  ]);

  for (final user in users) {
    sheet.appendRow([
      TextCellValue(user.id),
      TextCellValue(user.name),
      TextCellValue(user.mobile),
      TextCellValue(user.email),
      TextCellValue(user.createdAt.toIso8601String().split('T').first),
      if (showProviderTypeColumn) TextCellValue(user.providerTypeLabel),
    ]);
  }

  return saveExcelBytes(excel);
}
