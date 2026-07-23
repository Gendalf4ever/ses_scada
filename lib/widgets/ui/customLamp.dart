import 'package:flutter/material.dart';

class CustomLamp extends StatefulWidget {
  final bool isOn;
  final Color color1;
  final Color color2;
  final double size;

  const CustomLamp({
    super.key,
    required this.isOn,
    this.color1 = Colors.green,
    this.color2 = Colors.red,
    this.size = 30,
  });

  @override
  State<CustomLamp> createState() => _LampWidgetState();
}

class _LampWidgetState extends State<CustomLamp> {
  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.isOn ? widget.color1 : widget.color2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activeColor,
        border: Border.all(color: Colors.white, width: widget.size * 0.03),
        // Inner gradient for a glass/bulb effect
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.85,
          colors: [
            Color.lerp(activeColor, Colors.white, 0.55)!,
            activeColor,
            Color.lerp(activeColor, Colors.black, 0.35)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        // Glow effect
        /*boxShadow: [
          BoxShadow(
            color: activeColor.withValues(alpha: 0.6),
            blurRadius: size * 0.4,
            spreadRadius: size * 0.05,
          ),
          BoxShadow(
            color: activeColor.withValues(alpha: 0.2),
            blurRadius: size * 0.8,
            spreadRadius: size * 0.1,
          ),
        ],*/
      ),
    );
  }
}
