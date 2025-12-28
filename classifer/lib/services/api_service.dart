import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String apiUrl = 'http://192.168.43.42:5000/predict'; // Your Flask IP

  static Future<String> uploadImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'), // change to 'png' if needed
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      return respStr; // JSON from Flask
    } else {
      return "Error: ${response.statusCode}";
    }
  }
}
