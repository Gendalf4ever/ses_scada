import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool isBlocked;

  const CustomButton({
    super.key,
    required this.label,
    this.color = Colors.blue,
    required this.onPressed,
    this.width = 160,
    this.height = 40,
    this.isBlocked = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _held = false;

  Color get _background => _held ? widget.color : _darken(widget.color);

  Color _darken(Color c) => HSLColor.fromColor(c)
      .withLightness((HSLColor.fromColor(c).lightness - 0.5).clamp(0.0, 1.0))
      .toColor();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isBlocked ? 0.4 : 1.0,
      child: GestureDetector(
        onTapDown: widget.isBlocked
            ? null
            : (_) => setState(() => _held = true),
        onTapUp: widget.isBlocked
            ? null
            : (_) {
                setState(() => _held = false);
                widget.onPressed();
              },
        onTapCancel: widget.isBlocked
            ? null
            : () => setState(() => _held = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _background,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(color: widget.color, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.height * 0.3),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.label,
                //maxLines: 1,
                style: TextStyle(
                  fontSize: widget.height * 0.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
