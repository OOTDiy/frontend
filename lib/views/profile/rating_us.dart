import 'package:flutter/material.dart';

class RatingUsScreen extends StatelessWidget {
  const RatingUsScreen({Key? key}) : super(key: key);

  void _submitRating(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your rating!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double _currentRating = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Us"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "How was your experience?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  spacing: 8,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _currentRating ? Icons.star : Icons.star_border,
                        size: 32,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () => _submitRating(context),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
