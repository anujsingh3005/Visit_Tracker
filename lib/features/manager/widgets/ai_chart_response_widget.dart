import 'package:flutter/material.dart';
import 'package:visit_tracker_app/features/manager/widgets/acceptance_ratio_pie_chart.dart';
import 'package:visit_tracker_app/features/manager/widgets/sales_comparison_bar_chart.dart';
import 'package:visit_tracker_app/features/manager/widgets/visit_comparison_radar_chart.dart';

class AiChartResponseWidget extends StatefulWidget {
  final String salesperson1;
  final String salesperson2;

  const AiChartResponseWidget({
    super.key,
    required this.salesperson1,
    required this.salesperson2,
  });

  @override
  State<AiChartResponseWidget> createState() => _AiChartResponseWidgetState();
}

class _AiChartResponseWidgetState extends State<AiChartResponseWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Container(
        height: 650,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChartTab("Daily"),
                  _buildChartTab("Weekly"),
                  _buildChartTab("Monthly"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTab(String period) {
    final double ratio1 = (period == 'Daily') ? 0.7 : (period == 'Weekly' ? 0.65 : 0.72);
    final double ratio2 = (period == 'Daily') ? 0.55 : (period == 'Weekly' ? 0.6 : 0.58);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Text(
            '$period Acceptance Ratios',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Flexible(child: AcceptanceRatioPieChart(name: widget.salesperson1, ratio: ratio1)),
              Flexible(child: AcceptanceRatioPieChart(name: widget.salesperson2, ratio: ratio2)),
            ],
          ),
          const Divider(height: 32),
          Text(
            '$period Sales Comparison (Revenue)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SalesComparisonBarChart(
            salesperson1: widget.salesperson1,
            salesperson2: widget.salesperson2,
          ),
          const Divider(height: 32),
          Text(
            '$period Visit Comparison (Count)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          // --- THIS IS THE FIX ---
          // Using the correct parameter names: salesperson1 and salesperson2
          VisitComparisonRadarChart(
            salesperson1: widget.salesperson1,
            salesperson2: widget.salesperson2,
          ),
        ],
      ),
    );
  }
}