import 'dart:io';
import 'package:flutter/material.dart';

class DressMeCek extends StatelessWidget {
  final List<Map<String, dynamic>> selectedImages;
  final GlobalKey repaintBoundaryKey;

  const DressMeCek({
    Key? key,
    required this.selectedImages,
    required this.repaintBoundaryKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: Stack(
        alignment: Alignment.center,
        children: selectedImages.map((img) {
          final File imageFile = img['image'];
          return Image.file(
            imageFile,
            fit: BoxFit.contain,
            width: 250,
            height: 250,
          );
        }).toList(),
      ),
    );
  }
}
