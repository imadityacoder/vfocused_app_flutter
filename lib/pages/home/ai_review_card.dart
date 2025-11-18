import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';

Widget aiReviewCard(String reviewText) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.neonPurple, size: 22),
            SizedBox(width: 8),
            Text(
              "AI Review",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        Text(
          reviewText,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
            height: 1.3,
          ),
        ),
      ],
    ),
  );
}
