class AdminFinancialRankings {
  final String period;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final List<FinancialRankingItem> providers;
  final List<FinancialRankingItem> drivers;
  final List<FinancialRankingItem> customers;

  const AdminFinancialRankings({
    required this.period,
    required this.rangeStart,
    required this.rangeEnd,
    required this.providers,
    required this.drivers,
    required this.customers,
  });

  factory AdminFinancialRankings.fromJson(Map<String, dynamic> json) {
    return AdminFinancialRankings(
      period: json['period']?.toString() ?? 'month',
      rangeStart:
          DateTime.tryParse(json['range_start']?.toString() ?? '') ??
          DateTime.now(),
      rangeEnd:
          DateTime.tryParse(json['range_end']?.toString() ?? '') ??
          DateTime.now(),
      providers: _items(json['providers']),
      drivers: _items(json['drivers']),
      customers: _items(json['customers']),
    );
  }

  static List<FinancialRankingItem> _items(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(FinancialRankingItem.fromJson)
        .toList();
  }
}

class FinancialRankingItem {
  final String id;
  final String name;
  final double amount;
  final int orderCount;

  const FinancialRankingItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.orderCount,
  });

  factory FinancialRankingItem.fromJson(Map<String, dynamic> json) {
    return FinancialRankingItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      amount:
          double.tryParse(
            json['earnings']?.toString() ?? json['spend']?.toString() ?? '0',
          ) ??
          0,
      orderCount: int.tryParse(json['order_count']?.toString() ?? '0') ?? 0,
    );
  }
}
