import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'models/members_model.dart';
import 'models/waste_item.dart';
import 'models/complaint.dart';
import 'models/feedback.dart';
import 'db/database_helper.dart';
import 'guidelines_page.dart';
import 'leaderboard_page.dart';
import 'complaints_page.dart';
import 'feedback_page.dart';
import 'about_us_page.dart';

class UserDashboard extends StatefulWidget {
  final Member user;

  const UserDashboard({super.key, required this.user});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final ImagePicker _picker = ImagePicker();
  List<WasteItem> userWasteItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserWasteItems();
  }

  Future<void> _loadUserWasteItems() async {
    setState(() {
      isLoading = true;
    });
    
    final items = await DatabaseHelper.instance.getWasteItemsByUser(widget.user.id.toString());
    setState(() {
      userWasteItems = items;
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _classifyWaste(image.path);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _classifyWaste(image.path);
    }
  }

  Future<void> _classifyWaste(String imagePath) async {
    setState(() {
      isLoading = true;
    });

    // Simulate AI classification (in real app, this would call an ML model)
    await Future.delayed(const Duration(seconds: 2));
    
    // Random classification for demo
    final classifications = ['biodegradable', 'recyclable', 'hazardous'];
    final randomClassification = classifications[DateTime.now().millisecond % 3];
    
    final wasteItem = WasteItem(
      userId: widget.user.id.toString(),
      imagePath: imagePath,
      classification: randomClassification,
      uploadDate: DateTime.now(),
    );

    await DatabaseHelper.instance.insertWasteItem(wasteItem);
    await _loadUserWasteItems();

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Waste classified as: ${randomClassification.toUpperCase()}'),
          backgroundColor: _getClassificationColor(randomClassification),
        ),
      );
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
        title: const Text('User Dashboard'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _showUserProfile();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${widget.user.ownerName}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.user.points} Points',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Address: ${widget.user.doorNumber}, ${widget.user.area}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Quick Actions Grid
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildActionCard(
                  'Classify Waste',
                  Icons.camera_alt,
                  Colors.green,
                  () => _showImageSourceDialog(),
                ),
                _buildActionCard(
                  'Guidelines',
                  Icons.info,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GuidelinesPage()),
                  ),
                ),
                _buildActionCard(
                  'Leaderboard',
                  Icons.leaderboard,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LeaderboardPage()),
                  ),
                ),
                _buildActionCard(
                  'Complaints',
                  Icons.report,
                  Colors.red,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComplaintsPage(user: widget.user)),
                  ),
                ),
                _buildActionCard(
                  'Feedback',
                  Icons.feedback,
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackPage(user: widget.user)),
                  ),
                ),
                _buildActionCard(
                  'About Us',
                  Icons.people,
                  Colors.teal,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUsPage()),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Recent Waste Items
            const Text(
              'Recent Waste Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (userWasteItems.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No waste items uploaded yet. Start by classifying your waste!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userWasteItems.take(5).length,
                itemBuilder: (context, index) {
                  final item = userWasteItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getClassificationColor(item.classification),
                        child: Text(
                          item.classification[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        item.classification.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Uploaded: ${_formatDate(item.uploadDate)}',
                      ),
                      trailing: item.isCorrectlySegregated
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.pending, color: Colors.orange),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUserProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.user.ownerName}'),
            Text('Door Number: ${widget.user.doorNumber}'),
            Text('Area: ${widget.user.area}'),
            Text('District: ${widget.user.district}'),
            Text('Points: ${widget.user.points}'),
            Text('Tax Amount: ₹${widget.user.taxAmount}'),
            Text('Tax After Concession: ₹${widget.user.taxAfterConcession}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
