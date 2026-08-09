import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transfor_admin_dashboard/blocs/payout_request/payout_request_bloc.dart';
import 'package:transfor_admin_dashboard/models/payout_request.dart';
import 'package:transfor_admin_dashboard/screens/payout_request_screen/widgets/dropdown_button.dart';
import 'package:transfor_admin_dashboard/screens/payout_request_screen/widgets/payout_requests_table.dart';
import 'package:transfor_admin_dashboard/services/pdf/payout_request_pdf_generator.dart';
import 'package:transfor_admin_dashboard/services/pdf/pdf_opener.dart';

import '../../global_widgets/seachbox.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/dimensions.dart';

class PayoutRequestScreen extends StatefulWidget {
  final String userType;
  const PayoutRequestScreen({super.key, required this.userType});

  @override
  State<PayoutRequestScreen> createState() => _PayoutRequestScreenState();
}

class _PayoutRequestScreenState extends State<PayoutRequestScreen> {
  static const _pageSize = 10;

  DateTime? filterFrom;
  DateTime? filterTo;
  int currentPage = 0;
  bool isGeneratingPdf = false;

  Future<void> _printPdf(List<PayoutRequest> payoutRequests, String categoryLabel) async {
    setState(() => isGeneratingPdf = true);
    try {
      final bytes = await generatePayoutRequestsPdf(
        payoutRequests: payoutRequests,
        categoryLabel: categoryLabel,
        filterFrom: filterFrom,
        filterTo: filterTo,
      );
      final fileName = 'payout_requests_${DateTime.now().millisecondsSinceEpoch}.pdf';
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
      title: AppStrings.loginFailed.translate(context),
      desc: message,
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    context.read<PayoutRequestBloc>().add(
      PayoutRequestLoadingInitiate(userType: widget.userType),
    );
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

  List<PayoutRequest> _applyDateFilter(List<PayoutRequest> payoutRequests) {
    if (filterFrom == null || filterTo == null) return payoutRequests;
    final from = DateTime(filterFrom!.year, filterFrom!.month, filterFrom!.day);
    final to = DateTime(filterTo!.year, filterTo!.month, filterTo!.day, 23, 59, 59);
    return payoutRequests.where((payoutRequest) {
      return !payoutRequest.updatedAt.isBefore(from) && !payoutRequest.updatedAt.isAfter(to);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayoutRequestBloc, PayoutRequestState>(
      listener: (context, state) {
        if (state is PayoutRequestFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        if (state is PayoutRequestLoaded) {
          final dateFormat = DateFormat('yyyy-MM-dd');
          final isFilterReady = filterFrom != null && filterTo != null;
          final isFilterValid = !isFilterReady || !filterFrom!.isAfter(filterTo!);
          final visiblePayoutRequests =
              isFilterValid ? _applyDateFilter(state.filteredPayoutRequests) : state.filteredPayoutRequests;
          final totalPages = (visiblePayoutRequests.length / _pageSize).ceil();
          final safePage = totalPages == 0 ? 0 : currentPage.clamp(0, totalPages - 1);
          if (safePage != currentPage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => currentPage = safePage);
            });
          }
          final pagedPayoutRequests = visiblePayoutRequests.skip(safePage * _pageSize).take(_pageSize).toList();

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SearchBox(
                        searchType: 'Payout Request',
                        userType: widget.userType,
                      ),
                    ),
                    SizedBox(width: AppDimensions.biggerSpacing),
                    Expanded(
                      child: dropdownButton(
                        selectedCategory: state.userType,
                        fetchPayoutRequestByCategory: (userType) {
                          setState(() {
                            filterFrom = null;
                            filterTo = null;
                            currentPage = 0;
                          });
                          context.read<PayoutRequestBloc>().add(
                            PayoutRequestLoadingInitiate(userType: userType),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      tooltip: 'Print PDF',
                      onPressed: isGeneratingPdf || pagedPayoutRequests.isEmpty
                          ? null
                          : () => _printPdf(
                              pagedPayoutRequests,
                              state.userType == 'User' ? 'Customer' : state.userType,
                            ),
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
                pagedPayoutRequests.isEmpty
                    ? const Center(child: Text('No payout requests found'))
                    : Expanded(
                      child: PayoutRequestsTable(
                        payoutRequests: pagedPayoutRequests, userType: state.userType,
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
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
