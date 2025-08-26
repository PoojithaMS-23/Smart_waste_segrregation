import 'package:flutter/material.dart';
import 'add_worker.dart'; // Make sure this file exists

class OfficerTabsPage extends StatelessWidget {
  const OfficerTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Officer Dashboard'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_add), text: 'Add Worker'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddWorkerPage(), // Replace with your actual widget
          ],
        ),
      ),
    );
  }
}
