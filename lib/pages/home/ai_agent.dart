import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/services/ai_sevices.dart';

class AIAgentFAB extends StatelessWidget {
  final VoidCallback onTap;

  const AIAgentFAB({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 70,
      right: 25,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.neonPink,
                AppColors.neonPurple,
                AppColors.neonBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(Icons.auto_awesome, color: Colors.yellowAccent, size: 28),
        ),
      ),
    );
  }
}

class AIChatBottomSheet extends StatefulWidget {
  const AIChatBottomSheet({super.key});

  @override
  State<AIChatBottomSheet> createState() => _AIChatBottomSheetState();
}

class _AIChatBottomSheetState extends State<AIChatBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  final ai = AIService();

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "msg": text});
    });

    _controller.clear();

    // 👇 Call LLM
    try {
      final reply = await ai.sendMessage(text);
      setState(() {
        messages.add({"sender": "bot", "msg": reply});
      });
    } catch (e) {
      String msg;
      if (e is ApiKeyMissingException) {
        msg = 'API key not set. Please add it in Settings.';
      } else if (e is ApiKeyInvalidException) {
        msg = 'Invalid API key. Please check your settings.';
      } else if (e is NetworkException) {
        msg = 'Network error. Check your connection.';
      } else if (e is ApiException) {
        msg = 'AI service error: ${e.message}';
      } else {
        msg = 'Unexpected error: ${e.toString()}';
      }

      setState(() {
        messages.add({"sender": "bot", "msg": msg});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SafeArea(
            top: false,
            child: DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.40,
              maxChildSize: 0.75,
              builder: (_, controller) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 15, 15, 15),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final item = messages[index];
                            final isUser = item["sender"] == "user";

                            return Column(
                              crossAxisAlignment:
                                  isUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                // --- Sender Label ---
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: isUser ? 40 : 4,
                                    right: isUser ? 4 : 40,
                                    bottom: 3,
                                  ),
                                  child: Text(
                                    isUser ? "You" : "AI",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                // --- Bubble ---
                                Align(
                                  alignment:
                                      isUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 6,
                                      bottom: 6,
                                      left:
                                          isUser
                                              ? 40
                                              : 0, // ⬅️ more margin for user bubble
                                      right:
                                          isUser
                                              ? 0
                                              : 40, // ➡️ more margin for AI bubble
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isUser
                                              ? Colors.purple.shade500
                                              : Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      item["msg"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Ask anything...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade900,
                                  contentPadding: const EdgeInsets.all(14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: sendMessage,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.neonPurple,
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
