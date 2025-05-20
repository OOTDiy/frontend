import 'dart:io';
import 'package:flutter/material.dart';
import 'styling_dressme.dart';  // DressMeSection
import 'styling_canvas.dart';  // CanvasSection

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
    // Inisialisasi canvasImages dengan offset default dan key unik tiap image
    canvasImages = widget.images
        .map((img) => {
      ...img,
      'offset': const Offset(50, 50),
      'key': UniqueKey(),
    })
        .toList();
  }

  void onDressMeImageClicked(Map<String, dynamic> img) {
    // Cek apakah image sudah ada di selectedDressMeImages
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
        // Kalau belum ada, tambahkan baru dengan posisi offset baru
        canvasImages.add({...newImg, 'offset': newOffset, 'key': UniqueKey()});
      } else {
        // Update posisi offset untuk image yang sudah ada
        canvasImages[index]['offset'] = newOffset;
      }
    });
  }

  void updateCanvasOffset(int index, Offset newOffset) {
    setState(() {
      canvasImages[index]['offset'] = newOffset;
    });
  }

  // Callback saat user tekan tombol save di DressMeSection
  void onSaveOutfit(List<Map<String, dynamic>> selectedItems, File? fullOutfitImage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Outfit saved with ${selectedItems.length} items!')),
    );

    // Bisa tambah logika simpan data ke database atau storage di sini
  }

  Widget buildTabBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          // Garis abu-abu bawah
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
          // Indikator garis bawah tab aktif
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
            const Center(
              child: Text(
                'Styling',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
