import 'package:flutter/material.dart';
import '../models/scheme_element.dart';
//import '../enums/scheme_element_type.dart';
import 'placed_element.dart';
import 'toolbox_items.dart';

class CanvasWidget extends StatelessWidget {
  final List<SchemeElement> elements;
  final Function(SchemeElement) onAddElement;
  final VoidCallback onUpdate;

  const CanvasWidget({
    super.key,
    required this.elements,
    required this.onAddElement,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<ToolboxData>(
        onAcceptWithDetails: (details) {
          final box = context.findRenderObject() as RenderBox;
          final localPos = box.globalToLocal(details.offset);

          final data = details.data;

          final element = SchemeElement(
            type: data.type,
            position: localPos,
            isVertical: data.isVertical,
          );

          onAddElement(element);
        },
        builder: (_, __, ___) {
          return Container(
            color: Colors.black,
            child: Stack(
              children: elements
                  .map((e) => PlacedElement(
                        element: e,
                        onUpdate: onUpdate,
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
