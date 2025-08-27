import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final stats = {
      'Total Workers': 42,
      'Total Members': 127,
      'Open Complaints': 5,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: stats.entries.map((entry) {
          return Card(
            child: ListTile(
              title: Text(entry.key),
              trailing: Text(entry.value.toString()),
            ),
          );
        }).toList(),
      ),
    );
  }
}
