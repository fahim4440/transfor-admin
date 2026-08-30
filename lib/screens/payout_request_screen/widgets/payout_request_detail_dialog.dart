import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:transfor_admin_dashboard/blocs/payout_request/payout_request_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/app_data_grid_theme.dart';
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/models/payout_request.dart';
import 'package:transfor_admin_dashboard/models/payout_request_item.dart';
import 'package:transfor_admin_dashboard/screens/orders_screen/widgets/order_detail_dialog.dart';
import 'package:transfor_admin_dashboard/services/excel/payout_request_items_excel_generator.dart';
import 'package:transfor_admin_dashboard/services/payout_request_services.dart';
import 'package:transfor_admin_dashboard/services/pdf/pdf_opener.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

Future<void> showPayoutRequestDetailDialog(
  BuildContext context, {
  required PayoutRequest payoutRequest,
  required String userType,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (ctx) => BlocProvider.value(
      value: context.read<PayoutRequestBloc>(),
      child: PayoutRequestDetailDialog(payoutRequest: payoutRequest, userType: userType),
    ),
  );
}

class PayoutRequestDetailDialog extends StatefulWidget {
  final PayoutRequest payoutRequest;
  final String userType;
  const PayoutRequestDetailDialog({super.key, required this.payoutRequest, required this.userType});

  @override
  State<PayoutRequestDetailDialog> createState() => _PayoutRequestDetailDialogState();
}

class _PayoutRequestDetailDialogState extends State<PayoutRequestDetailDialog> {
  final PayoutRequestServices _services = PayoutRequestServices();
  bool isLoading = true;
  bool isGeneratingExcel = false;
  List<PayoutRequestItem> items = [];

  Future<void> _exportExcel() async {
    setState(() => isGeneratingExcel = true);
    try {
      final bytes = await generatePayoutRequestItemsExcel(items: items);
      final fileName = 'payout_items_${widget.payoutRequest.id}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Driver/Customer/Provider rows are all sums across potentially many
    // orders now - each has its own itemized endpoint mirroring the filter
    // that its Fetch*PayoutRequest summary query uses.
    final List<PayoutRequestItem>? fetched;
    if (widget.userType == 'Driver') {
      fetched = await _services.fetchDriverPayoutRequestItems(driverId: widget.payoutRequest.userId);
    } else if (widget.userType == 'Service Provider') {
      fetched = await _services.fetchProviderPayoutRequestItems(
        providerId: widget.payoutRequest.userId,
        orderType: widget.payoutRequest.type ?? 'orders',
      );
    } else {
      fetched = await _services.fetchUserPayoutRequestItems(
        userId: widget.payoutRequest.userId,
        orderType: widget.payoutRequest.type ?? 'orders',
      );
    }
    if (mounted) {
      setState(() {
        items = fetched ?? [];
        isLoading = false;
      });
    }
  }

  void _viewOrder(PayoutRequestItem item) {
    if (item.type == null) return; // e.g. a top-up refund - not an order
    showOrderDetailDialog(
      context,
      Order(
        id: item.orderId.toString(),
        userName: '',
        userCode: '',
        userMobile: '',
        userEmail: '',
        orderNumber: item.orderNumber,
        totalAmount: item.amount.toString(),
        totalQuantity: 0,
        status: item.status,
        type: item.type!,
        createdAt: DateTime.tryParse(item.date) ?? DateTime.now(),
      ),
    );
  }

  void _pay() {
    if (widget.userType == 'User') {
      context.read<PayoutRequestBloc>().add(PayToUser(
            userId: widget.payoutRequest.userId,
            userType: widget.userType,
            orderType: widget.payoutRequest.type!,
          ));
    } else if (widget.userType == 'Service Provider') {
      context.read<PayoutRequestBloc>().add(PayToProvider(
            providerId: widget.payoutRequest.userId,
            userType: widget.userType,
            orderType: widget.payoutRequest.type!,
          ));
    } else if (widget.userType == 'Driver') {
      context.read<PayoutRequestBloc>().add(PayToDriver(
            driverId: widget.payoutRequest.userId,
            userType: widget.userType,
          ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.payoutRequest.name} - Payout Details',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Requested on: ${widget.payoutRequest.updatedAt.toIso8601String().split('T').first}',
                        style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Export to Excel',
                    onPressed: isGeneratingExcel || items.isEmpty ? null : _exportExcel,
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
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const Center(child: Text('No items found'))
                      : Padding(
                          padding: const EdgeInsets.all(20),
                          child: SfDataGridTheme(
                            data: appDataGridTheme,
                            child: SfDataGrid(
                              source: _PayoutItemsDataSource(items: items, onView: _viewOrder),
                              columns: [
                                GridColumn(columnName: 'orderNumber', label: dataGridHeaderText('Order #'), width: 130),
                                GridColumn(columnName: 'amount', label: dataGridHeaderText('Amount'), width: 120),
                                GridColumn(columnName: 'status', label: dataGridHeaderText('Status'), width: 110),
                                GridColumn(columnName: 'date', label: dataGridHeaderText('Date'), width: 110),
                                GridColumn(
                                  columnName: 'action',
                                  label: dataGridHeaderText('Action'),
                                  width: 90,
                                  allowSorting: false,
                                  allowFiltering: false,
                                ),
                              ],
                              allowSorting: true,
                              allowFiltering: true,
                              allowColumnsResizing: true,
                              columnResizeMode: ColumnResizeMode.onResize,
                              headerRowHeight: 40,
                              rowHeight: 48,
                              gridLinesVisibility: GridLinesVisibility.horizontal,
                              headerGridLinesVisibility: GridLinesVisibility.horizontal,
                            ),
                          ),
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: _pay,
                    child: const Text('Pay', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayoutItemsDataSource extends DataGridSource {
  _PayoutItemsDataSource({required List<PayoutRequestItem> items, required this.onView}) {
    _items = items;
    _rows = items.map((item) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'orderNumber', value: item.orderNumber),
        DataGridCell<String>(columnName: 'amount', value: item.amount.toStringAsFixed(2)),
        DataGridCell<String>(columnName: 'status', value: item.status),
        DataGridCell<String>(columnName: 'date', value: item.date.split(' ').first),
        DataGridCell<String>(columnName: 'action', value: item.orderNumber),
      ]);
    }).toList();
  }

  final void Function(PayoutRequestItem item) onView;
  late List<PayoutRequestItem> _items;
  late List<DataGridRow> _rows;

  PayoutRequestItem _itemForRow(DataGridRow row) {
    final orderNumber = row.getCells().firstWhere((cell) => cell.columnName == 'orderNumber').value as String;
    return _items.firstWhere((item) => item.orderNumber == orderNumber);
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        switch (cell.columnName) {
          case 'amount':
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '⃁ ${cell.value}',
                  style: const TextStyle(color: AppColors.text, fontFamilyFallback: ['SaudiRiyal']),
                ),
              ),
            );
          case 'action':
            final item = _itemForRow(row);
            return Align(
              alignment: Alignment.center,
              child: item.type == null
                  ? const SizedBox.shrink()
                  : TextButton(onPressed: () => onView(item), child: const Text('View')),
            );
          default:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(cell.value.toString(), style: const TextStyle(color: AppColors.text)),
              ),
            );
        }
      }).toList(),
    );
  }
}
