import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vfocused_app/core/constants.dart';

class FocusTimer extends StatefulWidget {
  const FocusTimer({super.key});

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> {
  double _selectedMinutes = 25;
  Duration _remaining = const Duration(minutes: 25);
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (_timer != null) _timer!.cancel();

    setState(() {
      _isRunning = true;
      _remaining = Duration(minutes: _selectedMinutes.toInt());
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _isRunning = false);
      } else {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remaining = Duration(minutes: _selectedMinutes.toInt());
    });
  }

  String _formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        _remaining.inSeconds /
        (Duration(minutes: _selectedMinutes.toInt()).inSeconds);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Background progress (full ring)
            SizedBox(
              width: 250,
              height: 250,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 20,
                backgroundColor: Colors.grey.shade900,
                valueColor: const AlwaysStoppedAnimation(AppColors.neonGreen),
              ),
            ),
            // Sleek Slider (only usable when not running)
            if (!_isRunning)
              SleekCircularSlider(
                initialValue: _selectedMinutes,
                max: 120,
                min: 1,
                onChange: (double value) {
                  setState(() {
                    _selectedMinutes = value;
                    _remaining = Duration(minutes: value.toInt());
                  });
                },
                innerWidget: (value) {
                  return Center(
                    child: Text(
                      '${value.toInt()} min',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                appearance: CircularSliderAppearance(
                  angleRange: 360,
                  startAngle: -90,
                  customColors: CustomSliderColors(
                    dotColor: AppColors.neonBlue,
                    progressBarColor: AppColors.neonBlue,
                    trackColor: Colors.grey.shade900,
                  ),
                  size: 220,
                  customWidths: CustomSliderWidths(
                    progressBarWidth: 16,
                    trackWidth: 12,
                    handlerSize: 20,
                  ),
                ),
              ),
            // Timer Text
            if (_isRunning)
              Center(
                child: Text(
                  _formatTime(_remaining),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Labels
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 10),
                Text(
                  "FOCUS",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 80),
                Text(
                  "till 8:30",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Play / Pause Button
        SizedBox(
          height: 120,
          child: IconButton(
            onPressed: _isRunning ? null : _startTimer,
            iconSize: 80,
            splashRadius: 90,
            icon: Icon(
              _isRunning ? Icons.pause_circle : Icons.play_circle,
              color: AppColors.neonGreen,
            ),
          ),
        ),
        TextButton(
          onPressed: _resetTimer,
          child: const Text(
            'Reset',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
