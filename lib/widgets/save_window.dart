import 'package:flutter/material.dart';
import 'package:ses_scada/widgets/customButton.dart';


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
      backgroundColor: const Color.fromARGB(255, 48, 63, 70),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(
          color: Colors.blueAccent,
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
              const Center(
                child: Text(
                  'Сохранение',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: fileNameController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.blueAccent,
                decoration: InputDecoration(
                  hintText: 'Имя схемы',
                  hintStyle: const TextStyle(color: Colors.white54),
                  errorText: errorText,
                  filled: true,
                  fillColor: const Color.fromARGB(255, 48, 63, 70),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
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
