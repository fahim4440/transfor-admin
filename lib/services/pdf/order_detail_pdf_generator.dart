import 'dart:typed_data';

import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/models/order_detail.dart';

Future<Uint8List> generateOrderDetailPdf({
  required Order order,
  ProductOrderDetail? productDetail,
  TransportOrderDetail? transportDetail,
}) async {
  final arabicFontData = await rootBundle.load('assets/fonts/NotoSansArabic.ttf');
  final arabicFont = pw.Font.ttf(arabicFontData);
  final riyalFontData = await rootBundle.load('assets/fonts/saudi_riyal.ttf');
  final riyalFont = pw.Font.ttf(riyalFontData);

  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFont),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Order #${order.orderNumber}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: pw.BoxDecoration(
                color: _statusColor(order.status),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Text(order.status, style: const pw.TextStyle(color: PdfColors.white, fontSize: 11)),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 12),
        if (productDetail != null) ..._productSections(productDetail, riyalFont),
        if (transportDetail != null) ..._transportSections(transportDetail, riyalFont),
      ],
    ),
  );

  return doc.save();
}

PdfColor _statusColor(String status) {
  switch (status) {
    case 'Completed':
      return PdfColors.green700;
    case 'Cancelled':
      return PdfColors.red700;
    case 'Order Placed':
      return PdfColors.orange700;
    default:
      return PdfColors.blueGrey400;
  }
}

List<pw.Widget> _productSections(ProductOrderDetail d, pw.Font riyalFont) {
  return [
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
      if (d.createdAt != null) _infoRow('Order Date', d.createdAt!.split(' ').first),
    ]),
    if (d.dropAddress != null)
      _sectionCard('Drop Location', [
        _infoRow('Address', d.dropAddress!),
        if (d.dropCity != null) _infoRow('City', d.dropCity!),
      ]),
    if (d.products.isNotEmpty)
      _sectionCard('Items', [
        for (final p in d.products) _itemRow(p.productName, p.quantity, p.productPrice, p.providerName, riyalFont),
      ]),
    _sectionCard('Payment', [
      if (d.orderAmount != null) _currencyRow('Order Amount', d.orderAmount!, riyalFont),
      if (d.productDeliveryCharge != null) _currencyRow('Delivery Charge', d.productDeliveryCharge!, riyalFont),
      if (d.platformFee != null) _currencyRow('Platform Fee', d.platformFee!, riyalFont),
      if (d.taxAmount != null) _currencyRow('Tax', d.taxAmount!, riyalFont),
      if (d.totalAmount != null) _currencyRow('Total', d.totalAmount!, riyalFont, bold: true),
    ]),
    if (d.reason != null && d.reason!.isNotEmpty)
      _sectionCard('Cancellation Reason', [_infoRow('Reason', d.reason!)]),
  ];
}

List<pw.Widget> _transportSections(TransportOrderDetail d, pw.Font riyalFont) {
  return [
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
      if (d.createdAt != null) _infoRow('Order Date', d.createdAt!.split(' ').first),
    ]),
    _sectionCard('Route', [
      if (d.pickupAddress != null) _infoRow('Pickup', d.pickupAddress!),
      if (d.pickupCity != null) _infoRow('Pickup City', d.pickupCity!),
      if (d.dropAddress != null) _infoRow('Drop', d.dropAddress!),
      if (d.dropCity != null) _infoRow('Drop City', d.dropCity!),
      if (d.distance != null) _infoRow('Distance', '${d.distance} km'),
    ]),
    _sectionCard('Payment', [
      if (d.shippingFee != null) _currencyRow('Shipping Fee', d.shippingFee!, riyalFont),
      if (d.appServiceFee != null) _currencyRow('App Service Fee', d.appServiceFee!, riyalFont),
      if (d.deliveryCharge != null) _currencyRow('Delivery Charge', d.deliveryCharge!, riyalFont),
      if (d.taxAmount != null) _currencyRow('Tax', d.taxAmount!, riyalFont),
    ]),
    if (d.deliveryNote != null && d.deliveryNote!.isNotEmpty)
      _sectionCard('Delivery Note', [_infoRow('Note', d.deliveryNote!)]),
    if (d.reason != null && d.reason!.isNotEmpty)
      _sectionCard('Cancellation Reason', [_infoRow('Reason', d.reason!)]),
  ];
}

pw.Widget _sectionCard(String title, List<pw.Widget> children) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 12),
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13, color: PdfColors.blueGrey800)),
        pw.SizedBox(height: 6),
        ...children,
      ],
    ),
  );
}

pw.Widget _infoRow(String label, String value) {
  final isArabic = ArabicReshaper.isArabic(value);
  final display = isArabic ? ArabicReshaper.instance.reshape(value) : value;
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: 130, child: pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700))),
        pw.Expanded(
          child: pw.Text(
            display,
            style: const pw.TextStyle(fontSize: 10),
            textDirection: isArabic ? pw.TextDirection.rtl : null,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _currencyRow(String label, String amount, pw.Font riyalFont, {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.SizedBox(width: 130, child: pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700))),
        pw.RichText(
          text: pw.TextSpan(
            style: pw.TextStyle(fontSize: 10, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
            children: [
              pw.TextSpan(text: '⃁', style: pw.TextStyle(font: riyalFont, fontSize: 10, fontWeight: pw.FontWeight.normal)),
              pw.TextSpan(text: ' $amount'),
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _itemRow(String name, String quantity, String price, String? providerName, pw.Font riyalFont) {
  final isArabic = ArabicReshaper.isArabic(name);
  final displayName = isArabic ? ArabicReshaper.instance.reshape(name) : name;
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                displayName,
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                textDirection: isArabic ? pw.TextDirection.rtl : null,
              ),
              if (providerName != null)
                pw.Text('Provider: $providerName', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ],
          ),
        ),
        pw.Text('x$quantity', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(width: 10),
        pw.RichText(
          text: pw.TextSpan(
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            children: [
              pw.TextSpan(text: '⃁', style: pw.TextStyle(font: riyalFont, fontSize: 10, fontWeight: pw.FontWeight.normal)),
              pw.TextSpan(text: ' $price'),
            ],
          ),
        ),
      ],
    ),
  );
}
