import 'package:flutter/material.dart';

import '../../../models/payout_request.dart';
import '../../../utilities/app_strings.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/text_styles.dart';
import '../../users_screen/widgets/button.dart';
import 'payout_request_detail_dialog.dart';

class PayoutRequestsTable extends StatefulWidget {
  final List<PayoutRequest> payoutRequests;
  final String userType;
  const PayoutRequestsTable({super.key, required this.payoutRequests, required this.userType});

  @override
  State<PayoutRequestsTable> createState() => _PayoutRequestsTableState();
}

class _PayoutRequestsTableState extends State<PayoutRequestsTable> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  int rowIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingTextStyle: AppTextStyles.whiteNormalText,
          headingRowColor: WidgetStateColor.resolveWith(
            (states) => AppColors.primary,
          ),
          sortAscending: _isSortAsc,
          sortColumnIndex: _currentSortColumn,
          dividerThickness: 0.0,
          dataRowMaxHeight: 80,
          columns: [
            DataColumn(label: Text(AppStrings.no.translate(context))),
            DataColumn(
              label: Text(AppStrings.requestId.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.payoutRequests.sort((a, b) => b.id.compareTo(a.id));
                  } else {
                    widget.payoutRequests.sort((a, b) => a.id.compareTo(b.id));
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.name.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.payoutRequests.sort((a, b) => b.name.compareTo(a.name));
                  } else {
                    widget.payoutRequests.sort((a, b) => a.name.compareTo(b.name));
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.mobile.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.payoutRequests.sort((a, b) => b.mobile.compareTo(a.mobile));
                  } else {
                    widget.payoutRequests.sort((a, b) => a.mobile.compareTo(b.mobile));
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.amount.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.payoutRequests.sort(
                      (a, b) => b.tAmount.compareTo(a.tAmount),
                    );
                  } else {
                    widget.payoutRequests.sort(
                      (a, b) => a.tAmount.compareTo(b.tAmount),
                    );
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.date.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.payoutRequests.sort(
                      (a, b) => b.updatedAt.compareTo(a.updatedAt),
                    );
                  } else {
                    widget.payoutRequests.sort(
                      (a, b) => a.updatedAt.compareTo(b.updatedAt),
                    );
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(label: Text(AppStrings.action.translate(context))),
          ],
          rows:
              widget.payoutRequests.map((payoutRequest) {
                rowIndex = rowIndex + 1;
                return DataRow(
                  color:
                      rowIndex % 2 == 1
                          ? WidgetStateColor.resolveWith(
                            (states) => AppColors.background,
                          )
                          : WidgetStateColor.resolveWith(
                            (states) =>
                                AppColors.drawerBgColor!.withOpacity(0.1),
                          ),
                  cells: [
                    DataCell(Text(payoutRequest.id.toString())),
                    DataCell(Text('TRANS${payoutRequest.id.toString()}')),
                    DataCell(Text(payoutRequest.name)),
                    DataCell(Text('${payoutRequest.ccode}${payoutRequest.mobile}')),
                    DataCell(Text(payoutRequest.tAmount.toString())),
                    DataCell(
                      Text(payoutRequest.updatedAt.toIso8601String().split('T').first),
                    ),
                    DataCell(
                      actionButton("View", Colors.teal, () {
                        showPayoutRequestDetailDialog(
                          context,
                          payoutRequest: payoutRequest,
                          userType: widget.userType,
                        );
                      }),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
