import 'package:flutter/material.dart';
import '../models/members_model.dart';
import '../db/members_database.dart';
import '../db/complaints.dart';
import 'profile.dart';
import 'scan_classify.dart';

class UserDashboardPage extends StatefulWidget {
  final String username;  // Changed from sasId

  const UserDashboardPage({super.key, required this.username});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  Member? _member;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMember();
  }

  Future<void> _loadMember() async {
    debugPrint('[Dashboard] Loading member with username: ${widget.username}');
    try {
      final member = await MemberDatabase.instance.getMemberByUsername(widget.username); // fetch by username
      if (member == null) {
        debugPrint('[Dashboard] No member found for username: ${widget.username}');
      } else {
        debugPrint('[Dashboard] Member loaded: ${member.ownerName}');
      }
      if (mounted) {
        setState(() {
          _member = member;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('[Dashboard] Error fetching member: $e');
      if (mounted) {
        setState(() {
          _member = null;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownerName = _member?.ownerName;
    return DefaultTabController(
      length: 5,  // increased by 1 for adding the Scan to classify tab
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _loading
                ? 'Loading...'
                : (ownerName ?? 'Welcome, ${widget.username}'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Guidelines'),
              Tab(text: 'Classify Waste'),
              Tab(text: 'Scan to Classify'), // tab for uploading image and classifying
              Tab(text: 'Report'),
              Tab(text: 'Leaderboard'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  if (_member != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(username: _member!.username!), // use username here
                      ),
                    );
                  } else if (_loading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Still loading member data...")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No profile found for this user.")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const GuidelinesTab(),
            const ClassifyWasteTab(),
            const ScanClassifyTab(), // for classifying page
            ReportTab(username: widget.username),  // pass username here
            const LeaderboardTab(),
          ],
        ),
      ),
    );
  }
}

/// ---------------- TAB 1: GUIDELINES ----------------
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

/// ---------------- TAB 2: CLASSIFY WASTE ----------------
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

/// ---------------- TAB 3: REPORT ----------------
class ReportTab extends StatefulWidget {
  final String username;  // changed from sasId

  const ReportTab({super.key, required this.username});

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final _controller = TextEditingController();

  void _submitReport() async {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      final complaint = {
        'complainant_username': widget.username,
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

/// ---------------- TAB 4: LEADERBOARD ----------------
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
      topMembers = usersWithAccounts;
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
