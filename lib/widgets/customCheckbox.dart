import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final Color color;
  final ValueChanged<bool> onChanged;
  final double size;
  final bool isBlocked;
  final bool initialValue;

  const CustomCheckbox({
    super.key,
    this.color = Colors.blue,
    required this.onChanged,
    this.size = 28,
    this.isBlocked = false,
    this.initialValue = false,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox>
    with SingleTickerProviderStateMixin {
  late bool _checked;
  late AnimationController _controller;
  late Animation<double> _anim;

  Color _darken(Color c) => HSLColor.fromColor(c)
      .withLightness((HSLColor.fromColor(c).lightness - 0.5).clamp(0.0, 1.0))
      .toColor();

  @override
  void initState() {
    super.initState();
    _checked = widget.initialValue;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: _checked ? 1.0 : 0.0,
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
    setState(() => _checked = !_checked);
    _checked ? _controller.forward() : _controller.reverse();
    widget.onChanged(_checked);
  }

  @override
  Widget build(BuildContext context) {
    final alpha = widget.isBlocked ? 0.4 : 1.0;
    final radius = widget.size * 0.18;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) => Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: _darken(widget.color).withValues(alpha: alpha),
            border: Border.all(
              color: widget.color.withValues(alpha: alpha),
              width: 1.5,
            ),
          ),
          child: _anim.value > 0
              ? Opacity(
                  opacity: _anim.value * alpha,
                  child: CustomPaint(
                    painter: _CheckPainter(
                      color: widget.color,
                      progress: _anim.value,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final Color color;
  final double progress;

  _CheckPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Checkmark points: from bottom-left to mid-bottom, then up to top-right
    final p1 = Offset(size.width * 0.2, size.height * 0.52);
    final p2 = Offset(size.width * 0.42, size.height * 0.72);
    final p3 = Offset(size.width * 0.78, size.height * 0.28);

    // Draw in two segments, each animating sequentially
    final path = Path();
    if (progress < 0.5) {
      final t = progress * 2;
      final mid = Offset.lerp(p1, p2, t)!;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(mid.dx, mid.dy);
    } else {
      final t = (progress - 0.5) * 2;
      final mid = Offset.lerp(p2, p3, t)!;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(mid.dx, mid.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}
