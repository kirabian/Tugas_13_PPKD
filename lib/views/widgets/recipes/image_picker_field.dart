import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerField extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;

  const ImagePickerField({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Foto Resep:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(selectedImage!, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Text(
                      "Pilih gambar",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
