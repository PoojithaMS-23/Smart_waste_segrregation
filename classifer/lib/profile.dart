import 'package:flutter/material.dart';
import '../db/members_database.dart';
import '../models/members_model.dart';
import '../../main.dart'; // or wherever routeObserver is declared


class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  late Future<Member?> _memberFuture;

  @override
  void initState() {
    super.initState();
    _memberFuture = _fetchMemberProfile();
  }

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

   @override
  void didPopNext() {
    setState(() {
      _memberFuture = _fetchMemberProfile();
    });
  }


  Future<Member?> _fetchMemberProfile() async {
    final member = await MemberDatabase.instance.getMemberByUsername(widget.username);
    return member;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Profile'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Member?>(
        future: _memberFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final member = snapshot.data;

          if (member == null) {
            return const Center(
              child: Text(
                'No profile found.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Member Details',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileRow('SAS ID:', member.sasId ?? 'N/A'),
                    _buildProfileRow('Owner Name:', member.ownerName),
                    _buildProfileRow('District:', member.district),
                    _buildProfileRow('Area:', member.area),
                    _buildProfileRow('Door Number:', member.doorNumber),
                    _buildProfileRow('House Type:', member.houseType ?? 'N/A'),
                    _buildProfileRow('Tax Amount:', '₹${member.taxAmount.toStringAsFixed(2)}'),
                    _buildProfileRow('Tax After Concession:', '₹${member.taxAfterConcession.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
