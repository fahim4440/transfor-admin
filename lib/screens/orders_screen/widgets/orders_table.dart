import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../global_widgets/app_data_grid_theme.dart';
import '../../../models/order.dart';
import '../../../utilities/app_strings.dart';
import '../../../utilities/colors.dart';
import '../../users_screen/widgets/button.dart';
import 'order_detail_dialog.dart';

class OrdersTable extends StatefulWidget {
  final List<Order> orders;
  const OrdersTable({super.key, required this.orders});

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
  late _OrdersDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _OrdersDataSource(orders: widget.orders, onView: _viewOrder);
  }

  @override
  void didUpdateWidget(covariant OrdersTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orders != widget.orders) {
      _dataSource.updateOrders(widget.orders);
    }
  }

  void _viewOrder(Order order) => showOrderDetailDialog(context, order);

  List<GridColumn> _buildColumns(BuildContext context) {
    return [
      GridColumn(columnName: 'id', label: dataGridHeaderText(AppStrings.no.translate(context)), width: 90, allowFiltering: false),
      GridColumn(columnName: 'orderNumber', label: dataGridHeaderText(AppStrings.orderNo.translate(context)), width: 140),
      GridColumn(columnName: 'userName', label: dataGridHeaderText(AppStrings.name.translate(context)), width: 160),
      GridColumn(columnName: 'userMobile', label: dataGridHeaderText(AppStrings.mobile.translate(context)), width: 140),
      GridColumn(columnName: 'userEmail', label: dataGridHeaderText(AppStrings.email.translate(context)), width: 200),
      GridColumn(columnName: 'totalAmount', label: dataGridHeaderText(AppStrings.amount.translate(context)), width: 120),
      GridColumn(columnName: 'type', label: dataGridHeaderText(AppStrings.type.translate(context)), width: 110),
      GridColumn(columnName: 'status', label: dataGridHeaderText(AppStrings.status.translate(context)), width: 140),
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

class _OrdersDataSource extends DataGridSource {
  _OrdersDataSource({required List<Order> orders, required this.onView}) {
    _orders = orders;
    _rows = _rowsFor(_orders);
  }

  final void Function(Order order) onView;
  late List<Order> _orders;
  late List<DataGridRow> _rows;

  List<DataGridRow> _rowsFor(List<Order> orders) {
    return orders.map((order) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: order.id.toString()),
        DataGridCell<String>(columnName: 'orderNumber', value: order.orderNumber),
        DataGridCell<String>(columnName: 'userName', value: order.userName),
        DataGridCell<String>(columnName: 'userMobile', value: order.userMobile),
        DataGridCell<String>(columnName: 'userEmail', value: order.userEmail),
        DataGridCell<String>(columnName: 'totalAmount', value: order.totalAmount),
        DataGridCell<String>(columnName: 'type', value: order.type),
        DataGridCell<String>(columnName: 'status', value: order.status),
        DataGridCell<String>(columnName: 'date', value: order.createdAt.toIso8601String().split('T').first),
        DataGridCell<String>(columnName: 'action', value: order.id.toString()),
      ]);
    }).toList();
  }

  void updateOrders(List<Order> orders) {
    _orders = orders;
    _rows = _rowsFor(_orders);
    notifyListeners();
  }

  Order _orderForRow(DataGridRow row) {
    final id = row.getCells().firstWhere((cell) => cell.columnName == 'id').value as String;
    return _orders.firstWhere((order) => order.id.toString() == id);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Processing':
        return AppColors.green;
      case 'Order Placed':
        return AppColors.primary;
      case 'Completed':
        return AppColors.green;
      case 'Cancelled':
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        switch (cell.columnName) {
          case 'status':
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(cell.value.toString(), style: TextStyle(color: _statusColor(cell.value.toString()))),
              ),
            );
          case 'action':
            final order = _orderForRow(row);
            return Align(
              alignment: Alignment.center,
              child: actionButton("View", Colors.teal, () => onView(order)),
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
