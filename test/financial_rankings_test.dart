import 'package:flutter_test/flutter_test.dart';
import 'package:transfor_admin_dashboard/models/financial_rankings.dart';

void main() {
  test('parses provider, driver, and customer rankings', () {
    final rankings = AdminFinancialRankings.fromJson({
      'period': 'month',
      'range_start': '2026-10-01 00:00:00',
      'range_end': '2026-11-01 00:00:00',
      'providers': [
        {
          'id': 12,
          'name': 'Provider A',
          'earnings': '800.50',
          'order_count': 4,
        },
      ],
      'drivers': [
        {'id': 24, 'name': 'Driver A', 'earnings': 300, 'order_count': 3},
      ],
      'customers': [
        {'id': 31, 'name': 'Customer A', 'spend': '1200.75', 'order_count': 5},
      ],
    });

    expect(rankings.period, 'month');
    expect(rankings.providers.single.id, '12');
    expect(rankings.providers.single.amount, 800.5);
    expect(rankings.drivers.single.amount, 300);
    expect(rankings.customers.single.name, 'Customer A');
    expect(rankings.customers.single.amount, 1200.75);
  });
}
