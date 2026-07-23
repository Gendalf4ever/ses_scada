import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final double min;
  final double max;
  final double step;
  final double labelPeriod;
  final ValueChanged<double> onChanged;
  final Color color;
  final double width;
  final double height;
  final bool isBlocked;

  const CustomSlider({
    super.key,
    required this.min,
    required this.max,
    this.step = 1,
    this.labelPeriod = 1,
    required this.onChanged,
    this.color = Colors.blue,
    this.width = 280,
    this.height = 40,
    this.isBlocked = false,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _value;

  Color get _bright => HSLColor.fromColor(widget.color)
      .withLightness(
        (HSLColor.fromColor(widget.color).lightness + 0.3).clamp(0.0, 1.0),
      )
      .toColor();

  double get _fraction =>
      ((_value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _value = widget.min;
  }

  void _onDrag(double localX, double inset, double innerWidth) {
    if (widget.isBlocked) return;
    final fraction = ((localX - inset) / innerWidth).clamp(0.0, 1.0);
    final raw = widget.min + fraction * (widget.max - widget.min);
    final stepped = (raw / widget.step).round() * widget.step;
    final clamped = stepped.clamp(widget.min, widget.max);
    if (clamped != _value) {
      setState(() => _value = clamped);
      widget.onChanged(_value);
    }
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final knobSize = widget.height * 0.8;
    final fontSize = widget.height * 0.34;
    final inset = knobSize / 2;

    return Opacity(
      opacity: widget.isBlocked ? 0.4 : 1.0,
      child: SizedBox(
        width: widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.height + fontSize + 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final innerWidth = totalWidth - inset * 2;
                  final knobLeft = inset + _fraction * innerWidth;
                  final trackTop = fontSize + 4 + (widget.height - 2) / 2;
                  final knobTop = trackTop - knobSize / 2;

                  return GestureDetector(
                    onHorizontalDragUpdate: (d) =>
                        _onDrag(d.localPosition.dx, inset, innerWidth),
                    onTapDown: (d) =>
                        _onDrag(d.localPosition.dx, inset, innerWidth),
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      children: [
                        // Value above knob
                        Positioned(
                          top: 0,
                          left: knobLeft,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, 0),
                            child: Text(
                              _fmt(_value),
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Track background
                        Positioned(
                          top: trackTop,
                          left: inset,
                          right: inset,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: _bright.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        // Track fill
                        Positioned(
                          top: trackTop,
                          left: inset,
                          child: Container(
                            width: _fraction * innerWidth,
                            height: 2,
                            decoration: BoxDecoration(
                              color: _bright,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        // Knob
                        Positioned(
                          top: knobTop,
                          left: knobLeft,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, 0),
                            child: Container(
                              width: knobSize,
                              height: knobSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.color,
                                border: Border.all(color: _bright, width: 1.5),
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
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // Period labels
            SizedBox(
              height: fontSize + 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final innerWidth = totalWidth - inset * 2;
                  final steps =
                      ((widget.max - widget.min) / widget.labelPeriod).round();
                  return Stack(
                    children: List.generate(steps + 1, (i) {
                      final v = widget.min + i * widget.labelPeriod;
                      final frac =
                          (v - widget.min) / (widget.max - widget.min);
                      return Positioned(
                        left: inset + frac * innerWidth,
                        child: FractionalTranslation(
                          translation: Offset(
                            frac == 0 ? 0 : frac == 1 ? -1 : -0.5,
                            0,
                          ),
                          child: Text(
                            _fmt(v),
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}