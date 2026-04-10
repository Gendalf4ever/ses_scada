import 'package:flutter/material.dart';
import 'package:ses_scada/widgets/customButton.dart';
import '../models/scheme_element.dart';
import '../models/saved_scheme_model.dart';
import '../state_manager/scheme_storage.dart';

import '../widgets/canvas_widget.dart';
import '../widgets/save_window.dart';
import '../widgets/toolbox_panel.dart';

class SchemeCreatingPage extends StatefulWidget {
  final SavedSchemeModel? scheme;

  const SchemeCreatingPage({
    super.key,
    this.scheme,
  });

  @override
  State<SchemeCreatingPage> createState() => _SchemeCreatingPageState();
}

class _SchemeCreatingPageState extends State<SchemeCreatingPage> {
  late List<SchemeElement> elements;

  @override
  void initState() {
    super.initState();

    //копирование элементов при открытии сохраненной схемы
    elements = widget.scheme != null
        ? widget.scheme!.elements.map((e) => e.copy()).toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  CanvasWidget(
                    elements: elements,
                    onAddElement: (element) {
                      setState(() {
                        elements.add(element);
                      });
                    },
                    onUpdate: () => setState(() {}),
                  ),
                  const ToolboxPanel(),
                ],
              ),
            ),

            // ses button
            Positioned(
              bottom: 100,
              right: 140,
              child: CustomButton(
                label: 'Сохранить',
                onPressed: () async {
                  final schemeName = await showDialog<String>(
                    context: context,
                    builder: (_) => const SaveWindow(),
                  );

                  if (schemeName == null || schemeName.trim().isEmpty) return;

                  SchemeStorage().addScheme(
                    SavedSchemeModel(
                      name: schemeName.trim(),
                      createdAt: DateTime.now(),
                      elements: List.from(elements),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: 20,
              left: 20,
              child: CustomButton(
                label: '<-',
                width: 50,
                height: 50,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.scheme?.name ?? 'Создание новой схемы',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
