import 'package:flutter/material.dart';
import 'package:visit_tracker_app/features/salesperson/screens/salesperson_home_screen.dart';
import 'package:visit_tracker_app/features/salesperson/screens/salesperson_reports_screen.dart';
import 'package:visit_tracker_app/features/salesperson/screens/salesperson_settings_screen.dart';

class SalespersonMainScreen extends StatefulWidget {
  const SalespersonMainScreen({super.key});

  @override
  State<SalespersonMainScreen> createState() => _SalespersonMainScreenState();
}

class _SalespersonMainScreenState extends State<SalespersonMainScreen> {
  int _selectedIndex = 0;

  // The pages corresponding to the navigation bar items
  static const List<Widget> _widgetOptions = <Widget>[
    SalespersonHomeScreen(),
    SalespersonReportsScreen(),
    SalespersonSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}