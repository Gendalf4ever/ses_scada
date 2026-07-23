import 'package:flutter/material.dart';

class CustomProgressBar extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double currentValue;
  final String title;
  final String units;
  final Color progressColor;
  final double? minColorChangeValue;
  final double? maxColorChangeValue;
  final Color? onvalColorChangeColor;
  final bool showBorderAndBackground;
  final double width;
  final double height;

  const CustomProgressBar({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.title,
    required this.units,
    this.progressColor = Colors.blue,
    this.minColorChangeValue,
    this.maxColorChangeValue,
    this.onvalColorChangeColor,
    this.showBorderAndBackground = true,
    this.width = 280,
    this.height = 65,
  });

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  @override
  Widget build(BuildContext context) {
    final padding = widget.height * 0.09;
    final fontSize = widget.height * 0.22;
    final barHeight = widget.height * 0.3;

    Color currentProgressColor = widget.progressColor;
    if ((widget.minColorChangeValue != null &&
            widget.currentValue < widget.minColorChangeValue!) ||
        (widget.maxColorChangeValue != null &&
            widget.currentValue > widget.maxColorChangeValue!)) {
      currentProgressColor =
          widget.onvalColorChangeColor ?? widget.progressColor;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: widget.showBorderAndBackground
            ? Color.fromARGB(255, 48, 63, 70)
            : Colors.transparent,
        border: Border.all(
          color: widget.showBorderAndBackground
              ? Colors.blue
              : Colors.transparent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(widget.height * 0.12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              Text(
                '${widget.currentValue.toStringAsFixed(1)} ${widget.units}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(barHeight / 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(barHeight / 2),
              child: LinearProgressIndicator(
                value:
                    (widget.currentValue - widget.minValue) /
                    (widget.maxValue - widget.minValue),
                backgroundColor: widget.showBorderAndBackground
                    ? Color.fromARGB(255, 48, 63, 70)
                    : Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(currentProgressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomProgressDashboard extends StatefulWidget {
  final String mainTitle;
  final List<CustomProgressBar> progressBars;
  final Color color;

  const CustomProgressDashboard({
    super.key,
    required this.mainTitle,
    required this.progressBars,
    this.color = Colors.blue,
  });

  @override
  State<CustomProgressDashboard> createState() =>
      _CustomProgressDashboardState();
}

class _CustomProgressDashboardState extends State<CustomProgressDashboard> {
  Color _darken(Color c) => HSLColor.fromColor(c)
      .withLightness((HSLColor.fromColor(c).lightness - 0.5).clamp(0.0, 1.0))
      .toColor();

  @override
  Widget build(BuildContext context) {
    const padding = 10.0;
    final barHeight = widget.progressBars.isNotEmpty
        ? widget.progressBars
              .map((b) => b.height)
              .reduce((a, b) => a > b ? a : b)
        : 65.0;
    final barWidth = widget.progressBars.isNotEmpty
        ? widget.progressBars
              .map((b) => b.width)
              .reduce((a, b) => a > b ? a : b)
        : 280.0;

    return Container(
      width: barWidth + padding * 2,
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: _darken(widget.color),
        border: Border.all(color: widget.color, width: 2.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mainTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: barHeight * 0.27,
            ),
          ),
          ...widget.progressBars.map(
            (progressBar) => Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: progressBar,
            ),
          ),
        ],
      ),
    );
  }
}
