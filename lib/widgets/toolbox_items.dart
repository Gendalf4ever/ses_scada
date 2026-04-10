import 'package:flutter/material.dart';
import '../enums/scheme_element_type.dart';

class ToolboxData {
  final SchemeElementType type;
  final bool isVertical;
  ToolboxData({required this.type, this.isVertical = false});
}

Widget toolboxDraggable(SchemeElementType type, Widget child, {bool isVertical = false}) {
  return Draggable<ToolboxData>(
    data: ToolboxData(type: type, isVertical: isVertical),
    feedback: Opacity(
      opacity: 0.7,
      child: child,
    ),
    childWhenDragging: Opacity(
      opacity: 0.3,
      child: child,
    ),
    child: child,
  );
}

Widget schemeBox(String text) => Container(
      width: 70,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF5C6E75),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
    
Widget schemeCircle(String text) => Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF5C6E75),
        shape: BoxShape.circle,
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );

Widget schemeTallRect(String text) => Container(
      width: 30,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF5C6E75),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );

Widget schemeLine(double length, {bool isVertical = false}) => Container(
      width: isVertical ? 3 : length,
      height: isVertical ? length : 3, 
      color: const Color(0xFF4AA3DF),
    );

Widget resizeHandle() => Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent),
      ),
    );
