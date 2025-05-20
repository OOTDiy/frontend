import 'package:flutter/material.dart';

Future<String?> showCategoryPopup(BuildContext context, List<String> categories) {
  String? selectedCategory;

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Choose Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 260, //
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final bool isSelected = selectedCategory == category;

                  return SizedBox(
                    width: 77,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.orange : Colors.grey[300],
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        Navigator.pop(context, category);
                      },
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      );
    },
  );
}
