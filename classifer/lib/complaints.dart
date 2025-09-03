import 'package:flutter/material.dart';
import '../db/complaints.dart';

class SeeComplaintsPage extends StatefulWidget {
  const SeeComplaintsPage({super.key});

  @override
  State<SeeComplaintsPage> createState() => _SeeComplaintsPageState();
}

class _SeeComplaintsPageState extends State<SeeComplaintsPage> {
  List<Map<String, dynamic>> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    final data = await ComplaintDatabase.instance.getAllComplaints();
    setState(() {
      complaints = data;
      isLoading = false;
    });
  }

  Future<void> _markResolved(int id) async {
    // For demo: we just delete complaint when marked resolved
    final db = await ComplaintDatabase.instance.database;
    await db.delete('complaints', where: 'id = ?', whereArgs: [id]);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Marked as resolved')),
    );

    _loadComplaints(); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (complaints.isEmpty) {
      return const Center(child: Text('No complaints found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.report),
            title: Text(complaint['message'] ?? 'No message'),
            subtitle: Text('From: ${complaint['complainant_username'] ?? 'Unknown'}\n'
                'At: ${complaint['timestamp'] ?? 'Unknown time'}'),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              onPressed: () => _markResolved(complaint['id']),
            ),
          ),
        );
      },
    );
  }
}
