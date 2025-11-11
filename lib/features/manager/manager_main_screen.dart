import 'package:flutter/material.dart';
import 'package:visit_tracker_app/features/manager/screens/announcement_screen.dart'; // <-- 1. IMPORT THIS
import 'package:visit_tracker_app/features/manager/screens/ask_ai_screen.dart';
// import 'package:visit_tracker_app/features/manager/screens/live_map_screen.dart'; // <-- 2. REMOVE THIS
import 'package:visit_tracker_app/features/manager/screens/manage_screen.dart';
import 'package:visit_tracker_app/features/manager/screens/manager_dashboard_screen.dart';
import 'package:visit_tracker_app/features/manager/screens/team_management_screen.dart';

class ManagerMainScreen extends StatefulWidget {
  const ManagerMainScreen({super.key});

  @override
  State<ManagerMainScreen> createState() => _ManagerMainScreenState();
}

class _ManagerMainScreenState extends State<ManagerMainScreen> {
  int _selectedIndex = 0;

  // --- 3. UPDATED WIDGET LIST ---
  static const List<Widget> _widgetOptions = <Widget>[
    ManagerDashboardScreen(),
    AnnouncementScreen(), // Replaced LiveMapScreen
    ManageScreen(),
    TeamManagementScreen(),
    AskAiScreen(),
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
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          // --- 4. UPDATED NAVIGATION ITEM ---
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign), // Changed icon
            label: 'Announce',        // Changed label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Ask AI',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}