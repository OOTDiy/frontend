import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/components/canvas_action.dart';

class CanvasSection extends StatefulWidget {
  final List<Map<String, dynamic>> images;
  final List<Map<String, dynamic>> canvasImages;
  final Function(Map<String, dynamic>, Offset) onImageDropped;
  final Function(int, Offset) onDragEnd;

  const CanvasSection({
    super.key,
    required this.images,
    required this.canvasImages,
    required this.onImageDropped,
    required this.onDragEnd,
  });

  @override
  State<CanvasSection> createState() => _CanvasSectionState();
}

class _CanvasSectionState extends State<CanvasSection> {
  final List<String> categoryOrder = ['Tops', 'Bottoms', 'Outwear', 'Footwear', 'Other'];
  String selectedCategory = 'Tops';
  late CanvasActionsManager actionsManager;

  @override
  void initState() {
    super.initState();
    actionsManager = CanvasActionsManager();
    actionsManager.save(widget.canvasImages);
  }

  void _handleSave() {
    actionsManager.save(widget.canvasImages);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Canvas saved')),
    );
  }

  void _handleUndo() {
    setState(() {
      widget.canvasImages.clear();
      widget.canvasImages.addAll(actionsManager.undo());
    });
  }

  void _handleRedo() {
    setState(() {
      widget.canvasImages.clear();
      widget.canvasImages.addAll(actionsManager.redo());
    });
  }

  void _handleReload() {
    setState(() {
      widget.canvasImages.clear();
      widget.canvasImages.addAll(actionsManager.reload(widget.images));
    });
  }

  void _handleDrop(Map<String, dynamic> data, Offset offset) {
    widget.onImageDropped(data, offset);
    actionsManager.save(widget.canvasImages);
    setState(() {});
  }

  void _handleDragEnd(int index, Offset clamped) {
    widget.onDragEnd(index, clamped);
    actionsManager.save(widget.canvasImages);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              DragTarget<Map<String, dynamic>>(
                onAcceptWithDetails: (details) {
                  _handleDrop(details.data, details.offset);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: Colors.white,
                    child: Stack(
                      children: widget.canvasImages.map((img) {
                        int index = widget.canvasImages.indexOf(img);
                        return Positioned(
                          key: img['key'],
                          left: img['offset'].dx,
                          top: img['offset'].dy,
                          child: Draggable<int>(
                            data: index,
                            feedback: Opacity(
                              opacity: 0.7,
                              child: SizedBox(
                                width: 100,
                                child: Image.file(img['image']),
                              ),
                            ),
                            childWhenDragging: Container(),
                            onDragEnd: (details) {
                              final renderBox = context.findRenderObject() as RenderBox;
                              Offset localPos = renderBox.globalToLocal(details.offset);
                              double maxX = renderBox.size.width - 100;
                              double maxY = renderBox.size.height - 100;

                              Offset clamped = Offset(
                                localPos.dx.clamp(0, maxX),
                                localPos.dy.clamp(0, maxY),
                              );

                              _handleDragEnd(index, clamped);
                            },
                            child: SizedBox(
                              width: 100,
                              child: Image.file(img['image']),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              Positioned(
                top: 4,
                right: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 32,
                      onPressed: _handleSave,
                      icon: SvgPicture.asset('assets/iconfitur/buttonsaveoutfits.svg'),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      iconSize: 32,
                      onPressed: _handleUndo,
                      icon: SvgPicture.asset('assets/iconfitur/undo.svg'),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      iconSize: 32,
                      onPressed: _handleRedo,
                      icon: SvgPicture.asset('assets/iconfitur/redo.svg'),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      iconSize: 32,
                      onPressed: _handleReload,
                      icon: SvgPicture.asset('assets/iconfitur/reload.svg'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 135,
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
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: widget.images
                      .where((img) => img['category'] == selectedCategory)
                      .isEmpty
                      ? const Center(
                    child: Text(
                      'No images',
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  )
                      : SingleChildScrollView(
                    child: Column(
                      children: widget.images
                          .where((img) => img['category'] == selectedCategory)
                          .map((img) {
                        return Draggable<Map<String, dynamic>>(
                          data: img,
                          feedback: Opacity(
                            opacity: 0.7,
                            child: SizedBox(
                              width: 100,
                              child: Image.file(img['image']),
                            ),
                          ),
                          childWhenDragging: Container(),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
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
                      }).toList(),
                    ),
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
