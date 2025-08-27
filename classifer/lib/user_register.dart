import 'package:flutter/material.dart';
import '../models/members_model.dart';
import '../db/members_database.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _sasIdController = TextEditingController();
  final _pidController = TextEditingController();
  final _nameController = TextEditingController();
  final _doorNumberController = TextEditingController();
  final _areaController = TextEditingController();
  final _districtController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Member? fetchedMember;

  void _fetchMemberDetails() async {
    final sasId = _sasIdController.text.trim();
    final pid = _pidController.text.trim();

    if (sasId.isEmpty || pid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter SAS ID and PID')),
      );
      return;
    }

    final member = await MemberDatabase.instance.getMemberBySasIdAndPid(sasId, pid);

    if (member == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No member found with given SAS ID and PID')),
      );
      return;
    }

    setState(() {
      fetchedMember = member;
      _nameController.text = member.ownerName;
      _doorNumberController.text = member.doorNumber;
      _areaController.text = member.area;
      _districtController.text = member.district;
      // You may want to prefill username/password only if exists
      _usernameController.text = member.username?? '';
    });
  }

  void _register() async {
    if (fetchedMember == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fetch member details first')),
      );
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    // Update the member with username and password
    final updatedMember = Member(
      id: fetchedMember!.id,
      ownerName: fetchedMember!.ownerName,
      doorNumber: fetchedMember!.doorNumber,
      area: fetchedMember!.area,
      district: fetchedMember!.district,
      pid: fetchedMember!.pid,
      sasId: fetchedMember!.sasId,
      points: fetchedMember!.points,
      taxAmount: fetchedMember!.taxAmount,
      taxAfterConcession: fetchedMember!.taxAfterConcession,
      username: username,
      password: password,
    );

    try {
      if (await MemberDatabase.instance.usernameExists(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username already taken')),
  );
  return;
}

      await MemberDatabase.instance.updateMember(updatedMember);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _sasIdController,
              decoration: const InputDecoration(labelText: 'SAS ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pidController,
              decoration: const InputDecoration(labelText: 'PID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchMemberDetails,
              child: const Text('Fetch Member Details'),
            ),
            const SizedBox(height: 20),

            // If member found, show prefilled info and registration fields
            if (fetchedMember != null) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _doorNumberController,
                decoration: const InputDecoration(labelText: 'Door Number'),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Area'),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'District'),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
