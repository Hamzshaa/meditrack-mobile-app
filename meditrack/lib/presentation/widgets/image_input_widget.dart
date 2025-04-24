// presentation/widgets/image_input_widget.dart
import 'dart:io';
import 'package:flutter/foundation.dart'; // Import kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageInputWidget extends StatefulWidget {
  final Function(List<XFile> images) onImagesPicked;
  final List<String> existingImageUrls; // Full URLs expected here
  // final Function(String imageUrl)? onExistingImageRemoved; // Optional callback

  const ImageInputWidget({
    required this.onImagesPicked,
    this.existingImageUrls = const [],
    // this.onExistingImageRemoved,
    super.key,
  });

  @override
  State<ImageInputWidget> createState() => _ImageInputWidgetState();
}

class _ImageInputWidgetState extends State<ImageInputWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImages = []; // Store newly picked images

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (images.isNotEmpty) {
        setState(() {
          // Append new images to the list
          _pickedImages.addAll(images);
        });
        widget.onImagesPicked(_pickedImages); // Notify parent
      }
    } catch (e) {
      print("Error picking images: $e");
      if (mounted) {
        // Check if widget is still mounted before showing snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error picking images: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _removePickedImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
    widget.onImagesPicked(_pickedImages); // Notify parent
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Display Existing Images (if any) ---
        // (This part uses CachedNetworkImage and should be fine)
        if (widget.existingImageUrls.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Current Images:",
                style: Theme.of(context).textTheme.labelMedium),
          ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.existingImageUrls.map((url) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[200],
                        child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2))),
                    errorWidget: (context, url, error) => Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red)),
                  ),
                ),
                // --- Optional: Button to remove existing images ---
              ],
            );
          }).toList(),
        ),
        if (widget.existingImageUrls.isNotEmpty) const SizedBox(height: 16),

        // --- Display Picked Images ---
        if (_pickedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("New Images to Upload:",
                style: Theme.of(context).textTheme.labelMedium),
          ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(_pickedImages.length, (index) {
            final file = _pickedImages[index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  // --- FIX: Use Image.network for web, Image.file for mobile ---
                  child: kIsWeb
                      ? Image.network(
                          // Use network for web (handles blob: URLs)
                          file.path,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          // Add error/loading builders for network image
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error_outline,
                                      color: Colors.red)),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Image.file(
                          // Use file for mobile
                          File(file.path),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error_outline,
                                      color: Colors.red)),
                        ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => _removePickedImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),

        // --- Add Image Button ---
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.add_a_photo_outlined),
          label: const Text('Add Images'),
          onPressed: _pickImages,
        ),
      ],
    );
  }
}
