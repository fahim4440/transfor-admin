import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transfor_admin_dashboard/blocs/orders/orders_bloc.dart';
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/screens/orders_screen/widgets/orders_table.dart';
import 'package:transfor_admin_dashboard/services/pdf/orders_pdf_generator.dart';
import 'package:transfor_admin_dashboard/services/pdf/pdf_opener.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

import '../../utilities/app_strings.dart';
import '../../utilities/dimensions.dart';
import '../../global_widgets/seachbox.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int tabIndex = 0;

  static const _tabs = [
    ('orderPlaced', AppStrings.orderPlaced),
    ('inProgress', AppStrings.orderInProgress),
    ('delivered', AppStrings.delivered),
    ('cancelled', AppStrings.cancelledOrdersTab),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.padding, left: AppDimensions.padding, right: AppDimensions.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (int i = 0; i < _tabs.length; i++) ...[
                _tabButton(
                  label: _tabs[i].$2.translate(context),
                  selected: tabIndex == i,
                  onTap: () => setState(() => tabIndex = i),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: _OrdersListView(
              key: ValueKey(tabIndex),
              ordersCompleteType: _tabs[tabIndex].$1,
              tabLabel: _tabs[tabIndex].$2.translate(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({required String label, required bool selected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.text,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _OrdersListView extends StatefulWidget {
  final String ordersCompleteType;
  final String tabLabel;
  const _OrdersListView({super.key, required this.ordersCompleteType, required this.tabLabel});

  @override
  State<_OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<_OrdersListView> {
  static const _pageSize = 10;

  DateTime? filterFrom;
  DateTime? filterTo;
  int currentPage = 0;
  bool isGeneratingPdf = false;

  Future<void> _printOrdersPdf(List<Order> orders) async {
    setState(() => isGeneratingPdf = true);
    try {
      final bytes = await generateOrdersPdf(
        orders: orders,
        tabLabel: widget.tabLabel,
        filterFrom: filterFrom,
        filterTo: filterTo,
      );
      final fileName = 'orders_${widget.ordersCompleteType}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await openPdf(bytes, fileName);
    } catch (e) {
      _showError('Could not generate PDF: $e');
    } finally {
      if (mounted) setState(() => isGeneratingPdf = false);
    }
  }

  void _showError(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: AppStrings.loginFailed.translate(context),
      desc: message,
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(OrdersLoadingInitiate(ordersCompleteType: widget.ordersCompleteType));
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

  List<Order> _applyDateFilter(List<Order> orders) {
    if (filterFrom == null || filterTo == null) return orders;
    final from = DateTime(filterFrom!.year, filterFrom!.month, filterFrom!.day);
    final to = DateTime(filterTo!.year, filterTo!.month, filterTo!.day, 23, 59, 59);
    return orders.where((order) {
      return !order.createdAt.isBefore(from) && !order.createdAt.isAfter(to);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        if (state is OrdersLoaded) {
          final dateFormat = DateFormat('yyyy-MM-dd');
          final isFilterReady = filterFrom != null && filterTo != null;
          final isFilterValid = !isFilterReady || !filterFrom!.isAfter(filterTo!);
          final visibleOrders = isFilterValid ? _applyDateFilter(state.filteredOrders) : state.filteredOrders;
          final totalPages = (visibleOrders.length / _pageSize).ceil();
          final safePage = totalPages == 0 ? 0 : currentPage.clamp(0, totalPages - 1);
          if (safePage != currentPage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => currentPage = safePage);
            });
          }
          final pagedOrders = visibleOrders.skip(safePage * _pageSize).take(_pageSize).toList();

          return Padding(
            padding: const EdgeInsets.only(top: AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SearchBox(searchType: 'Order'),
                    IconButton(
                      tooltip: 'Print PDF',
                      onPressed: isGeneratingPdf || pagedOrders.isEmpty ? null : () => _printOrdersPdf(pagedOrders),
                      icon: isGeneratingPdf
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.picture_as_pdf),
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
                if (isFilterReady && isFilterValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      'Total Orders in range: ${visibleOrders.length}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: pagedOrders.isEmpty
                      ? const Center(child: Text('No orders found'))
                      : OrdersTable(orders: pagedOrders),
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
