import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:transfor_admin_dashboard/blocs/dashboard/dashboard_bloc.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

import '../../utilities/app_strings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardFailure) {
          _showError(state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Elegant Stat Cards (4 main)
                _ElegantStatCardsGrid(
                  dashboardSummary: state.dashboardSummary,
                  dashboardGrowth: state.dashboardGrowth,
                  revenueStats: state.revenueStats,
                  orderStats: state.orderStats,
                  screenWidth: screenWidth,
                ),
                const SizedBox(height: 32),

                // Charts Grid (Revenue + User Growth)
                _ChartsGrid(
                  revenueData: state.revenueData,
                  userGrowthData: state.userGrowthData,
                  screenWidth: screenWidth,
                ),
                const SizedBox(height: 32),

                // Order Status Breakdown
                if (state.orderStats != null)
                  _OrderStatsBreakdown(orderStats: state.orderStats!),
                const SizedBox(height: 32),

                // Recent Orders Table (Full Width)
                if (state.recentOrders != null && state.recentOrders!.isNotEmpty)
                  _RecentOrdersTable(orders: state.recentOrders!),
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

// Elegant Stat Cards with gradient top bar
class _ElegantStatCardsGrid extends StatelessWidget {
  final dynamic dashboardSummary;
  final dynamic dashboardGrowth;
  final dynamic revenueStats;
  final dynamic orderStats;
  final double screenWidth;

  const _ElegantStatCardsGrid({
    this.dashboardSummary,
    this.dashboardGrowth,
    required this.revenueStats,
    required this.orderStats,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = screenWidth < 600 ? 1 : screenWidth < 1200 ? 2 : 4;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.3,
      children: [
        _ElegantStatCard(
          label: 'Total Users',
          value: dashboardSummary != null ? dashboardSummary.totalUsers.toString() : '0',
          growth: dashboardGrowth?.usersGrowth ?? 0,
          icon: Icons.person,
        ),
        _ElegantStatCard(
          label: 'Active Orders',
          value: dashboardSummary != null ? dashboardSummary.activeOrders.toString() : '0',
          growth: dashboardGrowth?.activeOrdersGrowth ?? 0,
          icon: Icons.shopping_bag,
        ),
        _ElegantStatCard(
          label: 'Total Revenue',
          value: revenueStats != null ? '⃁ ${(revenueStats.totalRevenue / 1000).toStringAsFixed(1)}K' : '⃁ 0',
          growth: dashboardGrowth?.revenueGrowth ?? 0,
          icon: Icons.trending_up,
        ),
        _ElegantStatCard(
          label: 'All Orders',
          value: dashboardSummary != null ? dashboardSummary.allOrders.toString() : '0',
          growth: dashboardGrowth?.allOrdersGrowth ?? 0,
          icon: Icons.list_alt,
        ),
      ],
    );
  }
}

class _ElegantStatCard extends StatelessWidget {
  final String label;
  final String value;
  final double growth;
  final IconData icon;

  const _ElegantStatCard({
    required this.label,
    required this.value,
    required this.growth,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2D2D4A) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Stack(
        children: [
          // Gradient top bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, const Color(0xFFE55A00)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFB0B0C0) : const Color(0xFF6B7280),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                        // Scoped here since 'value' is always digits/'K' (never A-D) -
                        // the SAR symbol font also maps A-D to unrelated glyphs.
                        fontFamilyFallback: const ['SaudiRiyal'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          growth >= 0 ? Icons.trending_up : Icons.trending_down,
                          size: 18,
                          color: growth >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${growth >= 0 ? '↑' : '↓'} ${growth.abs().toStringAsFixed(1)}% this month',
                          style: TextStyle(
                            fontSize: 12,
                            color: growth >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Charts Grid
class _ChartsGrid extends StatelessWidget {
  final List<dynamic>? revenueData;
  final List<dynamic>? userGrowthData;
  final double screenWidth;

  const _ChartsGrid({
    required this.revenueData,
    this.userGrowthData,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = screenWidth < 900;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Revenue Chart
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF2D2D4A) : const Color(0xFFE5E7EB),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 20),
                if (revenueData != null && revenueData!.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: _RevenueChart(revenueData: revenueData!),
                  )
                else
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Text('No data available'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (!isMobile) const SizedBox(width: 20),
        // User Growth Chart
        if (!isMobile)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF2D2D4A) : const Color(0xFFE5E7EB),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Growth',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: _UserGrowthChart(userGrowthData: userGrowthData),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RevenueChart extends StatelessWidget {
  final List<dynamic> revenueData;

  const _RevenueChart({required this.revenueData});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = revenueData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), (e.value.revenue ?? 0).toDouble()))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: null,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: AppColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserGrowthChart extends StatelessWidget {
  final List<dynamic>? userGrowthData;

  const _UserGrowthChart({this.userGrowthData});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = userGrowthData != null
        ? userGrowthData!
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), (e.value.users ?? 0).toDouble()))
            .toList()
        : [];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: null,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: const Color(0xFF10B981),
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

// Order Stats Breakdown
class _OrderStatsBreakdown extends StatelessWidget {
  final dynamic orderStats;

  const _OrderStatsBreakdown({required this.orderStats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = orderStats.total;
    final completedPercent = total > 0 ? (orderStats.completed / total * 100).toStringAsFixed(1) : '0';
    final cancelledPercent = total > 0 ? (orderStats.cancelled / total * 100).toStringAsFixed(1) : '0';
    final processingPercent = total > 0 ? (orderStats.processing / total * 100).toStringAsFixed(1) : '0';
    final driverAssignedPercent = total > 0 ? (orderStats.driverAssigned / total * 100).toStringAsFixed(1) : '0';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2D2D4A) : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status Breakdown',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBreakdownItem(
                label: 'Completed',
                count: orderStats.completed,
                percentage: completedPercent,
                color: const Color(0xFF10B981),
              ),
              _StatBreakdownItem(
                label: 'Processing',
                count: orderStats.processing,
                percentage: processingPercent,
                color: const Color(0xFF3B82F6),
              ),
              _StatBreakdownItem(
                label: 'Driver Assigned',
                count: orderStats.driverAssigned,
                percentage: driverAssignedPercent,
                color: const Color(0xFFF59E0B),
              ),
              _StatBreakdownItem(
                label: 'Cancelled',
                count: orderStats.cancelled,
                percentage: cancelledPercent,
                color: const Color(0xFFEF4444),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBreakdownItem extends StatelessWidget {
  final String label;
  final int count;
  final String percentage;
  final Color color;

  const _StatBreakdownItem({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

// Recent Orders Table
class _RecentOrdersTable extends StatelessWidget {
  final List<dynamic> orders;

  const _RecentOrdersTable({required this.orders});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2D2D4A) : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 64,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Date')),
                ],
                rows: orders.take(10).map((order) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${order.orderNumber}')),
                      DataCell(Text(order.customerName)),
                      DataCell(Text('⃁ ${order.amount.toStringAsFixed(2)}', style: const TextStyle(fontFamilyFallback: ['SaudiRiyal']))),
                      DataCell(_StatusBadge(status: order.getStatusLabel())),
                      DataCell(Text(order.date.substring(0, 10))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _getStatusColor() {
    switch (status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'Processing':
        return const Color(0xFF3B82F6);
      case 'Driver Assigned':
        return const Color(0xFFF59E0B);
      case 'Cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
