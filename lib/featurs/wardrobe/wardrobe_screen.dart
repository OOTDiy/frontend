import 'dart:io';
import 'package:flutter/material.dart';
import 'items.dart';
import 'outfits.dart'; // import OutfitsTab yang sudah kamu buat

class WardrobeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> initialImages;
  final List<File> initialOutfits;  // <-- tambah ini
  final Function(List<Map<String, dynamic>>) onItemsChanged;
  final Function(List<File>) onOutfitsChanged;  // <-- tambah ini

  const WardrobeScreen({
    Key? key,
    required this.initialImages,
    required this.initialOutfits,
    required this.onItemsChanged,
    required this.onOutfitsChanged,
  }) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  late List<Map<String, dynamic>> images;
  late List<File> outfits;  // <-- list outfit disimpan di sini
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    images = List.from(widget.initialImages);
    outfits = List.from(widget.initialOutfits);  // inisialisasi outfit
  }

  void _updateImages(List<Map<String, dynamic>> updatedImages) {
    setState(() {
      images = updatedImages;
    });
    widget.onItemsChanged(images);
  }

  void _updateOutfits(List<File> updatedOutfits) {
    setState(() {
      outfits = updatedOutfits;
    });
    widget.onOutfitsChanged(outfits);
  }

  Widget buildTabBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.grey[300]),
          ),
          Row(
            children: [
              buildTabItem(title: 'Items', index: 0),
              buildTabItem(title: 'Outfits', index: 1),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: _selectedIndex == 0 ? 0 : screenWidth / 2,
            bottom: 0,
            child: Container(
              width: screenWidth / 2,
              height: 2,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({required String title, required int index}) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOutfitsTab() {
    return OutfitsTab(
      savedOutfits: outfits,
      onDeleteOutfit: (file) {
        final updated = List<File>.from(outfits)..remove(file);
        _updateOutfits(updated);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Wardrobe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            buildTabBar(),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedIndex == 0
                  ? ItemsTab(
                savedItems: images,
                onItemsChanged: _updateImages,
              )
                  : buildOutfitsTab(),
            ),
          ],
        ),
      ),
    );
  }
}
