import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'models/worker.dart';
import 'models/waste_item.dart';
import 'models/members_model.dart';
import 'db/database_helper.dart';

class WorkerDashboard extends StatefulWidget {
  final Worker worker;

  const WorkerDashboard({super.key, required this.worker});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  List<WasteItem> pendingWasteItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPendingWasteItems();
  }

  Future<void> _loadPendingWasteItems() async {
    setState(() {
      isLoading = true;
    });
    
    final items = await DatabaseHelper.instance.getPendingWasteItems();
    setState(() {
      pendingWasteItems = items;
      isLoading = false;
    });
  }

  Future<void> _approveWasteItem(WasteItem wasteItem) async {
    // Update waste item as correctly segregated
    await DatabaseHelper.instance.updateWasteItemFeedback(
      wasteItem.id!,
      true,
      10, // Points earned for correct segregation
      'Correctly segregated!',
    );

    // Update user points
    final member = await _getMemberById(wasteItem.userId);
    if (member != null) {
      final newPoints = member.points + 10;
      await DatabaseHelper.instance.updateMemberPoints(member.id!, newPoints);
    }

    await _loadPendingWasteItems();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waste item approved! User earned 10 points.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _rejectWasteItem(WasteItem wasteItem) async {
    // Update waste item as incorrectly segregated
    await DatabaseHelper.instance.updateWasteItemFeedback(
      wasteItem.id!,
      false,
      -5, // Points lost for incorrect segregation
      'Incorrectly segregated. Please follow guidelines.',
    );

    // Update user points
    final member = await _getMemberById(wasteItem.userId);
    if (member != null) {
      final newPoints = member.points - 5;
      await DatabaseHelper.instance.updateMemberPoints(member.id!, newPoints);
    }

    await _loadPendingWasteItems();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waste item rejected. User lost 5 points.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Member?> _getMemberById(String userId) async {
    final members = await DatabaseHelper.instance.getAllMembers();
    try {
      final memberId = int.parse(userId);
      return members.firstWhere((member) => member.id == memberId);
    } catch (e) {
      return null;
    }
  }

  Color _getClassificationColor(String classification) {
    switch (classification) {
      case 'biodegradable':
        return Colors.green;
      case 'recyclable':
        return Colors.blue;
      case 'hazardous':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingWasteItems,
          ),
        ],
      ),
      body: Column(
        children: [
          // Worker Info Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.work, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Worker: ${widget.worker.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${widget.worker.workerId}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Area: ${widget.worker.area}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pending Waste Items
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pending Waste Items',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${pendingWasteItems.length} items',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                if (isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (pendingWasteItems.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No pending waste items!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'All waste items have been reviewed.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: pendingWasteItems.length,
                      itemBuilder: (context, index) {
                        final wasteItem = pendingWasteItems[index];
                        return FutureBuilder<Member?>(
                          future: _getMemberById(wasteItem.userId),
                          builder: (context, snapshot) {
                            final member = snapshot.data;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  // Waste Item Image
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                    ),
                                    child: wasteItem.imagePath.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(8),
                                            ),
                                            child: Image.file(
                                              File(wasteItem.imagePath),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.image,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Classification and User Info
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getClassificationColor(wasteItem.classification),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                wasteItem.classification.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              _formatDate(wasteItem.uploadDate),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 12),
                                        
                                        // User Information
                                        if (member != null) ...[
                                          Text(
                                            'User: ${member.ownerName}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Address: ${member.doorNumber}, ${member.area}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            'Current Points: ${member.points}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Action Buttons
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () => _approveWasteItem(wasteItem),
                                                icon: const Icon(Icons.check, color: Colors.white),
                                                label: const Text(
                                                  'APPROVE (+10 pts)',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () => _rejectWasteItem(wasteItem),
                                                icon: const Icon(Icons.close, color: Colors.white),
                                                label: const Text(
                                                  'REJECT (-5 pts)',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
