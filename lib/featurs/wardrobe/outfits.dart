import 'dart:io';
import 'package:flutter/material.dart';

class OutfitsTab extends StatelessWidget {
  final List<File> savedOutfits;
  final Function(File) onDeleteOutfit;

  const OutfitsTab({
    Key? key,
    required this.savedOutfits,
    required this.onDeleteOutfit,
  }) : super(key: key);

  Future<void> _showDeleteDialog(BuildContext context, File outfit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Outfit?'),
        content: const Text('Are you sure you want to delete this outfit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF27255)),
            onPressed: () => Navigator.pop(context, true),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDeleteOutfit(outfit);
    }
  }

  Future<void> _onImageTap(BuildContext context, File file) async {
    final shouldDelete = await Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => _ZoomDeletePhotoOverlay(
        imageFile: file,
        onDelete: () => Navigator.of(context).pop(true),
      ),
      transitionDuration: const Duration(milliseconds: 300),
    ));

    if (shouldDelete == true) {
      onDeleteOutfit(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (savedOutfits.isEmpty) {
      return const Center(
        child: Text(
          'No outfits saved yet',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: savedOutfits.length,
      itemBuilder: (context, index) {
        final file = savedOutfits[index];
        return GestureDetector(
          onTap: () => _onImageTap(context, file),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(file, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}

class _ZoomDeletePhotoOverlay extends StatelessWidget {
  final File imageFile;
  final VoidCallback onDelete;

  const _ZoomDeletePhotoOverlay({
    Key? key,
    required this.imageFile,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(false), // tap luar tutup
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: imageFile.path,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(imageFile),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Outfit?'),
                        content: const Text('Are you sure you want to delete this outfit?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Delete', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ).then((confirmed) {
                      if (confirmed == true) {
                        onDelete();
                      }
                    });
                  },
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
