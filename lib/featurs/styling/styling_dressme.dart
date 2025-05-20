import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DressMeSection extends StatefulWidget {
  final List<Map<String, dynamic>> images; // Semua image baju
  final List<Map<String, dynamic>>? selectedImages; // Bisa null, fallback di state
  final Function(Map<String, dynamic>) onImageClicked;
  final Function(List<Map<String, dynamic>> selectedItems, File? fullOutfitImage) onSaveOutfit;

  const DressMeSection({
    super.key,
    required this.images,
    this.selectedImages,
    required this.onImageClicked,
    required this.onSaveOutfit,
  });

  @override
  State<DressMeSection> createState() => _DressMeSectionState();
}

class _DressMeSectionState extends State<DressMeSection> {
  late List<Map<String, dynamic>> _selectedImages;

  // Perbaikan: pakai 'Bottoms' sesuai data input dari kamera
  final List<String> categoryOrder = const ['Tops', 'Bottoms', 'Outwear', 'Footwear', 'Other'];
  String selectedCategory = 'Tops';

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages ?? [];
  }

  List<Widget> buildDressMeList() {
    final filtered = widget.images.where((img) => img['category'] == selectedCategory).toList();

    if (filtered.isEmpty) {
      return [
        Container(
          height: 300,
          alignment: Alignment.center,
          child: const Text(
            'No images',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        )
      ];
    }

    return filtered.map((img) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (!_selectedImages.any((sel) => sel['image'].path == img['image'].path)) {
              _selectedImages.add(img);
            }
          });
          widget.onImageClicked(img);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              img['image'],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildSelectedDressMeImages() {
    List<Widget> widgets = [];

    for (var cat in categoryOrder) {
      final filtered = _selectedImages.where((img) => img['category'] == cat).toList();
      if (filtered.isEmpty) continue;

      widgets.addAll(filtered.map((img) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedImages.removeWhere((sel) => sel['image'].path == img['image'].path);
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    img['image'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList());
    }

    if (widgets.isEmpty) {
      widgets.add(
        SizedBox(
          height: 500,
          child: const Center(
            child: Text('Select clothes to display'),
          ),
        ),
      );
    }

    return widgets;
  }

  void _handleSaveOutfit() {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select clothes before saving')),
      );
      return;
    }

    File? fullOutfitImage; // Bisa dikembangkan untuk screenshot outfit lengkap
    widget.onSaveOutfit(_selectedImages, fullOutfitImage);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Outfit saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelectedClothes = _selectedImages.isNotEmpty;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: hasSelectedClothes ? _handleSaveOutfit : null,
                  child: Opacity(
                    opacity: hasSelectedClothes ? 1.0 : 0.5,
                    child: SvgPicture.asset(
                      'assets/iconfitur/buttonsaveoutfits.svg',
                      height: 32,
                      width: 32,
                      color: hasSelectedClothes ? null : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildSelectedDressMeImages(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          width: 135,
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 35,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  children: categoryOrder.map((cat) {
                    final isSelected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Center(
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: buildDressMeList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
