import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/pages/home/ai_agent.dart';
import 'package:vfocused_app/pages/home/ai_review_card.dart';
import 'package:vfocused_app/widgets/api_key_dialog.dart';
import 'package:vfocused_app/providers/ai_review_provider.dart';
import 'package:vfocused_app/providers/pomodoro_provider.dart';
import 'package:vfocused_app/widgets/app_drawer.dart';
import 'package:vfocused_app/widgets/focus_timer.dart';
import 'package:vfocused_app/services/ai_sevices.dart';
// ← Add this if you made separate file

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Future.microtask(() {
      ref.read(aiReviewProvider.notifier).fetchReview();
    });
  }

  Future<String?> _getSavedApiKey() async {
    return await ApiKeyStorage.getKey();
  }

  Future<void> _openAIAgent(BuildContext context) async {
    // Check if API key exists
    String? key = await _getSavedApiKey();

    if (key == null || key.isEmpty) {
      // Ask for API key first
      key = await showApiKeyDialog(context);

      if (key == null) return; // user skipped or cancelled

      await ApiKeyStorage.saveKey(key);
    }

    // Refresh AI review when AI agent is opened
    ref.read(aiReviewProvider.notifier).fetchReview();

    // Open the AI chat bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AIChatBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final focusedToday = ref.watch(focusedTodayProvider);
    final aiReview = ref.watch(aiReviewProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder:
              (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  borderRadius: BorderRadius.circular(30),
                  child: SvgPicture.asset('assets/icons/Menu.svg'),
                ),
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              "Focused Today: ${focusedToday}min",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    aiReviewCard(aiReview),
                    const SizedBox(height: 40),

                    FocusTimer(),
                  ],
                ),
              ),
            ),

            // AI Agent FAB
            AIAgentFAB(
              onTap: () => _openAIAgent(context), // ← Updated
            ),
          ],
        ),
      ),
    );
  }
}
