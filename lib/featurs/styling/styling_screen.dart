import 'dart:io';
import 'package:flutter/material.dart';
import 'styling_dressme.dart';
import 'styling_canvas.dart';
import 'package:untitled1/widgets/profile_avatar.dart';
import 'package:untitled1/views/profile/profile_screen.dart';

class StylingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> images;

  const StylingScreen({Key? key, required this.images}) : super(key: key);

  @override
  State<StylingScreen> createState() => _StylingScreenState();
}

class _StylingScreenState extends State<StylingScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> selectedDressMeImages = [];
  late List<Map<String, dynamic>> canvasImages;

  @override
  void initState() {
    super.initState();
    canvasImages = widget.images
        .map((img) => {
      ...img,
      'offset': const Offset(50, 50),
      'key': UniqueKey(),
    })
        .toList();
  }

  void onDressMeImageClicked(Map<String, dynamic> img) {
    bool exists = selectedDressMeImages.any((e) => e['image'].path == img['image'].path);
    if (!exists) {
      setState(() {
        selectedDressMeImages.add(img);
      });
    }
  }

  void updateCanvasImage(Map<String, dynamic> newImg, Offset newOffset) {
    setState(() {
      int index = canvasImages.indexWhere((img) => img['image'].path == newImg['image'].path);
      if (index == -1) {
        canvasImages.add({...newImg, 'offset': newOffset, 'key': UniqueKey()});
      } else {
        canvasImages[index]['offset'] = newOffset;
      }
    });
  }

  void updateCanvasOffset(int index, Offset newOffset) {
    setState(() {
      canvasImages[index]['offset'] = newOffset;
    });
  }

  void onSaveOutfit(List<Map<String, dynamic>> selectedItems, File? fullOutfitImage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Outfit saved with ${selectedItems.length} items!')),
    );
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
              buildTabItem(title: 'Dress Me', index: 0),
              buildTabItem(title: 'Canvas', index: 1),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Styling',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: const ProfileAvatar(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            buildTabBar(),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedIndex == 0
                  ? DressMeSection(
                images: widget.images,
                selectedImages: selectedDressMeImages,
                onImageClicked: onDressMeImageClicked,
                onSaveOutfit: onSaveOutfit,
              )
                  : CanvasSection(
                images: widget.images,
                canvasImages: canvasImages,
                onImageDropped: updateCanvasImage,
                onDragEnd: updateCanvasOffset,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
