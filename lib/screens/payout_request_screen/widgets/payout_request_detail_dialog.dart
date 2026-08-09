import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/payout_request/payout_request_bloc.dart';
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/models/payout_request.dart';
import 'package:transfor_admin_dashboard/models/payout_request_item.dart';
import 'package:transfor_admin_dashboard/screens/orders_screen/widgets/order_detail_dialog.dart';
import 'package:transfor_admin_dashboard/services/payout_request_services.dart';
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
  List<PayoutRequestItem> items = [];

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
              child: Column(
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
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const Center(child: Text('No items found'))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Order #')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: items.map((item) {
                                return DataRow(cells: [
                                  DataCell(Text(item.orderNumber)),
                                  DataCell(Text(
                                    '⃁ ${item.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(fontFamilyFallback: ['SaudiRiyal']),
                                  )),
                                  DataCell(Text(item.status)),
                                  DataCell(Text(item.date.split(' ').first)),
                                  DataCell(
                                    item.type == null
                                        ? const SizedBox.shrink()
                                        : TextButton(
                                            onPressed: () => _viewOrder(item),
                                            child: const Text('View'),
                                          ),
                                  ),
                                ]);
                              }).toList(),
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
