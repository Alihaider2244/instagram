import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLikes;

  const LikeAnimation({
    Key? key, // Use 'Key?' instead of 'super.key'
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 2000),
    this.onEnd,
    this.smallLikes = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}
class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000), // Set duration to 1000 milliseconds (1 second)
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLikes) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 288));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.scale(
            scale: scale.value,
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (widget.onEnd != null) {
          widget.onEnd!();
        }
      }
    });
  }
}
