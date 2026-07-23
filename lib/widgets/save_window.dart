import 'package:flutter/material.dart';
import 'package:ses_scada/widgets/ui/customButton.dart';

import 'components/colorManager.dart';


class SaveWindow extends StatefulWidget {
  const SaveWindow({super.key});

  @override
  State<SaveWindow> createState() => _SaveWindowState();
}

class _SaveWindowState extends State<SaveWindow> {
  final fileNameController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:ColorManager.primaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side:  BorderSide(
          color: ColorManager.primary,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Center(
                child: Text(
                  'Сохранение',
                  style: TextStyle(
                    color: ColorManager.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: fileNameController,
                style:  TextStyle(color: ColorManager.text),
                cursorColor: ColorManager.primary,
                decoration: InputDecoration(
                  hintText: 'Имя схемы',
                  hintStyle:  TextStyle(color: ColorManager.text),
                  errorText: errorText,
                  filled: true,
                  fillColor:  ColorManager.primaryBackground,
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: ColorManager.primary,
                      width: 2,
                    ),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color:ColorManager.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                    label: 'Отмена',
                    onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:  CustomButton(
                    label: 'Сохранить',
                    onPressed: onSavePressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
    //void on save pressed
  void onSavePressed() {
    final name = fileNameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorText = 'Введите имя схемы';
      });
      return;
    }

    Navigator.pop(context, name);
  }
}
