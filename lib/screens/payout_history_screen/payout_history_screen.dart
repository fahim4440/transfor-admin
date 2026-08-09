import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transfor_admin_dashboard/blocs/payout_history/payout_history_bloc.dart';
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/models/payout_history.dart';
import 'package:transfor_admin_dashboard/screens/orders_screen/widgets/order_detail_dialog.dart';
import 'package:transfor_admin_dashboard/services/pdf/payout_history_pdf_generator.dart';
import 'package:transfor_admin_dashboard/services/pdf/pdf_opener.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

import '../../global_widgets/seachbox.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/colors.dart';
import '../../utilities/text_styles.dart';

class PayoutHistoryScreen extends StatefulWidget {
  const PayoutHistoryScreen({super.key});

  @override
  State<PayoutHistoryScreen> createState() => _PayoutHistoryScreenState();
}

class _PayoutHistoryScreenState extends State<PayoutHistoryScreen> {
  static const _pageSize = 10;

  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  int rowIndex = 0;

  DateTime? filterFrom;
  DateTime? filterTo;
  int currentPage = 0;
  bool isGeneratingPdf = false;

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
                  child: SingleChildScrollView(
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
                          DataColumn(
                            label: Text(AppStrings.no.translate(context)),
                          ),
                          DataColumn(
                            label: Text(
                              AppStrings.requestId.translate(context),
                            ),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  pagedPayoutHistories.sort(
                                    (a, b) => b.id.compareTo(a.id),
                                  );
                                } else {
                                  pagedPayoutHistories.sort(
                                    (a, b) => a.id.compareTo(b.id),
                                  );
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(
                            label: Text(AppStrings.orderNo.translate(context)),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  pagedPayoutHistories.sort(
                                    (a, b) => b.orderNumber.compareTo(a.orderNumber),
                                  );
                                } else {
                                  pagedPayoutHistories.sort(
                                    (a, b) => a.orderNumber.compareTo(b.orderNumber),
                                  );
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
                                  pagedPayoutHistories.sort(
                                    (a, b) => b.name.compareTo(a.name),
                                  );
                                } else {
                                  pagedPayoutHistories.sort(
                                    (a, b) => a.name.compareTo(b.name),
                                  );
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
                                  pagedPayoutHistories.sort(
                                    (a, b) => b.mobile.compareTo(a.mobile),
                                  );
                                } else {
                                  pagedPayoutHistories.sort(
                                    (a, b) => a.mobile.compareTo(b.mobile),
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
                                  pagedPayoutHistories.sort(
                                    (a, b) => b.tAmount.compareTo(a.tAmount),
                                  );
                                } else {
                                  pagedPayoutHistories.sort(
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
                                  pagedPayoutHistories.sort(
                                    (a, b) =>
                                        b.updatedAt.compareTo(a.updatedAt),
                                  );
                                } else {
                                  pagedPayoutHistories.sort(
                                    (a, b) =>
                                        a.updatedAt.compareTo(b.updatedAt),
                                  );
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(
                            label: Text(AppStrings.action.translate(context)),
                          ),
                        ],
                        rows:
                            pagedPayoutHistories.map((payoutHistory) {
                              rowIndex = rowIndex + 1;
                              return DataRow(
                                color:
                                    rowIndex % 2 == 1
                                        ? WidgetStateColor.resolveWith(
                                          (states) => AppColors.background,
                                        )
                                        : WidgetStateColor.resolveWith(
                                          (states) => AppColors.drawerBgColor!
                                              .withValues(alpha: 0.1),
                                        ),
                                cells: [
                                  DataCell(Text(payoutHistory.id.toString())),
                                  DataCell(
                                    Text('TRANS${payoutHistory.id.toString()}'),
                                  ),
                                  DataCell(Text(payoutHistory.orderNumber)),
                                  DataCell(Text(payoutHistory.name)),
                                  DataCell(
                                    Text(
                                      '${payoutHistory.ccode}${payoutHistory.mobile}',
                                    ),
                                  ),
                                  DataCell(
                                    Text(payoutHistory.tAmount.toString()),
                                  ),
                                  DataCell(
                                    Text(
                                      payoutHistory.updatedAt
                                          .toIso8601String()
                                          .split('T')
                                          .first,
                                    ),
                                  ),
                                  DataCell(
                                    payoutHistory.type == null || payoutHistory.type == 'Top-up'
                                        ? Text(AppStrings.paid.translate(context))
                                        : TextButton(
                                            onPressed: () => _viewOrder(payoutHistory),
                                            child: const Text('View'),
                                          ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
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
