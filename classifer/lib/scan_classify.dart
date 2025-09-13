import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart'; // adjust path to your ApiService

class ScanClassifyTab extends StatefulWidget {
  const ScanClassifyTab({super.key});

  @override
  State<ScanClassifyTab> createState() => _ScanClassifyTabState();
}

class _ScanClassifyTabState extends State<ScanClassifyTab> {
  File? _selectedImage;
  String predictionText = "";
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  /// pick image from gallery
  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        predictionText = "";
      });
    }
  }

  /// capture image from camera
  Future<void> _captureFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        predictionText = "";
      });
    }
  }

  /// upload to API
  Future<void> _predictImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _loading = true;
    });

    final result = await ApiService.uploadImage(_selectedImage!);

    try {
      final decoded = json.decode(result);
      setState(() {
        predictionText = decoded['prediction'] ?? "No prediction returned";
      });
    } catch (e) {
      setState(() {
        predictionText = "Error parsing response";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _selectedImage != null
              ? Image.file(
            _selectedImage!,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          )
              : Container(
            width: 250,
            height: 250,
            color: Colors.grey[300],
            child: Icon(Icons.image, size: 100, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),

          // Buttons section with Wrap (replacing Row with wrap)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                onPressed: _pickFromGallery,
                label: const Text("Gallery"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                onPressed: _captureFromCamera,
                label: const Text("Camera"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                onPressed: _loading ? null : _predictImage,
                label: const Text("Predict"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (_loading) const CircularProgressIndicator(),

          if (predictionText.isNotEmpty && !_loading)
            Text(
              predictionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
