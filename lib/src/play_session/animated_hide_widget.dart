import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';

class AnimatedHideWidget extends StatefulWidget {
  final Color color;
  AnimatedHideWidget({required this.color});

  @override
  _AnimatedHideWidgetState createState() => _AnimatedHideWidgetState();
}

class _AnimatedHideWidgetState extends State<AnimatedHideWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isVisible = false;
        });
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return AnimatedOpacity(
      opacity: _isVisible ? _animation.value : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        width: 1.sw,
        height: 1.sh,
        color: widget.color,
        child: Center(
          child: CircularProgressIndicator(
            color: palette.textColor,
          ),
        ),
      ),
    );
  }
}
