import 'package:authtesting/cloudinaryController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageSaver extends StatefulWidget {
  const ImageSaver({super.key});

  @override
  State<ImageSaver> createState() => _ImageSaverState();
}

class _ImageSaverState extends State<ImageSaver> {
  void uploadAssetImageToCloudinary() async {
    CloudinaryService cloudinaryService = CloudinaryService();

    String? imageUrl =
        await cloudinaryService.uploadAssetImage("assets/abdur-rahman.jpeg");

    if (imageUrl != null) {
      await cloudinaryService.saveImageUrlToFirestore(imageUrl);
      print("Asset image saved to Firestore: $imageUrl");
    } else {
      print("Image upload failed!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloudinary Testing"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  uploadAssetImageToCloudinary();
                },
                child: const Text("Send Data to Cloudinary"))
          ],
        ),
      ),
    );
  }
}
