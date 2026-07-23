import 'package:flutter/material.dart';

import '../components/colorManager.dart';


class CustomButton extends StatefulWidget {
  final String? label;
  final Widget? icon;
  final Color? color;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final double? borderWidth;
  final double width;
  final double height;
  final bool isBlocked;

  const CustomButton({
    super.key,
    this.label,
    this.icon,
    this.color,
    this.borderColor,
    this.backgroundColor,
    required this.onPressed,
    this.borderWidth,
    this.width = 160,
    this.height = 40,
    this.isBlocked = false,
  }) : assert(label != null || icon != null, 'Provide either label or child');

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _held = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ColorManager.primary;
    final backgroundColor =
        widget.backgroundColor ?? ColorManager.widgetBackground;

    Widget content;
    if (widget.icon != null) {
      content = widget.icon!;
    } else {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.height * 0.3),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.label!,
            style: TextStyle(
              fontSize: widget.height * 0.5,
              fontWeight: FontWeight.w600,
              color: ColorManager.text,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );
    }

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
            color: _held ? color : backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(
              color: widget.borderColor ?? color,
              width: widget.borderWidth ?? 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }
}
