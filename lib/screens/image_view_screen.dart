import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(
            File(imagePath),
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
