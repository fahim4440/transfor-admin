import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/models/order_detail.dart';
import 'package:transfor_admin_dashboard/services/orders_services.dart';
import 'package:transfor_admin_dashboard/services/pdf/order_detail_pdf_generator.dart';
import 'package:transfor_admin_dashboard/services/pdf/pdf_opener.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

Future<void> showOrderDetailDialog(BuildContext context, Order order) {
  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (ctx) => OrderDetailDialog(order: order),
  );
}

class OrderDetailDialog extends StatefulWidget {
  final Order order;
  const OrderDetailDialog({super.key, required this.order});

  @override
  State<OrderDetailDialog> createState() => _OrderDetailDialogState();
}

class _OrderDetailDialogState extends State<OrderDetailDialog> {
  final OrdersServices _ordersServices = OrdersServices();
  bool isLoading = true;
  bool isGeneratingPdf = false;
  ProductOrderDetail? productDetail;
  TransportOrderDetail? transportDetail;

  bool get isProductOrder => widget.order.type == 'orders';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (isProductOrder) {
      final detail = await _ordersServices.fetchProductOrderDetails(widget.order.id);
      if (mounted) setState(() { productDetail = detail; isLoading = false; });
    } else {
      final detail = await _ordersServices.fetchTransportOrderDetails(widget.order.id);
      if (mounted) setState(() { transportDetail = detail; isLoading = false; });
    }
  }

  Future<void> _printPdf() async {
    setState(() => isGeneratingPdf = true);
    try {
      final bytes = await generateOrderDetailPdf(
        order: widget.order,
        productDetail: productDetail,
        transportDetail: transportDetail,
      );
      final fileName = 'order_${widget.order.orderNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf';
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: isProductOrder ? _productContent() : _transportContent(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Order #${widget.order.orderNumber}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text),
            ),
          ),
          const SizedBox(width: 12),
          _statusChip(widget.order.status),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Print PDF',
            onPressed: isLoading || isGeneratingPdf ? null : _printPdf,
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
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = AppColors.green;
      case 'Cancelled':
        color = AppColors.error;
      case 'Order Placed':
        color = AppColors.primary;
      default:
        color = AppColors.secondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _productContent() {
    final d = productDetail;
    if (d == null) return const Center(child: Text('Order details not found'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (d.deliveryRequestRejected && d.rejectedByCompany != null)
          _sectionCard('Delivery Rejected', [
            _infoRow('Rejected by', d.rejectedByCompany!),
          ]),
        _sectionCard('Customer', [
          _infoRow('Name', d.customerName ?? '-'),
          _infoRow('Mobile', d.customerMobile ?? '-'),
          _infoRow('Email', d.customerEmail ?? '-'),
        ]),
        if (d.driverName != null)
          _sectionCard('Driver', [
            _infoRow('Name', d.driverName ?? '-'),
            _infoRow('Mobile', d.driverMobile ?? '-'),
          ]),
        _sectionCard('Order Info', [
          _infoRow('Order Number', d.orderNumber),
          _infoRow('Quantity', d.totalQuantity.toString()),
          if (d.paymentMethod != null) _infoRow('Payment Method', d.paymentMethod!),
          if (d.createdAt != null) _infoRow('Order Date', d.createdAt!),
        ]),
        if (d.dropAddress != null)
          _sectionCard('Drop Location', [
            _infoRow('Address', d.dropAddress!),
            if (d.dropCity != null) _infoRow('City', d.dropCity!),
          ]),
        if (d.products.isNotEmpty)
          _sectionCard('Items', d.products.map((p) => _productRow(p)).toList()),
        _sectionCard('Payment', [
          if (d.orderAmount != null) _infoRow('Order Amount', '⃁ ${d.orderAmount}', isCurrency: true),
          if (d.productDeliveryCharge != null) _infoRow('Delivery Charge', '⃁ ${d.productDeliveryCharge}', isCurrency: true),
          if (d.platformFee != null) _infoRow('Platform Fee', '⃁ ${d.platformFee}', isCurrency: true),
          if (d.taxAmount != null) _infoRow('Tax', '⃁ ${d.taxAmount}', isCurrency: true),
          if (d.totalAmount != null) _infoRow('Total', '⃁ ${d.totalAmount}', bold: true, isCurrency: true),
        ]),
        if (d.reason != null && d.reason!.isNotEmpty)
          _sectionCard('Cancellation Reason', [_infoRow('Reason', d.reason!)]),
      ],
    );
  }

  Widget _transportContent() {
    final d = transportDetail;
    if (d == null) return const Center(child: Text('Order details not found'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard('Customer', [
          _infoRow('Name', d.customerName ?? '-'),
          _infoRow('Mobile', d.customerMobile ?? '-'),
          _infoRow('Email', d.customerEmail ?? '-'),
        ]),
        if (d.companyName != null)
          _sectionCard('Service Provider', [
            _infoRow('Company', d.companyName!),
          ]),
        if (d.driverName != null)
          _sectionCard('Driver', [
            _infoRow('Name', d.driverName ?? '-'),
            _infoRow('Mobile', d.driverMobile ?? '-'),
          ]),
        _sectionCard('Service Info', [
          _infoRow('Order Number', d.orderNumber),
          if (d.serviceName != null) _infoRow('Service', d.serviceName!),
          if (d.transportType != null) _infoRow('Transport Type', d.transportType!),
          if (d.vehicleSize != null) _infoRow('Vehicle Size', d.vehicleSize!),
          if (d.vehicleSide != null) _infoRow('Vehicle Side', d.vehicleSide!),
          if (d.quantity != null) _infoRow('Quantity', d.quantity!),
          if (d.paymentMethod != null) _infoRow('Payment Method', d.paymentMethod!),
          if (d.createdAt != null) _infoRow('Order Date', d.createdAt!),
        ]),
        _sectionCard('Route', [
          if (d.pickupAddress != null) _infoRow('Pickup', d.pickupAddress!),
          if (d.pickupCity != null) _infoRow('Pickup City', d.pickupCity!),
          if (d.dropAddress != null) _infoRow('Drop', d.dropAddress!),
          if (d.dropCity != null) _infoRow('Drop City', d.dropCity!),
          if (d.distance != null) _infoRow('Distance', '${d.distance} km'),
        ]),
        _sectionCard('Payment', [
          if (d.shippingFee != null) _infoRow('Shipping Fee', '⃁ ${d.shippingFee}', isCurrency: true),
          if (d.appServiceFee != null) _infoRow('App Service Fee', '⃁ ${d.appServiceFee}', isCurrency: true),
          if (d.deliveryCharge != null) _infoRow('Delivery Charge', '⃁ ${d.deliveryCharge}', isCurrency: true),
          if (d.taxAmount != null) _infoRow('Tax', '⃁ ${d.taxAmount}', isCurrency: true),
        ]),
        if (d.deliveryNote != null && d.deliveryNote!.isNotEmpty)
          _sectionCard('Delivery Note', [_infoRow('Note', d.deliveryNote!)]),
        if (d.reason != null && d.reason!.isNotEmpty)
          _sectionCard('Cancellation Reason', [_infoRow('Reason', d.reason!)]),
      ],
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.primary)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false, bool isCurrency = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: const TextStyle(color: AppColors.secondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                // Scoped to currency rows only ('⃁ 12.34' has no letters) - the SAR
                // symbol font also maps A-D to unrelated glyphs, so it must never
                // apply to ordinary label/value text.
                fontFamilyFallback: isCurrency ? const ['SaudiRiyal'] : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Product images are stored as base64 (see product_form_dialog.dart in the
  // provider app), not URLs, so they load via Image.memory + base64Decode.
  Widget _productImage(String base64String) {
    Uint8List bytes;
    try {
      bytes = base64Decode(base64String);
    } catch (_) {
      return const SizedBox(width: 40, height: 40);
    }
    return Image.memory(
      bytes,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(width: 40, height: 40),
    );
  }

  Widget _productRow(ProductOrderItem p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (p.productImage != null && p.productImage!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _productImage(p.productImage!),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.productName, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600)),
                if (p.providerName != null)
                  Text('Provider: ${p.providerName}', style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
              ],
            ),
          ),
          Text('x${p.quantity}', style: const TextStyle(color: AppColors.secondary)),
          const SizedBox(width: 12),
          Text('⃁ ${p.productPrice}', style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontFamilyFallback: ['SaudiRiyal'])),
        ],
      ),
    );
  }
}
