import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';

Future<String?> showApiKeyDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String? error;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Text(
              "Connect Your AI Agent 🤖✨",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "To unlock full AI performance, paste your API key below.\n"
                  "Don’t worry — it’s stored safely on your device only.",
                  style: TextStyle(color: Colors.white70, height: 1.3),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter your OpenAI API key",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final key = controller.text.trim();
                  if (key.isEmpty) {
                    setState(() {
                      error = 'Please enter your API key or press Skip.';
                    });
                    return;
                  }

                  // Basic validation: OpenAI keys typically start with 'sk-'
                  if (!key.startsWith('sk-')) {
                    setState(() {
                      error = 'This does not look like a valid OpenAI key.';
                    });
                    return;
                  }

                  Navigator.pop(context, key);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}
