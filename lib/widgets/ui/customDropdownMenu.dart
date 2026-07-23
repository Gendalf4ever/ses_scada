import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final int? selectedIndex;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<int?>? onIndexChanged;
  final List<T> excludeKeys;
  final List<T> disabledKeys;
  final Color? color;
  final Color? backgroundColor;
  final double width;
  final double height;
  final bool isBlocked;

  const CustomDropdown({
    super.key,
    required this.items,
    this.value,
    this.selectedIndex,
    this.onChanged,
    this.onIndexChanged,
    this.excludeKeys = const [],
    this.disabledKeys = const [],
    this.color,
    this.backgroundColor,
    this.width = 160,
    this.height = 40,
    this.isBlocked = false,
  }) : assert(
         (value != null) != (selectedIndex != null) ||
             (value == null && selectedIndex == null),
         'Provide either value or selectedIndex, not both.',
       );

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _held = false;

  List<DropdownMenuItem<T>> get _resolvedItems {
    return widget.items
        .where((item) => !widget.excludeKeys.contains(item.value))
        .map((item) {
          final isDisabled = widget.disabledKeys.contains(item.value);
          if (!isDisabled) return item;
          return DropdownMenuItem<T>(
            value: item.value,
            enabled: false,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: widget.height * 0.5,
                fontWeight: FontWeight.w600,
                color: ColorManager.primaryLight,
                letterSpacing: 0.1,
              ),
              child: item.child,
            ),
          );
        })
        .toList();
  }

  T? get _resolvedValue {
    T? val;
    if (widget.selectedIndex != null) {
      val = widget.items[widget.selectedIndex!].value;
    } else {
      val = widget.value;
    }

    // if current value is excluded, return null so dropdown shows nothing selected
    if (val != null && widget.excludeKeys.contains(val)) return null;
    return val;
  }

  void _handleChanged(T? newValue) {
    if (widget.onChanged != null) {
      widget.onChanged!(newValue);
    }
    if (widget.onIndexChanged != null) {
      final index = widget.items.indexWhere((item) => item.value == newValue);
      widget.onIndexChanged!(index == -1 ? null : index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ColorManager.primary;
    final backgroundColor =
        widget.backgroundColor ?? ColorManager.widgetBackground;

    return Opacity(
      opacity: widget.isBlocked ? 0.4 : 1.0,
      child: GestureDetector(
        onTapDown: widget.isBlocked
            ? null
            : (_) => setState(() => _held = true),
        onTapUp: widget.isBlocked ? null : (_) => setState(() => _held = false),
        onTapCancel: widget.isBlocked
            ? null
            : () => setState(() => _held = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _held ? color : backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(color: color, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.height * 0.3),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                /*value: _resolvedValue,
                items: widget.items,*/
                value: _resolvedValue,
                items: _resolvedItems,
                onChanged: widget.isBlocked ? null : _handleChanged,
                isDense: true,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: color,
                  size: widget.height * 0.55,
                ),
                style: TextStyle(
                  fontSize: widget.height * 0.5,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.text,
                  letterSpacing: 0.1,
                ),
                dropdownColor: backgroundColor,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
