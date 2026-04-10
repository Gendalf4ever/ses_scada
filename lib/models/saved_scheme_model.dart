import 'package:flutter/services.dart';
import 'package:ses_scada/enums/scheme_element_type.dart';

import 'scheme_element.dart';

class SavedSchemeModel {
  final String name;
  final DateTime createdAt;
  final List<SchemeElement> elements;

  SavedSchemeModel({
    required this.name,
    required this.createdAt,
    required this.elements,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'elements': elements.map((e) => e.toJson()).toList(),
      };

  factory SavedSchemeModel.fromJson(Map<String, dynamic> json) {
    final elementsJson = json['elements'] as List<dynamic>? ?? [];

    final elementsList = elementsJson.map((e) {
      if (e is Map<String, dynamic>) {
        final typeValue = e['type'];
        if (typeValue is String) {
          e['type'] = int.tryParse(typeValue) ?? 0; 
        }
        return SchemeElement.fromJson(e);
      } else {
        return SchemeElement(
          type: SchemeElementType.values[0],
          position: const Offset(0, 0),
        );
      }
    }).toList();

    return SavedSchemeModel(
      name: json['name'] ?? 'Unnamed',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      elements: elementsList,
    );
  }
}
