import 'package:flutter/material.dart';
import '../enums/scheme_element_type.dart';
import 'toolbox_items.dart';

class ToolboxPanel extends StatelessWidget {
  const ToolboxPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      color: const Color(0xFF1E2A30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          toolboxDraggable(
            SchemeElementType.pch,
            schemeBox('ПЧ'),
          ),
          const SizedBox(height:16),
          toolboxDraggable(
            SchemeElementType.shpchp, 
            schemeBox('ЩПЧП'),
            ),
          const SizedBox(height: 16),
          toolboxDraggable(
            SchemeElementType.automation,
            schemeBox('Автомат'),
          ),
          const SizedBox(height: 16),
          toolboxDraggable(
            SchemeElementType.edrk,
            schemeCircle('ЭДРК'),
          ),
          const SizedBox(height: 16),
          toolboxDraggable(
            SchemeElementType.gdg,
            schemeCircle('ГДГ'),
          ),
          const SizedBox(height: 16),
          toolboxDraggable(
            SchemeElementType.sdg,
            schemeCircle('СДГ'),
          ),
          const SizedBox(height: 16),
          toolboxDraggable(
            SchemeElementType.transformer,
            schemeTallRect('T'),
          ),
          const SizedBox(height: 16),
          // Горизонтальная линия
          toolboxDraggable(
            SchemeElementType.line,
            schemeLine(50),
            isVertical: false,
          ),
          const SizedBox(height: 8),
          // Вертикальная линия
          toolboxDraggable(
            SchemeElementType.line,
            schemeLine(50, isVertical: true),
            isVertical: true,
          ),
        ],
      ),
    );
  }
}
