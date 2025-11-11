import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visit_tracker_app/features/salesperson/widgets/bar_chart_widget.dart';
import 'package:visit_tracker_app/features/salesperson/widgets/pie_chart_widget.dart';

class SalespersonReportsScreen extends StatefulWidget {
  const SalespersonReportsScreen({super.key});

  @override
  State<SalespersonReportsScreen> createState() => _SalespersonReportsScreenState();
}

class _SalespersonReportsScreenState extends State<SalespersonReportsScreen> {
  final List<bool> _selectedPeriod = <bool>[true, false, false];
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        for (int i = 0; i < _selectedPeriod.length; i++) {
          _selectedPeriod[i] = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // --- FIX APPLIED HERE: REPLACED ROW WITH WRAP ---
                  // Wrap will automatically handle layout on different screen sizes.
                  Wrap(
                    spacing: 8.0, // Horizontal space between items
                    runSpacing: 4.0, // Vertical space between lines if it wraps
                    alignment: WrapAlignment.center, // Center the items
                    children: [
                      ToggleButtons(
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedPeriod.length; i++) {
                              _selectedPeriod[i] = i == index;
                            }
                            _selectedDateRange = null;
                          });
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.indigo[700],
                        selectedColor: Colors.white,
                        fillColor: Colors.indigo[400],
                        color: Colors.indigo[400],
                        isSelected: _selectedPeriod,
                        constraints: const BoxConstraints(minHeight: 40.0), // Ensure buttons have a good height
                        children: const <Widget>[
                          Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text('Today')),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text('Last Week')),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text('Last Month')),
                        ],
                      ),
                      // Calendar button is now a child of the Wrap
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectDateRange,
                        color: Colors.indigo,
                        tooltip: 'Select Date Range',
                      ),
                    ],
                  ),
                  
                  if (_selectedDateRange != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Custom Range: ${DateFormat.yMd().format(_selectedDateRange!.start)} - ${DateFormat.yMd().format(_selectedDateRange!.end)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  const Text("Visit Outcomes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const PieChartWidget(),
                  const SizedBox(height: 32),
                  const Text("Daily Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const BarChartWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}