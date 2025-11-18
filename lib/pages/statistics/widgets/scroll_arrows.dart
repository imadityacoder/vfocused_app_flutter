import 'package:flutter/material.dart';

class ScrollArrows extends StatelessWidget {
  final double progress;
  const ScrollArrows({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left Arrow
        if (progress > 0)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.white60,
              ),
            ),
          ),

        // Right Arrow
        if (progress < 1)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.white60,
              ),
            ),
          ),
      ],
    );
  }
}
