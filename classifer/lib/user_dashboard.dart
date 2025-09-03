import 'package:flutter/material.dart';
import '../models/members_model.dart';
import '../db/members_database.dart';
import '../db/complaints.dart';  // Make sure this exists and is properly implemented

class UserDashboardPage extends StatelessWidget {
  final String userName;

  const UserDashboardPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, $userName'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Guidelines'),
              Tab(text: 'Classify Waste'),
              Tab(text: 'Report'),
              Tab(text: 'Leaderboard'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const GuidelinesTab(),
            const ClassifyWasteTab(),
            ReportTab(userName: userName), // Pass username here
            const LeaderboardTab(),
          ],
        ),
      ),
    );
  }
}

// --------------------- Tab 1: Guidelines ---------------------
class GuidelinesTab extends StatelessWidget {
  const GuidelinesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '♻️ Waste Management Guidelines:\n\n'
        '• Segregate waste into dry and wet categories.\n'
        '• Use green bins for wet waste, blue for dry.\n'
        '• Recycle paper, plastic, metal, and glass.\n'
        '• Avoid using single-use plastics.\n'
        '• Dispose of hazardous items at authorized centers.',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

// --------------------- Tab 2: Classify Waste ---------------------
class ClassifyWasteTab extends StatelessWidget {
  const ClassifyWasteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          title: Text('Organic Waste'),
          subtitle: Text('e.g., food scraps, garden trimmings'),
        ),
        ListTile(
          title: Text('Recyclable Waste'),
          subtitle: Text('e.g., paper, glass, plastic, metal'),
        ),
        ListTile(
          title: Text('Hazardous Waste'),
          subtitle: Text('e.g., batteries, chemicals, medical waste'),
        ),
        ListTile(
          title: Text('General Waste'),
          subtitle: Text('e.g., contaminated packaging, hygiene waste'),
        ),
      ],
    );
  }
}

// --------------------- Tab 3: Report ---------------------
class ReportTab extends StatefulWidget {
  final String userName;  // Accept username

  const ReportTab({super.key, required this.userName});

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final _controller = TextEditingController();

  void _submitReport() async {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      final complaint = {
        'complainant_username': widget.userName,  // Current user
        'message': message,
        'against': null,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await ComplaintDatabase.instance.insertComplaint(complaint);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted!")),
      );
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a message.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submit a complaint or report:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type your message here...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitReport,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// --------------------- Tab 4: Leaderboard ---------------------
class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  List<Member> topMembers = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final allMembers = await MemberDatabase.instance.getAllMembers();

    final usersWithAccounts = allMembers
        .where((m) => m.username != null && m.username!.isNotEmpty)
        .toList();

    usersWithAccounts.sort((a, b) => b.points.compareTo(a.points));

    setState(() {
      topMembers = usersWithAccounts.take(10).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (topMembers.isEmpty) {
      return const Center(child: Text('No leaderboard data available.'));
    }

    return ListView.builder(
      itemCount: topMembers.length,
      itemBuilder: (context, index) {
        final member = topMembers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('${index + 1}'),
          ),
          title: Text(member.ownerName),
          subtitle: Text('Points: ${member.points}'),
          trailing: index == 0
              ? const Icon(Icons.emoji_events, color: Colors.amber)
              : null,
        );
      },
    );
  }
}
