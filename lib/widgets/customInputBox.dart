import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _NumericFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (!RegExp(r'^-?[0-9]+\.?[0-9]*$').hasMatch(text) && text != '-') {
      return oldValue;
    }
    return newValue;
  }
}

class CustomInputBox extends StatefulWidget {
  final double width;
  final double height;
  final bool isNumeric;
  final ValueChanged<String> onChanged;
  final Color color;
  final String prompt;
  final bool isBlocked;

  const CustomInputBox({
    super.key,
    this.width = 200,
    this.height = 40,
    this.isNumeric = false,
    required this.onChanged,
    this.color = Colors.blue,
    this.prompt = '',
    this.isBlocked = false,
  });

  @override
  State<CustomInputBox> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInputBox> {
  final _controller = TextEditingController();

  Color _darken(Color c) => HSLColor.fromColor(c)
      .withLightness((HSLColor.fromColor(c).lightness - 0.5).clamp(0.0, 1.0))
      .toColor();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.height * 0.34;

    return Opacity(
      opacity: widget.isBlocked ? 0.4 : 1.0,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _darken(widget.color),
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: widget.color, width: 1.5),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: _controller,
          onChanged: widget.isBlocked ? null : widget.onChanged,
          enabled: !widget.isBlocked,
          keyboardType: widget.isNumeric
              ? const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                )
              : TextInputType.text,
          inputFormatters: widget.isNumeric ? [_NumericFormatter()] : null,
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
          decoration: InputDecoration(
            hintText: widget.prompt,
            hintStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: widget.color.withValues(alpha: 0.6),
              height: 1,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.height * 0.4,
            ),
            isCollapsed: true,
          ),
          cursorColor: widget.color,
          cursorHeight: fontSize * 1.2,
        ),
      ),
    );
  }
}
