import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/pomodoro_provider.dart';

class FullscreenPomodoroClock extends ConsumerStatefulWidget {
  const FullscreenPomodoroClock({super.key});

  @override
  ConsumerState<FullscreenPomodoroClock> createState() =>
      _FullscreenPomodoroClockState();
}

class _FullscreenPomodoroClockState
    extends ConsumerState<FullscreenPomodoroClock> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
    // Lock to landscape mode only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // ensure overlay cleaned
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showOverlay(dynamic pomodoroState, dynamic pomodoroNotifier) {
    final overlay = Overlay.of(context);

    // remove any existing overlay (we'll re-create it)
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        // Positioned at bottom center (same UI as before)
        return Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: OverlayControls(
            pomodoroState: pomodoroState,
            pomodoroNotifier: pomodoroNotifier,
            onRequestRemove: () {
              if (entry.mounted) {
                entry.remove();
                if (_overlayEntry == entry) _overlayEntry = null;
              }
            },
            onClose: () {
              if (entry.mounted) {
                entry.remove();
                if (_overlayEntry == entry) _overlayEntry = null;
              }
              // pop the fullscreen page (same behavior you wanted)
              Navigator.pop(context);
            },
          ),
        );
      },
    );

    _overlayEntry = entry;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final pomodoroState = ref.watch(pomodoroProvider);
    final pomodoroNotifier = ref.read(pomodoroProvider.notifier);

    final sessionLabel =
        pomodoroState.session == PomodoroSession.focus
            ? 'FOCUS'
            : pomodoroState.session == PomodoroSession.shortBreak
            ? 'SHORT BREAK'
            : 'LONG BREAK';

    final timeRemaining = formatDuration(pomodoroState.remaining);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showOverlay(pomodoroState, pomodoroNotifier),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sessionLabel,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      timeRemaining,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.75,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 0.95,
                        wordSpacing: 0.9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A self-contained overlay widget that handles its own fade-in/out
/// and auto-hide timer. It calls `onRequestRemove` when the overlay
/// should be removed (after fade-out).
class OverlayControls extends StatefulWidget {
  final dynamic pomodoroState;
  final dynamic pomodoroNotifier;
  final VoidCallback onRequestRemove;
  final VoidCallback onClose;

  const OverlayControls({
    super.key,
    required this.pomodoroState,
    required this.pomodoroNotifier,
    required this.onRequestRemove,
    required this.onClose,
  });

  @override
  State<OverlayControls> createState() => _OverlayControlsState();
}

class _OverlayControlsState extends State<OverlayControls>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _hideTimer;
  bool _isHiding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _controller.forward();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    // 3 seconds of inactivity then fade out
    _hideTimer = Timer(
      const Duration(seconds: 3),
      () => _fadeOut(close: false),
    );
  }

  void _fadeOut({required bool close}) {
    if (_isHiding) return;
    _isHiding = true;
    _hideTimer?.cancel();
    _controller.reverse().then((_) {
      if (!mounted) return;
      widget.onRequestRemove();
      if (close) widget.onClose();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // tapping anywhere on the overlay should reset the hide timer
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _startHideTimer,
      child: FadeTransition(
        opacity: _controller,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  label: Text(
                    widget.pomodoroState.isRunning ? 'Pause' : 'Play',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        widget.pomodoroState.session != PomodoroSession.focus
                            ? AppColors.neonPurple.withValues(alpha: 0.2)
                            : AppColors.neonGreen.withValues(alpha: 0.2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  icon: Icon(
                    widget.pomodoroState.isRunning
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color:
                        widget.pomodoroState.session != PomodoroSession.focus
                            ? AppColors.neonPurple
                            : AppColors.neonGreen,
                    size: 28,
                  ),
                  onPressed: () {
                    // keep overlay alive while user interacts with buttons
                    if (widget.pomodoroState.isRunning) {
                      widget.pomodoroNotifier.pause();
                    } else {
                      widget.pomodoroNotifier.start();
                    }
                    _startHideTimer();
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  iconSize: 36,
                  splashRadius: 50,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.neonBlue.withValues(alpha: 0.2),
                  ),
                  icon: const Icon(
                    Icons.fullscreen_exit_rounded,
                    color: AppColors.neonBlue,
                  ),
                  onPressed: () {
                    // fade out and then remove + close route
                    _fadeOut(close: true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
