import 'package:flutter/material.dart';
import '../models/members_model.dart';
import '../db/members_database.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _doorNumberController = TextEditingController();
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _sasIdController = TextEditingController();

  String? selectedArea;
  String? selectedDistrict;
  String? selectedHouseType;

  List<String> areas = ['Area 1', 'Area 2'];
  List<String> districts = ['District 1', 'District 2'];

  final List<String> houseTypes = [
    'commercial',
    'semi-commercial',
    'non commercial',
  ];

  void _addNewArea() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Area'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Area Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newArea = controller.text.trim();
                if (newArea.isNotEmpty) {
                  setState(() {
                    areas.add(newArea);
                    selectedArea = newArea;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewDistrict() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add New District'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'District Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newDistrict = controller.text.trim();
                if (newDistrict.isNotEmpty) {
                  setState(() {
                    districts.add(newDistrict);
                    selectedDistrict = newDistrict;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    if (selectedArea == null || selectedDistrict == null || selectedHouseType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select area, district, and house type.')),
      );
      return;
    }

    double taxAmount;
    switch (selectedHouseType) {
      case 'commercial':
        taxAmount = 3000;
        break;
      case 'semi-commercial':
        taxAmount = 2000;
        break;
      case 'non commercial':
        taxAmount = 1000;
        break;
      default:
        taxAmount = 0;
    }
    final taxAfterConcession = taxAmount;  // same for now

    final newMember = Member(
      ownerName: _ownerNameController.text.trim(),
      doorNumber: _doorNumberController.text.trim(),
      area: selectedArea!,
      district: selectedDistrict!,
      pid: _pidController.text.trim(),
      sasId: _sasIdController.text.trim(),
      houseType: selectedHouseType!,
      taxAmount: taxAmount,
      taxAfterConcession: taxAfterConcession,  // set equal for now
    );

    try {
      // Save member and get the inserted row ID
      final insertedId = await MemberDatabase.instance.insertMember(newMember);
      print('Inserted member ID: $insertedId');

      // Query the database for house_type of the inserted member
      final db = await MemberDatabase.instance.database;
      final result = await db.rawQuery(
        "SELECT house_type FROM members WHERE id = ?", 
        [insertedId],
      );
      print('House type from DB: $result');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully!')),
      );

      // Clear form fields and reset selections
      _formKey.currentState!.reset();
      _ownerNameController.clear();
      _doorNumberController.clear();
      _pidController.clear();
      _sasIdController.clear();

      setState(() {
        selectedArea = null;
        selectedDistrict = null;
        selectedHouseType = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving member: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Member',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _ownerNameController,
              decoration: const InputDecoration(labelText: 'Owner Name'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _doorNumberController,
              decoration: const InputDecoration(labelText: 'Door Number'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedArea,
                    hint: const Text('Select Area'),
                    items: areas
                        .map((area) => DropdownMenuItem(value: area, child: Text(area)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedArea = value;
                      });
                    },
                    validator: (value) => value == null ? 'Select Area' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewArea,
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    hint: const Text('Select District'),
                    items: districts
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                      });
                    },
                    validator: (value) => value == null ? 'Select District' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewDistrict,
                ),
              ],
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedHouseType,
              hint: const Text('Select House Type'),
              items: houseTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedHouseType = value;
                });
              },
              validator: (value) => value == null ? 'Select House Type' : null,
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _pidController,
              decoration: const InputDecoration(labelText: 'PID'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _sasIdController,
              decoration: const InputDecoration(labelText: 'SAS ID'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
