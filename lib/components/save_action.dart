import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

class SaveButton extends StatelessWidget {
  final GlobalKey canvasKey;
  final void Function(File)? onImageSaved;

  const SaveButton({
    super.key,
    required this.canvasKey,
    this.onImageSaved,
  });

  Future<void> _saveCanvasAsImage(BuildContext context) async {
    try {
      final renderObject = canvasKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Canvas tidak tersedia untuk disimpan.')),
        );
        return;
      }

      ui.Image image = await renderObject.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/outfit_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(pngBytes);

        onImageSaved?.call(file);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Outfit berhasil disimpan ke Wardrobe!')),
        );
      }
    } catch (e) {
      debugPrint("Error saving canvas as image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan outfit.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _saveCanvasAsImage(context),
      child: SvgPicture.asset(
        'assets/iconfitur/buttonsaveoutfits.svg',
        height: 32,
        width: 32,
      ),
    );
  }
}
