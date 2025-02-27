import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/widgets.dart';

class LoadingAnimationWidget extends StatefulWidget {
  const LoadingAnimationWidget({
    required this.color,
    required this.loadingText,
    required this.emojis,
    super.key,
  });

  final Color color;
  final Widget loadingText;
  final bool emojis;

  @override
  LoadingAnimationWidgetState createState() => LoadingAnimationWidgetState();
}

class LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with SingleTickerProviderStateMixin {
  final List<String> emojis = ['😊', '🌟', '💫', '✨', '🎉'];
  int _currentEmojiIndex = 0;
  Timer? _timer;
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.emojis) {
      _setTimer();
    } else {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );

      _animation = IntTween(begin: 0, end: 3).animate(_controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        });

      _controller.forward();
    }
  }

  void _setTimer() {
    final duration = Random().nextInt(250) + 250;
    _timer = Timer(Duration(milliseconds: duration), () {
      setState(() {
        _currentEmojiIndex = (_currentEmojiIndex + 1) % emojis.length;
      });
      _setTimer();
    });
  }

  @override
  void dispose() {
    if (widget.emojis) {
      _timer?.cancel();
    } else {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.loadingText,
        if (widget.emojis)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              emojis[_currentEmojiIndex],
              style: TextStyle(
                color: widget.color,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          )
        else
          AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              return SizedBox(
                width: 24,
                child: FxText.bodyLarge(
                  '.' * _animation.value,
                  color: widget.color,
                  fontWeight: 700,
                  textAlign: TextAlign.left,
                ),
              );
            },
          ),
      ],
    );
  }
}
