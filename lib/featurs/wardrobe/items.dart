import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/components/delete_actions.dart';  // import fungsi popup delete

class CategoryConstants {
  static const all = 'All';
  static const tops = 'Tops';
  static const bottoms = 'Bottoms';
  static const outwear = 'Outwear';
  static const footwear = 'Footwear';

  static const allCategories = [
    all,
    tops,
    bottoms,
    outwear,
    footwear,
  ];

  static const categoryIcons = {
    all: 'assets/category/all.svg',
    tops: 'assets/category/tops.svg',
    bottoms: 'assets/category/bottoms.svg',
    outwear: 'assets/category/outwear.svg',
    footwear: 'assets/category/footwear.svg',
  };
}

class ItemsTab extends StatefulWidget {
  final List<Map<String, dynamic>> savedItems;
  final Function(List<Map<String, dynamic>>) onItemsChanged;

  const ItemsTab({
    super.key,
    required this.savedItems,
    required this.onItemsChanged,
  });

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  String selectedCategory = CategoryConstants.all;

  List<Map<String, dynamic>> get filteredItems {
    if (selectedCategory == CategoryConstants.all) return widget.savedItems;
    return widget.savedItems
        .where((item) => item['category'] == selectedCategory)
        .toList();
  }

  Widget buildCategoryIcons() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: CategoryConstants.allCategories.length,
        itemBuilder: (context, index) {
          final category = CategoryConstants.allCategories[index];
          final isSelected = selectedCategory == category;
          final iconPath = CategoryConstants.categoryIcons[category]!;

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      iconPath,
                      width: 36,
                      height: 36,
                      colorFilter: isSelected
                          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onImageTap(int index) async {
    final selectedImage = filteredItems[index];

    // Show zoom + popup delete confirmation
    final shouldDelete = await Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => _ZoomDeletePhotoOverlay(
        imageFile: File(selectedImage['image'].path),
        onDelete: () => Navigator.of(context).pop(true),
      ),
      transitionDuration: const Duration(milliseconds: 300),
    ));

    if (shouldDelete == true) {
      // Hapus foto dari savedItems asli
      final updatedItems = List<Map<String, dynamic>>.from(widget.savedItems);
      updatedItems.remove(selectedImage);
      widget.onItemsChanged(updatedItems);
    }
  }

  Widget buildImageGrid() {
    final items = filteredItems;
    if (items.isEmpty) {
      return const Center(child: Text('No items found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final img = items[index];
        return GestureDetector(
          onTap: () => _onImageTap(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(img['image'].path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // supaya "Items Filter" rata kiri
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Items Filter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        buildCategoryIcons(),
        const SizedBox(height: 8),
        Expanded(child: buildImageGrid()),
      ],
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
                    // Tampilkan popup konfirmasi delete
                    showDeleteConfirmationDialog(context).then((confirmed) {
                      if (confirmed == true) {
                        onDelete();
                      }
                    });
                  },
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
