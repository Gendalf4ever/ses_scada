import 'package:flutter/material.dart';
import '../enums/scheme_element_type.dart';

class SchemeElement {
  final SchemeElementType type;
  Offset position;
  double length;
  bool isVertical;
  List<String> boundSensors;

  SchemeElement({
    required this.type,
    required this.position,
    this.length = 80.0,
    this.isVertical = false,
    List<String>? boundSensors,
  }) : boundSensors = boundSensors ?? [];

  SchemeElement copy() {
    return SchemeElement(
      type: type,
      position: Offset(position.dx, position.dy),
      length: length,
      isVertical: isVertical,
      boundSensors: List<String>.from(boundSensors),
    );
  }

  // Сериализация в JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.index, 
      'position': {'dx': position.dx, 'dy': position.dy},
      'length': length,
      'isVertical': isVertical,
      'boundSensors': boundSensors,
    };
  }

  // Восстановление из JSON
factory SchemeElement.fromJson(Map<String, dynamic> json) {
  final positionJson = json['position'];

  final dx = positionJson is Map && positionJson['dx'] is num
      ? (positionJson['dx'] as num).toDouble()
      : 0.0;

  final dy = positionJson is Map && positionJson['dy'] is num
      ? (positionJson['dy'] as num).toDouble()
      : 0.0;

  final typeValue = json['type'];
  final typeIndex = typeValue is int
      ? typeValue
      : int.tryParse(typeValue?.toString() ?? '') ?? 0;

  return SchemeElement(
    type: SchemeElementType.values[
        typeIndex.clamp(0, SchemeElementType.values.length - 1)],
    position: Offset(dx, dy),
    length: (json['length'] as num?)?.toDouble() ?? 80.0,
    isVertical: json['isVertical'] as bool? ?? false,
    boundSensors: List<String>.from(json['boundSensors'] ?? const []),
  );
}

}
