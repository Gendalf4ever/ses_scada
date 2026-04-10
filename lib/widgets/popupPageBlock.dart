import 'package:flutter/material.dart';

class PopupPageBlock extends StatefulWidget {
  final String title;
  final Color color;
  final List<Widget> widgetStack;
  final double titleFontSize;

  const PopupPageBlock({
    super.key,
    required this.title,
    this.color = Colors.blue,
    required this.widgetStack,
    this.titleFontSize = 20,
  });

  @override
  State<PopupPageBlock> createState() => _PopupPageBlockState();
}

class _PopupPageBlockState extends State<PopupPageBlock> {
  Color _darken(Color c) => HSLColor.fromColor(c)
      .withLightness((HSLColor.fromColor(c).lightness - 0.45).clamp(0.0, 1.0))
      .toColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _darken(widget.color),
        //border: Border.all(color: widget.color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: widget.titleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.widgetStack,
          ),
        ],
      ),
    );
  }
}
