import 'package:flutter/material.dart';
import 'package:ses_scada/widgets/customLamp.dart';
import 'package:ses_scada/widgets/toolbox_items.dart';
import '../models/scheme_element.dart';
import '../enums/scheme_element_type.dart';

class PlacedElement extends StatefulWidget {
  final SchemeElement element;
  final VoidCallback onUpdate;

  const PlacedElement({
    super.key,
    required this.element,
    required this.onUpdate,
  });

  @override
  State<PlacedElement> createState() => _PlacedElementState();
}

class _PlacedElementState extends State<PlacedElement> {
  Offset? _startMouse;
  Offset? _startPosition;
  double? _startLength;

  @override
  Widget build(BuildContext context) {
    final e = widget.element;

    return Positioned(
      left: e.position.dx,
      top: e.position.dy,
      child: GestureDetector(
        onDoubleTap: () {
          // TODO: Implement sensor binding dialog if needed
          // For now, just show a placeholder
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Привязка датчиков в разработке')),
          );
        },
        onPanStart: (details) {
          _startMouse = details.globalPosition;
          _startPosition = e.position;
        },
        onPanUpdate: (details) {
          final dx = details.globalPosition.dx - _startMouse!.dx;
          final dy = details.globalPosition.dy - _startMouse!.dy;
          setState(() {
            e.position = Offset(_startPosition!.dx + dx, _startPosition!.dy + dy);
          });
          widget.onUpdate();
        },
        child: _buildVisual(),
      ),
    );
  }

  Widget _buildVisual() {
    switch (widget.element.type) {
      case SchemeElementType.gdg:
        return _buildWithSensors(schemeCircle('ГДГ'));
      case SchemeElementType.shpchp:
        return _buildWithSensors(schemeBox('ЩПЧП'));
      case SchemeElementType.edrk:
        return _buildWithSensors(schemeCircle('ЭДРК'));
      case SchemeElementType.sdg:
        return _buildWithSensors(schemeCircle('СДГ'));
      case SchemeElementType.transformer:
        return _buildWithSensors(schemeTallRect('T'));
      case SchemeElementType.automation:
        return _buildWithSensors(schemeBox('Q'));
      case SchemeElementType.lamp:
        return CustomLamp(isOn: true);  
      case SchemeElementType.pch:
        return _buildWithSensors(schemeBox('ПЧ'));
      case SchemeElementType.line:
        return _buildResizableLine();
    }
  }

  Widget _buildWithSensors(Widget child) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (widget.element.boundSensors.isNotEmpty)
          const Icon(
            Icons.sensors,
            size: 14,
            color: Colors.white,
          ),
      ],
    );
  }

  Widget _buildResizableLine() {
    final e = widget.element;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        schemeLine(e.length, isVertical: e.isVertical),

        Positioned(
          left: e.isVertical ? 0 : e.length - 15,
          top: e.isVertical ? e.length - 15 : 0,
          child: MouseRegion(
            cursor: e.isVertical
                ? SystemMouseCursors.resizeUpDown
                : SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              onPanStart: (details) {
                _startMouse = details.globalPosition;
                _startLength = e.length;
              },
              onPanUpdate: (details) {
                final delta = e.isVertical
                    ? details.globalPosition.dy - _startMouse!.dy
                    : details.globalPosition.dx - _startMouse!.dx;
                setState(() {
                  e.length = (_startLength! + delta).clamp(20.0, 600.0);
                });
                widget.onUpdate();
              },
              child: Container(
                width: e.isVertical ? 30 : 30, 
                height: e.isVertical ? 30 : 30, 
                color: Colors.transparent,       
              ),
            ),
          ),
        ),
      ],
    );
  }
}