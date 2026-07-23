import 'package:flutter/material.dart';
import 'package:ses_scada/widgets/ui/customDropdownMenu.dart';
import 'package:ses_scada/widgets/ui/customLamp.dart';
import 'package:ses_scada/widgets/ui/customPopupPage.dart';
import 'package:ses_scada/widgets/ui/customButton.dart';
import '../models/scheme_element.dart';
import '../enums/scheme_element_type.dart';
import 'components/colorManager.dart';
import 'toolbox_items.dart';

class PlacedElement extends StatefulWidget {
  final SchemeElement element;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const PlacedElement({
    super.key,
    required this.element,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<PlacedElement> createState() => _PlacedElementState();
}

class _PlacedElementState extends State<PlacedElement> {
  Offset? _startMouse;
  Offset? _startPosition;
  double? _startLength;
  bool _isHovered = false;
    //for popup
  void _showSensorsConfigDialog(){
    showDialog(
      context: context, 
      builder: (_) => CustomPopupPage(
        title: 'Привязка датчиков',
        showCloseButton: true,
        borderColor: ColorManager.primary, 
        widgetStack: [
          Text(
            'Элемент: ${widget.element.type.name}',
            style: TextStyle(color: ColorManager.text, fontSize: 16),
          ),
          const SizedBox(height: 20),
          CustomDropdown(items: []),
          const SizedBox(height: 20),
          CustomButton(
            label: 'Закрыть',
            onPressed: (){
              Navigator.of(context).pop();
              widget.onUpdate();
            }
            ),
        ]
        )
      );
  }
  void _showContextMenu() {
    final isLine = widget.element.type == SchemeElementType.line;
    
    List<Widget> menuItems = [
      CustomButton(
        label: 'Удалить',
        color: ColorManager.delete,
        width: 180,
        height: 40,
        onPressed: () {
          Navigator.of(context).pop();
          widget.onDelete();
        },
      ),
      const SizedBox(height: 12),
    ];

    if (isLine) {
      menuItems.insert(0, Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            label: widget.element.isVertical ? 'Сделать горизонтальной' : 'Сделать вертикальной',
            color: ColorManager.primary,
            width: 180,
            height: 40,
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                widget.element.isVertical = !widget.element.isVertical;
                widget.onUpdate();
              });
            },
          ),
          const SizedBox(height: 12),
        ],
      ));
    }

    showDialog(
      context: context,
      builder: (_) => CustomPopupPage(
        title: 'Удаление элемента',
        showCloseButton: true,
        borderColor: ColorManager.primary,
        widgetStack: menuItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.element;

    return Positioned(
      left: e.position.dx,
      top: e.position.dy,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onSecondaryTap: _showContextMenu,
          onDoubleTap: _showSensorsConfigDialog, 
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
          child: Stack(
            children: [
              _buildVisual(),
              if (_isHovered)
                Positioned(
                  top: -12,
                  right: -12,
                  child: GestureDetector(
                    onTap: _showContextMenu,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorManager.delete,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child:  Icon(
                        Icons.more_vert,
                        size: 16,
                        color: ColorManager.text,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
      case SchemeElementType.grshbackground:
        return _buildBackground();

    }
  }

  Widget _buildWithSensors(Widget child) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (widget.element.boundSensors.isNotEmpty)
           Icon(
            Icons.sensors,
            size: 14,
            color: ColorManager.text,
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
  Widget _buildBackground(){
  // final e = widget.element;
   return Container(
      padding: EdgeInsets.all(5 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorManager.primaryBackground
              ),
            margin: EdgeInsets.all(5),
            height: 200, 
            width: 1750,
   );
  }
}
