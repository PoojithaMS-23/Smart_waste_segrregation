import 'package:flutter/material.dart';

class SeeComplaintsPage extends StatelessWidget {
  const SeeComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder complaint list
    final complaints = [
      'Water leakage in Block A',
      'Street light not working in Sector 5',
      'Garbage not collected in Lane 3',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.report),
            title: Text(complaints[index]),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                // Handle complaint resolution
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Marked as resolved: ${complaints[index]}')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
