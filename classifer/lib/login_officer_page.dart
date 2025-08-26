import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/officer.dart';
import 'office_tabs.dart';

class LoginOfficerPage extends StatefulWidget {
  const LoginOfficerPage({super.key});

  @override
  State<LoginOfficerPage> createState() => _LoginOfficerPageState();
}

class _LoginOfficerPageState extends State<LoginOfficerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _empIdController = TextEditingController();

  void _submit() async {
  final name = _nameController.text.trim();
  final empId = _empIdController.text.trim();

  if (name.isEmpty || empId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields')),
    );
    return;
  }

  final officer = await DatabaseHelper.instance.getOfficer(name, empId);

  if (officer != null) {
    // Navigate to officer dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OfficerTabsPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid credentials')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Municipal Officer Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _empIdController,
              decoration: const InputDecoration(
                labelText: 'Employee ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
