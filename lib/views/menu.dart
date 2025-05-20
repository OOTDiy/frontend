import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/featurs/camera/camera_fitur.dart';
import 'package:untitled1/featurs/styling/styling_screen.dart';
import 'package:untitled1/featurs/wardrobe/wardrobe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // default ke Styling

  List<Map<String, dynamic>> images = [];
  List<File> outfits = []; // state outfit

  void _addImage(Map<String, dynamic> imageData) {
    setState(() {
      images.add(imageData);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onCameraTap() async {
    await CameraFitur.show(context, _addImage);
  }

  // Callback saat ada perubahan item di wardrobe
  void _onWardrobeItemsChanged(List<Map<String, dynamic>> updatedImages) {
    setState(() {
      images = updatedImages;
    });
  }

  // Callback saat ada perubahan outfit di wardrobe
  void _onWardrobeOutfitsChanged(List<File> updatedOutfits) {
    setState(() {
      outfits = updatedOutfits;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      StylingScreen(images: images),
      WardrobeScreen(
        initialImages: images,
        initialOutfits: outfits,
        onItemsChanged: _onWardrobeItemsChanged,
        onOutfitsChanged: _onWardrobeOutfitsChanged,
      ),
    ];

    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 105,
        width: 375,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                painter: _BottomNavPainter(),
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(
                        index: 0,
                        assetPath: 'assets/menu/styling.svg',
                        activeColor: Colors.lightBlue,
                        label: 'Styling',
                        activeIconColorPath: 'assets/menu/icon-color-styling.svg',
                      ),
                      _buildNavItem(
                        index: 1,
                        assetPath: 'assets/menu/wardrobe.svg',
                        activeColor: Colors.yellow,
                        label: 'Wardrobe',
                        activeIconColorPath: 'assets/menu/icon-color-wardrobe.svg',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: _onCameraTap,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String assetPath,
    required Color activeColor,
    required String label,
    String? activeIconColorPath,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isSelected && activeIconColorPath != null)
                Transform.scale(
                  scale: 0.85,
                  child: SvgPicture.asset(
                    activeIconColorPath,
                    width: 28,
                    height: 28,
                  ),
                ),
              SvgPicture.asset(
                assetPath,
                width: 28,
                height: 28,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}

// Painter untuk bottom nav lengkung
class _BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    final double radius = 36;
    final double centerX = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(centerX - radius - 10, 0);

    path.quadraticBezierTo(
      centerX - radius,
      0,
      centerX - radius + 10,
      -radius / 2,
    );
    path.arcToPoint(
      Offset(centerX + radius - 10, -radius / 2),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.quadraticBezierTo(
      centerX + radius,
      0,
      centerX + radius + 10,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
