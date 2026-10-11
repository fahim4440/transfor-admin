import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transfor_admin_dashboard/models/financial_rankings.dart';
import 'package:transfor_admin_dashboard/services/dashboard_services.dart';

class FinancialRankingsSection extends StatefulWidget {
  const FinancialRankingsSection({super.key});

  @override
  State<FinancialRankingsSection> createState() =>
      _FinancialRankingsSectionState();
}

class _FinancialRankingsSectionState extends State<FinancialRankingsSection> {
  final DashboardServices _services = DashboardServices();
  String _period = 'month';
  DateTime _date = DateTime.now();
  late Future<AdminFinancialRankings> _rankings;

  @override
  void initState() {
    super.initState();
    _rankings = _fetch();
  }

  Future<AdminFinancialRankings> _fetch() =>
      _services.fetchFinancialRankings(period: _period, date: _date);

  void _selectPeriod(String period) {
    setState(() {
      _period = period;
      _rankings = _fetch();
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _date = DateTime(picked.year, picked.month, picked.day);
      _rankings = _fetch();
    });
  }

  String _rangeLabel() {
    final lang = Localizations.localeOf(context).languageCode;
    switch (_period) {
      case 'day':
        return DateFormat('d MMM yyyy', lang).format(_date);
      case 'week':
        final start = _date.subtract(
          Duration(days: _date.weekday - DateTime.monday),
        );
        final end = start.add(const Duration(days: 6));
        return '${DateFormat('d MMM yyyy', lang).format(start)} - ${DateFormat('d MMM yyyy', lang).format(end)}';
      case 'year':
        return DateFormat('yyyy', lang).format(_date);
      case 'month':
      default:
        return DateFormat('MMMM yyyy', lang).format(_date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final border = isDark ? const Color(0xFF2D2D4A) : const Color(0xFFE5E7EB);

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Provider, Driver & Customer Rankings',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 'day', label: Text('Daily')),
                  ButtonSegment(value: 'week', label: Text('Weekly')),
                  ButtonSegment(value: 'month', label: Text('Monthly')),
                  ButtonSegment(value: 'year', label: Text('Yearly')),
                ],
                selected: {_period},
                onSelectionChanged: (selection) {
                  if (selection.isNotEmpty) _selectPeriod(selection.first);
                },
              ),
              OutlinedButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(_rangeLabel()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Text(
          //   'Driver earnings use accepted offers and delivery bids. Directly assigned jobs have no separate driver fee recorded.',
          //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //     color: isDark ? Colors.white60 : Colors.black54,
          //   ),
          // ),
          // const SizedBox(height: 16),
          FutureBuilder<AdminFinancialRankings>(
            future: _rankings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        snapshot.error.toString().replaceFirst(
                          'Exception: ',
                          '',
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => _rankings = _fetch()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                );
              }

              final data = snapshot.data;
              if (data == null) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RankingTable(
                    title: 'Provider earnings',
                    amountHeading: 'Earned (SAR)',
                    items: data.providers,
                    emptyText: 'No provider earnings in this period.',
                    background: background,
                    border: border,
                  ),
                  const SizedBox(height: 24),
                  _RankingTable(
                    title: 'Driver earnings',
                    amountHeading: 'Earned (SAR)',
                    items: data.drivers,
                    emptyText: 'No recorded driver earnings in this period.',
                    background: background,
                    border: border,
                  ),
                  const SizedBox(height: 24),
                  _RankingTable(
                    title: 'Top customers by spend',
                    amountHeading: 'Spend (SAR)',
                    items: data.customers,
                    emptyText: 'No completed customer orders in this period.',
                    background: background,
                    border: border,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RankingTable extends StatelessWidget {
  final String title;
  final String amountHeading;
  final List<FinancialRankingItem> items;
  final String emptyText;
  final Color background;
  final Color border;

  const _RankingTable({
    required this.title,
    required this.amountHeading,
    required this.items,
    required this.emptyText,
    required this.background,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              emptyText,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 42,
              dataRowMinHeight: 42,
              dataRowMaxHeight: 52,
              columns: [
                const DataColumn(label: Text('Rank')),
                const DataColumn(label: Text('Name')),
                const DataColumn(
                  label: Text('Completed orders'),
                  numeric: true,
                ),
                DataColumn(label: Text(amountHeading), numeric: true),
              ],
              rows: [
                for (var index = 0; index < items.length; index++)
                  DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(items[index].name)),
                      DataCell(Text('${items[index].orderCount}')),
                      DataCell(Text(items[index].amount.toStringAsFixed(2))),
                    ],
                  ),
              ],
              decoration: BoxDecoration(
                color: background,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}
