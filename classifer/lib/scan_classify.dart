import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class ScanClassifyTab extends StatefulWidget {
  const ScanClassifyTab({Key? key}) : super(key: key);

  @override
  State<ScanClassifyTab> createState() => _ScanClassifyTabState();
}

class _ScanClassifyTabState extends State<ScanClassifyTab> {
  File? _selectedImage;      // picked image
  String predictionText = ""; // prediction result

  void pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        predictionText = "";
      });
    }
  }

  void predictImage() async {
    if (_selectedImage == null) return;

    String result = await ApiService.uploadImage(_selectedImage!);
    try {
      var decoded = json.decode(result);
      setState(() {
        predictionText = decoded['prediction'];
      });
    } catch (e) {
      setState(() {
        predictionText = "Error parsing response";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image box
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: pickImage, child: const Text("Upload")),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: predictImage, child: const Text("Predict")),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            predictionText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
