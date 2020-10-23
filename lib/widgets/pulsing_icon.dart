import 'package:flutter/material.dart';

class PulsingIconWidget extends StatefulWidget {
  final IconData icon;
  final double maxSize;
  final double minSize;

  PulsingIconWidget({this.icon: Icons.mic, this.maxSize: 30, this.minSize: 25});

  @override
  State<StatefulWidget> createState() {
    return _PulsingIconState();
  }
}
class _PulsingIconState extends State<PulsingIconWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: widget.minSize, end: widget.maxSize)
        .animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      size: animation.value,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
