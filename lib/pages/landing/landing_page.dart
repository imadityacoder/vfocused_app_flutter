import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/widgets/landing_item.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    LandingItem(
      imagePath: 'assets/images/landing_img1.png',
      title: 'Welcome to \nVFocused App',
      subtitle:
          'Dial in your focus. Neon vibes + zero distractions = peak productivity.',
    ),

    LandingItem(
      imagePath: 'assets/images/landing_img2.png',
      title: 'AI-Powered Insights',
      subtitle:
          'Your personal AI agent tracks patterns, predicts your peak hours, and boosts your workflow.',
    ),

    LandingItem(
      imagePath: 'assets/images/landing_img3.png',
      title: 'Smart Cycles',
      subtitle:
          'Focus + break cycles auto-tuned by AI to match your grind. No more guesswork.',
    ),

    LandingItem(
      imagePath: 'assets/images/landing_img4.png',
      title: 'Your AI Companion Awaits',
      subtitle:
          'Ask anything. Get productivity tips, focus reports and routines — all powered by your AI agent.',
      showButton: true,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.card,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _pages[index],
          ),
          if (_currentPage != _pages.length - 1)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 12,
                      spacing: 8,
                      dotColor: Colors.white70,
                      activeDotColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("NEXT"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
