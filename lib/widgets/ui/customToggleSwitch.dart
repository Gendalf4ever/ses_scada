import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  final double height;
  final double width;
  final ValueChanged<bool> onToggle;
  final String leftLabel;
  final String rightLabel;
  final bool initialValue;
  final Color whenLeft;
  final Color whenRight;
  final bool isBlocked;

  const CustomToggleSwitch({
    super.key,
    this.height = 30,
    this.width = 70,
    required this.onToggle,
    this.leftLabel = '',
    this.rightLabel = '',
    this.initialValue = false,
    this.whenLeft = Colors.black,
    this.whenRight = Colors.blue,
    this.isBlocked = false,
  });

  @override
  State<CustomToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<CustomToggleSwitch>
    with SingleTickerProviderStateMixin {
  late bool _isRight;
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _isRight = widget.initialValue;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: _isRight ? 1.0 : 0.0,
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isBlocked) return;
    setState(() => _isRight = !_isRight);
    _isRight ? _controller.forward() : _controller.reverse();
    widget.onToggle(_isRight);
  }

  @override
  Widget build(BuildContext context) {
    final thumbSize = widget.height - 10;
    final fontSize = widget.height * 0.5;
    final alpha = widget.isBlocked ? 0.4 : 1.0;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          return Opacity(
            opacity: alpha,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                color: Color.lerp(
                  widget.whenLeft,
                  widget.whenRight,
                  _anim.value,
                ),
                border: Border.all(color: widget.whenRight, width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      _label(_isRight ? widget.leftLabel : '', fontSize),
                      _label(!_isRight ? widget.rightLabel : '', fontSize),
                    ],
                  ),
                  Align(
                    alignment: Alignment(_anim.value * 2 - 1, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text, double fontSize) => Expanded(
    child: Center(
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.1,
        ),
      ),
    ),
  );
}
