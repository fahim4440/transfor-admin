import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/payout_history/payout_history_bloc.dart';
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
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  int rowIndex = 0;

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
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SearchBox(searchType: 'Payout Request'),
                const SizedBox(height: 20),
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
                                  state.payoutHistories.sort(
                                    (a, b) => b.id.compareTo(a.id),
                                  );
                                } else {
                                  state.payoutHistories.sort(
                                    (a, b) => a.id.compareTo(b.id),
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
                                  state.payoutHistories.sort(
                                    (a, b) => b.name.compareTo(a.name),
                                  );
                                } else {
                                  state.payoutHistories.sort(
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
                                  state.payoutHistories.sort(
                                    (a, b) => b.mobile.compareTo(a.mobile),
                                  );
                                } else {
                                  state.payoutHistories.sort(
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
                                  state.payoutHistories.sort(
                                    (a, b) => b.tAmount.compareTo(a.tAmount),
                                  );
                                } else {
                                  state.payoutHistories.sort(
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
                                  state.payoutHistories.sort(
                                    (a, b) =>
                                        b.updatedAt.compareTo(a.updatedAt),
                                  );
                                } else {
                                  state.payoutHistories.sort(
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
                            state.filteredPayoutHistories.map((payoutHistory) {
                              rowIndex = rowIndex + 1;
                              return DataRow(
                                color:
                                    rowIndex % 2 == 1
                                        ? WidgetStateColor.resolveWith(
                                          (states) => AppColors.background,
                                        )
                                        : WidgetStateColor.resolveWith(
                                          (states) => AppColors.drawerBgColor!
                                              .withOpacity(0.1),
                                        ),
                                cells: [
                                  DataCell(Text(payoutHistory.id.toString())),
                                  DataCell(
                                    Text('TRANS${payoutHistory.id.toString()}'),
                                  ),
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
                                    Text(AppStrings.paid.translate(context)),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
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
