import 'package:flutter/material.dart';
import '../models/members_model.dart';
import '../db/members_database.dart';

class MarkPointsPage extends StatefulWidget {
  final String district;
  final String area;

  const MarkPointsPage({super.key, required this.district, required this.area});

  @override
  State<MarkPointsPage> createState() => _MarkPointsPageState();
}

class _MarkPointsPageState extends State<MarkPointsPage> {
  List<Member> members = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final loadedMembers = await MemberDatabase.instance
        .getMembersByDistrictAndArea(widget.district, widget.area);
    setState(() {
      members = loadedMembers;
    });
  }

  Future<void> _updatePoints(Member member, int delta) async {
    member.points += delta;
    await MemberDatabase.instance.updateMember(member);
    _loadMembers(); // refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Houses in ${widget.area}, ${widget.district}'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          return Card(
            child: ListTile(
              title: Text('${m.ownerName} (${m.doorNumber})'),
              subtitle: Text('Points: ${m.points}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () => _updatePoints(m, 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () => _updatePoints(m, -10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
