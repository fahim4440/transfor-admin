import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/order.dart';
import '../../../utilities/app_strings.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/text_styles.dart';
import '../../users_screen/widgets/button.dart';
import 'order_detail_dialog.dart';

class OrdersTable extends StatefulWidget {
  final List<Order> orders;
  const OrdersTable({super.key, required this.orders});

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
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
              label: Text(AppStrings.orderNo.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.orders.sort((a, b) => b.orderNumber.compareTo(a.orderNumber));
                  } else {
                    widget.orders.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
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
                    widget.orders.sort((a, b) => b.userName.compareTo(a.userName));
                  } else {
                    widget.orders.sort((a, b) => a.userName.compareTo(b.userName));
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
                    widget.orders.sort((a, b) => b.userMobile.compareTo(a.userMobile));
                  } else {
                    widget.orders.sort((a, b) => a.userMobile.compareTo(b.userMobile));
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.email.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.orders.sort(
                      (a, b) => b.userEmail.compareTo(a.userEmail),
                    );
                  } else {
                    widget.orders.sort(
                      (a, b) => a.userEmail.compareTo(b.userEmail),
                    );
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
                    widget.orders.sort(
                      (a, b) => b.totalAmount.compareTo(a.totalAmount),
                    );
                  } else {
                    widget.orders.sort(
                      (a, b) => a.totalAmount.compareTo(b.totalAmount),
                    );
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.type.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.orders.sort(
                      (a, b) => b.type.compareTo(a.type),
                    );
                  } else {
                    widget.orders.sort(
                      (a, b) => a.type.compareTo(b.type),
                    );
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.status.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.orders.sort(
                      (a, b) => b.status.compareTo(a.status),
                    );
                  } else {
                    widget.orders.sort(
                      (a, b) => a.status.compareTo(b.status),
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
                    widget.orders.sort(
                      (a, b) => b.createdAt.compareTo(a.createdAt),
                    );
                  } else {
                    widget.orders.sort(
                      (a, b) => a.createdAt.compareTo(b.createdAt),
                    );
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(label: Text(AppStrings.action.translate(context))),
          ],
          rows:
              widget.orders.map((order) {
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
                    DataCell(Text(order.id.toString())),
                    DataCell(Text(order.orderNumber)),
                    DataCell(Text(order.userName)),
                    DataCell(Text(order.userMobile)),
                    DataCell(Text(order.userEmail)),
                    DataCell(Text(order.totalAmount.toString())),
                    DataCell(Text(order.type)),
                    DataCell(Text(order.status, style: TextStyle(color: order.status != 'Processing' ? order.status != 'Order Placed' ? order.status != 'Completed' ? order.status != 'Cancelled' ? AppColors.secondary : AppColors.error : AppColors.green : AppColors.primary : AppColors.green),)),
                    DataCell(
                      Text(order.createdAt.toIso8601String().split('T').first),
                    ),
                    DataCell(
                      actionButton("View", Colors.teal, () {
                        showOrderDetailDialog(context, order);
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
