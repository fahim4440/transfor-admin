import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:transfor_admin_dashboard/blocs/payout_history/payout_history_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/app_data_grid_theme.dart';
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/models/payout_history.dart';
import 'package:transfor_admin_dashboard/screens/orders_screen/widgets/order_detail_dialog.dart';
import 'package:transfor_admin_dashboard/services/excel/payout_history_excel_generator.dart';
import 'package:transfor_admin_dashboard/services/pdf/payout_history_pdf_generator.dart';
import 'package:transfor_admin_dashboard/services/pdf/pdf_opener.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

import '../../global_widgets/seachbox.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/colors.dart';

class PayoutHistoryScreen extends StatefulWidget {
  const PayoutHistoryScreen({super.key});

  @override
  State<PayoutHistoryScreen> createState() => _PayoutHistoryScreenState();
}

class _PayoutHistoryScreenState extends State<PayoutHistoryScreen> {
  static const _pageSize = 10;

  DateTime? filterFrom;
  DateTime? filterTo;
  int currentPage = 0;
  bool isGeneratingPdf = false;
  bool isGeneratingExcel = false;

  Future<void> _printPdf(List<PayoutHistory> payoutHistories) async {
    setState(() => isGeneratingPdf = true);
    try {
      final bytes = await generatePayoutHistoryPdf(
        payoutHistories: payoutHistories,
        filterFrom: filterFrom,
        filterTo: filterTo,
      );
      final fileName = 'payout_history_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await openPdf(bytes, fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isGeneratingPdf = false);
    }
  }

  Future<void> _exportExcel(List<PayoutHistory> payoutHistories) async {
    setState(() => isGeneratingExcel = true);
    try {
      final bytes = await generatePayoutHistoryExcel(payoutHistories: payoutHistories);
      final fileName = 'payout_history_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      await openExcel(bytes, fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate Excel file: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isGeneratingExcel = false);
    }
  }

  void _showError(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: AppStrings.fetchError.translate(context),
      desc: message,
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    context.read<PayoutHistoryBloc>().add(PayoutHistoryLoadingInitiate());
  }

  Future<void> _pickFilterDate({required bool isFrom}) async {
    final initial = (isFrom ? filterFrom : filterTo) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        filterFrom = picked;
      } else {
        filterTo = picked;
      }
      currentPage = 0;
    });
  }

  void _clearFilter() {
    setState(() {
      filterFrom = null;
      filterTo = null;
      currentPage = 0;
    });
  }

  List<PayoutHistory> _applyDateFilter(List<PayoutHistory> payoutHistories) {
    if (filterFrom == null || filterTo == null) return payoutHistories;
    final from = DateTime(filterFrom!.year, filterFrom!.month, filterFrom!.day);
    final to = DateTime(filterTo!.year, filterTo!.month, filterTo!.day, 23, 59, 59);
    return payoutHistories.where((payoutHistory) {
      return !payoutHistory.updatedAt.isBefore(from) && !payoutHistory.updatedAt.isAfter(to);
    }).toList();
  }

  void _viewOrder(PayoutHistory payoutHistory) {
    if (payoutHistory.type == null || payoutHistory.type == 'Top-up') return; // not an order
    showOrderDetailDialog(
      context,
      Order(
        id: payoutHistory.id,
        userName: payoutHistory.name,
        userCode: payoutHistory.ccode,
        userMobile: payoutHistory.mobile,
        userEmail: '',
        orderNumber: payoutHistory.orderNumber,
        totalAmount: payoutHistory.tAmount.toString(),
        totalQuantity: 0,
        status: 'Completed',
        type: payoutHistory.type!,
        createdAt: payoutHistory.updatedAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayoutHistoryBloc, PayoutHistoryState>(
      listener: (context, state) {
        if (state is PayoutHistoryFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        if (state is PayoutHistoryLoaded) {
          final dateFormat = DateFormat('yyyy-MM-dd');
          final isFilterReady = filterFrom != null && filterTo != null;
          final isFilterValid = !isFilterReady || !filterFrom!.isAfter(filterTo!);
          final visiblePayoutHistories =
              isFilterValid ? _applyDateFilter(state.filteredPayoutHistories) : state.filteredPayoutHistories;
          final totalPages = (visiblePayoutHistories.length / _pageSize).ceil();
          final safePage = totalPages == 0 ? 0 : currentPage.clamp(0, totalPages - 1);
          if (safePage != currentPage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => currentPage = safePage);
            });
          }
          final pagedPayoutHistories =
              visiblePayoutHistories.skip(safePage * _pageSize).take(_pageSize).toList();

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: SearchBox(searchType: 'Payout Request')),
                    IconButton(
                      tooltip: 'Print PDF',
                      onPressed: isGeneratingPdf || pagedPayoutHistories.isEmpty
                          ? null
                          : () => _printPdf(pagedPayoutHistories),
                      icon: isGeneratingPdf
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.picture_as_pdf),
                    ),
                    IconButton(
                      tooltip: 'Export to Excel',
                      onPressed: isGeneratingExcel || pagedPayoutHistories.isEmpty
                          ? null
                          : () => _exportExcel(pagedPayoutHistories),
                      icon: isGeneratingExcel
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.grid_on),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: () => _pickFilterDate(isFrom: true),
                      child: Text(filterFrom == null ? 'From date' : dateFormat.format(filterFrom!)),
                    ),
                    OutlinedButton(
                      onPressed: () => _pickFilterDate(isFrom: false),
                      child: Text(filterTo == null ? 'To date' : dateFormat.format(filterTo!)),
                    ),
                    if (filterFrom != null || filterTo != null)
                      TextButton(
                        onPressed: _clearFilter,
                        child: Text('Clear'),
                      ),
                  ],
                ),
                if (isFilterReady && !isFilterValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '"From date" must be before "To date"',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: SfDataGridTheme(
                    data: appDataGridTheme,
                    child: SfDataGrid(
                      source: _PayoutHistoryDataSource(
                        payoutHistories: pagedPayoutHistories,
                        onView: _viewOrder,
                        paidLabel: AppStrings.paid.translate(context),
                      ),
                      columns: [
                        GridColumn(columnName: 'id', label: dataGridHeaderText(AppStrings.no.translate(context)), width: 90, allowFiltering: false),
                        GridColumn(columnName: 'requestId', label: dataGridHeaderText(AppStrings.requestId.translate(context)), width: 130),
                        GridColumn(columnName: 'orderNumber', label: dataGridHeaderText(AppStrings.orderNo.translate(context)), width: 140),
                        GridColumn(columnName: 'name', label: dataGridHeaderText(AppStrings.name.translate(context)), width: 160),
                        GridColumn(columnName: 'mobile', label: dataGridHeaderText(AppStrings.mobile.translate(context)), width: 150),
                        GridColumn(columnName: 'amount', label: dataGridHeaderText(AppStrings.amount.translate(context)), width: 120),
                        GridColumn(columnName: 'date', label: dataGridHeaderText(AppStrings.date.translate(context)), width: 130),
                        GridColumn(
                          columnName: 'action',
                          label: dataGridHeaderText(AppStrings.action.translate(context)),
                          width: 110,
                          allowSorting: false,
                          allowFiltering: false,
                        ),
                      ],
                      allowSorting: true,
                      allowFiltering: true,
                      allowColumnsResizing: true,
                      columnResizeMode: ColumnResizeMode.onResize,
                      headerRowHeight: 44,
                      rowHeight: 52,
                      gridLinesVisibility: GridLinesVisibility.horizontal,
                      headerGridLinesVisibility: GridLinesVisibility.horizontal,
                    ),
                  ),
                ),
                if (totalPages > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: safePage > 0 ? () => setState(() => currentPage = safePage - 1) : null,
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text('Page ${safePage + 1} of $totalPages'),
                        IconButton(
                          onPressed: safePage < totalPages - 1 ? () => setState(() => currentPage = safePage + 1) : null,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        } else if (state is PayoutHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class _PayoutHistoryDataSource extends DataGridSource {
  _PayoutHistoryDataSource({
    required List<PayoutHistory> payoutHistories,
    required this.onView,
    required this.paidLabel,
  }) {
    _payoutHistories = payoutHistories;
    _rows = payoutHistories.map((payoutHistory) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: payoutHistory.id),
        DataGridCell<String>(columnName: 'requestId', value: 'TRANS${payoutHistory.id}'),
        DataGridCell<String>(columnName: 'orderNumber', value: payoutHistory.orderNumber),
        DataGridCell<String>(columnName: 'name', value: payoutHistory.name),
        DataGridCell<String>(columnName: 'mobile', value: '${payoutHistory.ccode}${payoutHistory.mobile}'),
        DataGridCell<String>(columnName: 'amount', value: payoutHistory.tAmount.toString()),
        DataGridCell<String>(columnName: 'date', value: payoutHistory.updatedAt.toIso8601String().split('T').first),
        DataGridCell<String>(columnName: 'action', value: payoutHistory.id),
      ]);
    }).toList();
  }

  final void Function(PayoutHistory payoutHistory) onView;
  final String paidLabel;
  late List<PayoutHistory> _payoutHistories;
  late List<DataGridRow> _rows;

  PayoutHistory _historyForRow(DataGridRow row) {
    final id = row.getCells().firstWhere((cell) => cell.columnName == 'id').value as String;
    return _payoutHistories.firstWhere((history) => history.id == id);
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'action') {
          final payoutHistory = _historyForRow(row);
          final canView = payoutHistory.type != null && payoutHistory.type != 'Top-up';
          return Align(
            alignment: Alignment.center,
            child: canView
                ? TextButton(onPressed: () => onView(payoutHistory), child: const Text('View'))
                : Text(paidLabel, style: const TextStyle(color: AppColors.text)),
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
