import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../global_widgets/app_data_grid_theme.dart';
import '../../../models/payout_request.dart';
import '../../../utilities/app_strings.dart';
import '../../../utilities/colors.dart';
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
  late _PayoutRequestsDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _PayoutRequestsDataSource(payoutRequests: widget.payoutRequests, onView: _viewRequest);
  }

  @override
  void didUpdateWidget(covariant PayoutRequestsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.payoutRequests != widget.payoutRequests) {
      _dataSource.updatePayoutRequests(widget.payoutRequests);
    }
  }

  void _viewRequest(PayoutRequest payoutRequest) {
    showPayoutRequestDetailDialog(context, payoutRequest: payoutRequest, userType: widget.userType);
  }

  List<GridColumn> _buildColumns(BuildContext context) {
    return [
      GridColumn(columnName: 'id', label: dataGridHeaderText(AppStrings.no.translate(context)), width: 90, allowFiltering: false),
      GridColumn(columnName: 'requestId', label: dataGridHeaderText(AppStrings.requestId.translate(context)), width: 140),
      GridColumn(columnName: 'name', label: dataGridHeaderText(AppStrings.name.translate(context)), width: 180),
      GridColumn(columnName: 'mobile', label: dataGridHeaderText(AppStrings.mobile.translate(context)), width: 150),
      GridColumn(columnName: 'amount', label: dataGridHeaderText(AppStrings.amount.translate(context)), width: 130),
      GridColumn(columnName: 'date', label: dataGridHeaderText(AppStrings.date.translate(context)), width: 130),
      GridColumn(
        columnName: 'action',
        label: dataGridHeaderText(AppStrings.action.translate(context)),
        width: 110,
        allowSorting: false,
        allowFiltering: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: appDataGridTheme,
      child: SfDataGrid(
        source: _dataSource,
        columns: _buildColumns(context),
        allowSorting: true,
        allowFiltering: true,
        allowColumnsResizing: true,
        columnResizeMode: ColumnResizeMode.onResize,
        headerRowHeight: 44,
        rowHeight: 52,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        headerGridLinesVisibility: GridLinesVisibility.horizontal,
      ),
    );
  }
}

class _PayoutRequestsDataSource extends DataGridSource {
  _PayoutRequestsDataSource({required List<PayoutRequest> payoutRequests, required this.onView}) {
    _payoutRequests = payoutRequests;
    _rows = _rowsFor(_payoutRequests);
  }

  final void Function(PayoutRequest payoutRequest) onView;
  late List<PayoutRequest> _payoutRequests;
  late List<DataGridRow> _rows;

  List<DataGridRow> _rowsFor(List<PayoutRequest> payoutRequests) {
    return payoutRequests.map((payoutRequest) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: payoutRequest.id),
        DataGridCell<String>(columnName: 'requestId', value: 'TRANS${payoutRequest.id}'),
        DataGridCell<String>(columnName: 'name', value: payoutRequest.name),
        DataGridCell<String>(columnName: 'mobile', value: '${payoutRequest.ccode}${payoutRequest.mobile}'),
        DataGridCell<String>(columnName: 'amount', value: payoutRequest.tAmount.toString()),
        DataGridCell<String>(columnName: 'date', value: payoutRequest.updatedAt.toIso8601String().split('T').first),
        DataGridCell<String>(columnName: 'action', value: payoutRequest.id),
      ]);
    }).toList();
  }

  void updatePayoutRequests(List<PayoutRequest> payoutRequests) {
    _payoutRequests = payoutRequests;
    _rows = _rowsFor(_payoutRequests);
    notifyListeners();
  }

  PayoutRequest _requestForRow(DataGridRow row) {
    final id = row.getCells().firstWhere((cell) => cell.columnName == 'id').value as String;
    return _payoutRequests.firstWhere((request) => request.id == id);
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'action') {
          final payoutRequest = _requestForRow(row);
          return Align(
            alignment: Alignment.center,
            child: actionButton("View", Colors.teal, () => onView(payoutRequest)),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(cell.value.toString(), style: const TextStyle(color: AppColors.text)),
          ),
        );
      }).toList(),
    );
  }
}
