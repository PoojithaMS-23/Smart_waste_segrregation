import 'package:flutter/material.dart';
import 'add_worker.dart';
import 'add_member.dart';
import 'complaints.dart';
import 'statistics.dart';

class OfficerTabsPage extends StatefulWidget {
  const OfficerTabsPage({super.key});

  @override
  State<OfficerTabsPage> createState() => _OfficerTabsPageState();
}

class _OfficerTabsPageState extends State<OfficerTabsPage> {
  int _selectedIndex = 0;

  // List of pages for navigation
  static const List<Widget> _pages = <Widget>[
    AddWorkerPage(),
    AddMemberPage(),
    SeeComplaintsPage(),
    StatisticsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Officer Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex], // Display selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add Worker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_add),
            label: 'Add Member',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}
