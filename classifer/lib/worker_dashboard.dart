import 'package:flutter/material.dart';
import '../models/worker.dart';

class WorkerDashboardPage extends StatelessWidget {
  final Worker worker;

  const WorkerDashboardPage({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${worker.name}'),
      ),
      body: Center(
        child: Text(
          'Hello ${worker.name}!\nAge: ${worker.age}\nGender: ${worker.gender}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
