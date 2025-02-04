import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "dux0ckhvc";
  // final String uploadPreset =
  //     "your_upload_preset"; // Only if using unsigned uploads

  Future<String?> uploadAssetImage(String assetPath) async {
    try {
      // Load asset image as bytes
      ByteData byteData = await rootBundle.load(assetPath);
      List<int> imageData = byteData.buffer.asUint8List();

      // Create multipart request
      Uri uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      var request = http.MultipartRequest("POST", uri);
      // ..fields['upload_preset'] = uploadPreset
      // ..files.add(http.MultipartFile.fromBytes("file", imageData,
      //     filename: "upload.jpg"));

      // Send request
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        return jsonData['secure_url']; // Cloudinary image URL
      } else {
        print("Upload Failed: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Error uploading asset image: $e");
      return null;
    }
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    await FirebaseFirestore.instance
        .collection('images')
        .add({'url': imageUrl});
  }
}
