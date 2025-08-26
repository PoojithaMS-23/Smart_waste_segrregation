import 'package:flutter/material.dart';
import '../db/worker_database.dart';
import '../models/worker.dart';
import 'worker_dashboard.dart'; // This will be the screen after login

class WorkerLoginPage extends StatefulWidget {
  const WorkerLoginPage({super.key});

  @override
  State<WorkerLoginPage> createState() => _WorkerLoginPageState();
}

class _WorkerLoginPageState extends State<WorkerLoginPage> {
  final TextEditingController _workerIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _loginWorker() async {
    final enteredId = _workerIdController.text.trim();

    if (enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Worker ID')),
      );
      return;
    }

    final db = WorkerDatabase.instance;
    final allWorkers = await db.getAllWorkers();

    final Worker? matchedWorker = allWorkers.firstWhere(
  (worker) => worker.workerId == enteredId,
  orElse: () => null as Worker,
);


    if (matchedWorker != null) {
      // ✅ Login successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkerDashboardPage(worker: matchedWorker),
        ),
      );
    } else {
      // ❌ Worker ID not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Worker ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _workerIdController,
                decoration: const InputDecoration(labelText: 'Enter Worker ID'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginWorker,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
