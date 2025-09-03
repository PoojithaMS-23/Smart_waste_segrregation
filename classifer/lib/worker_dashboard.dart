import 'package:flutter/material.dart';
import '../models/worker.dart';
import '../db/members_database.dart';
import 'mark_points.dart'; // Make sure this exists

class WorkerDashboardPage extends StatefulWidget {
  final Worker worker;

  const WorkerDashboardPage({super.key, required this.worker});

  @override
  State<WorkerDashboardPage> createState() => _WorkerDashboardPageState();
}

class _WorkerDashboardPageState extends State<WorkerDashboardPage> {
  String? selectedDistrict;
  String? selectedArea;

  List<String> allDistricts = [];
  List<String> areasInDistrict = [];

  @override
  void initState() {
    super.initState();
    _loadDistricts();
  }

  Future<void> _loadDistricts() async {
    final districts = await MemberDatabase.instance.getAllDistricts();
    setState(() {
      allDistricts = districts;
    });
  }

  Future<void> _loadAreas(String district) async {
    final areas = await MemberDatabase.instance.getAreasByDistrict(district);
    setState(() {
      areasInDistrict = areas;
      selectedArea = null; // reset area
    });
  }

  void _goToMarkPoints() {
    if (selectedDistrict != null && selectedArea != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarkPointsPage(
            district: selectedDistrict!,
            area: selectedArea!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both district and area")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${widget.worker.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ${widget.worker.name}!\nAge: ${widget.worker.age}\nGender: ${widget.worker.gender}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // District Dropdown
            DropdownButton<String>(
              hint: const Text('Select District'),
              value: selectedDistrict,
              isExpanded: true,
              items: allDistricts.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedArea = null;
                  areasInDistrict = [];
                });
                _loadAreas(value!);
              },
            ),

            // Area Dropdown
            if (selectedDistrict != null)
              DropdownButton<String>(
                hint: const Text('Select Area'),
                value: selectedArea,
                isExpanded: true,
                items: areasInDistrict.map((area) {
                  return DropdownMenuItem(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedArea = value;
                  });
                },
              ),

            const SizedBox(height: 30),

            // Show Houses Button
            Center(
              child: ElevatedButton(
                onPressed: _goToMarkPoints,
                child: const Text("Show Houses"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
