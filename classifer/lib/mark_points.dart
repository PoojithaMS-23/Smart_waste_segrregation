import 'package:flutter/material.dart';
import '../models/members_model.dart';
import '../db/members_database.dart';
import '../db/Waste_stats.dart'; // Make sure this import points correctly to your WasteStatsDatabase

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
  // Update points
  member.points += delta;
  print('Updating ${member.ownerName}: current points = ${member.points - delta}, delta = $delta');


  // Update taxAfterConcession based on points thresholds
  if (member.points >= 91 && member.points < 184) {
  member.taxAfterConcession = member.taxAmount-member.taxAmount * 0.25;
} else if (member.points >= 184 && member.points < 274) {
  member.taxAfterConcession = member.taxAmount-member.taxAmount * 0.5;
} else if (member.points >= 274) {
  member.taxAfterConcession = member.taxAmount-member.taxAmount * 0.7;
} else {
  member.taxAfterConcession = member.taxAmount;
}
  int rowsAffected = await MemberDatabase.instance.updateMemberPointsAndTax(
    member.id!, 
    member.points, 
    member.taxAfterConcession,
  );
  print('Updated $rowsAffected row(s) for ${member.ownerName}');

  // Update member in the database with new points and tax concession
  await MemberDatabase.instance.updateMemberPointsAndTax(member.id!, member.points, member.taxAfterConcession);


  // Update area points in waste_stats table
  if (delta > 0) {
    await WasteStatsDatabase.instance.incrementCorrectPoints(widget.district, widget.area, delta);
  } else if (delta < 0) {
    // For negative delta, increment incorrect points by 1 (based on your logic)
    await WasteStatsDatabase.instance.incrementIncorrectPoints(widget.district, widget.area, 1);
  }

  // Refresh UI with updated members list
  setState(() {
  // The `member` object is already updated — this triggers rebuild
});


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
  onPressed: () => _updatePoints(m, 1),  // Calls new method with tax update logic
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
