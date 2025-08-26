import 'package:flutter/material.dart';
import '../db/worker_database.dart';
import '../models/worker.dart';


class AddWorkerPage extends StatefulWidget {
  const AddWorkerPage({super.key});

  @override
  State<AddWorkerPage> createState() => _AddWorkerPageState();
}

class _AddWorkerPageState extends State<AddWorkerPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _workerIdController = TextEditingController();

  // Gender dropdown
  String? _selectedGender;

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final newWorker = Worker(
      name: _nameController.text,
      age: int.parse(_ageController.text),
      gender: _selectedGender!,
      workerId: _workerIdController.text,
    );

    await WorkerDatabase.instance.insertWorker(newWorker);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Worker added to database!')),
    );

    _formKey.currentState!.reset();
    setState(() {
      _selectedGender = null;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Worker Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the worker\'s name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the age';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Enter a valid age';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Gender'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a gender';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _workerIdController,
              decoration: const InputDecoration(labelText: 'Worker ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the worker ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Worker'),
            ),
          ],
        ),
      ),
    );
  }
}
