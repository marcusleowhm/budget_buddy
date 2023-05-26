import 'dart:math';

import 'package:flutter/material.dart';

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeError extends StatefulWidget {
  const ShakeError({
    super.key,
    required this.child,
    required this.duration,
    required this.shakeCount,
    required this.shakeOffset,
  });

  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration duration;

  @override
  // ignore: no_logic_in_create_state
  State<ShakeError> createState() => ShakeErrorState(duration);
}

class ShakeErrorState extends AnimationControllerState<ShakeError> {
  ShakeErrorState(Duration animationDuration) : super(animationDuration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue =
            sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}
