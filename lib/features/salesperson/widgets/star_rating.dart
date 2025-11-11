// lib/features/salesperson/widgets/star_rating.dart

import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final String label;
  final Function(int) onRatingChanged;

  const StarRating({
    super.key,
    required this.label,
    required this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: const TextStyle(fontSize: 14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                  widget.onRatingChanged(_rating);
                },
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                // --- FIX APPLIED HERE ---
                // These two lines remove the default padding and minimum touch area,
                // making the buttons smaller and preventing the horizontal overflow.
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                // --------------------------
              );
            }),
          ),
        ],
      ),
    );
  }
}