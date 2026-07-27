import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ses_scada/models/saved_scheme_model.dart';
import 'package:ses_scada/scheme_creating_page.dart';
import 'package:ses_scada/state_manager/scheme_storage.dart';
import 'components/colorManager.dart';

class SchemesListPage extends StatefulWidget {
  const SchemesListPage({super.key});

  @override
  State<SchemesListPage> createState() => SchemesListPageState();
}

class SchemesListPageState extends State<SchemesListPage> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSchemes();
    });
  }

  @override
  void dispose(){
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyR || 
          event.logicalKey == LogicalKeyboardKey.keyK) {
        loadSchemes();
        return true; // Событие обработано
      }
    }
    return false; // Событие не обработано
  }

  Future<void> loadSchemes() async {
    if (!mounted) return;
    
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Загрузка схем..."),
          duration: Duration(milliseconds: 800),
        ),
      );
    } catch (_) {}

    await SchemeStorage().load();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _deleteScheme(SavedSchemeModel scheme) async {
    await SchemeStorage().deleteScheme(scheme);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final schemes = SchemeStorage().schemes;

    return AnimatedBuilder(
      animation: ColorManager.themeChanges,
      builder: (context, _){
         return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SchemeCreatingPage(),
                  ),
                );
                if (result == true) {
                  loadSchemes();
                }
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Создать новую схему'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryBackground,
                foregroundColor: ColorManager.text,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: schemes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.draw, size: 64, color: ColorManager.text),
                        SizedBox(height: 16),
                        Text(
                          'Нет сохранённых схем',
                          style: TextStyle(color: ColorManager.text, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Нажмите "Создать новую схему" чтобы начать',
                          style: TextStyle(color: ColorManager.text, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: schemes.length,
                    itemBuilder: (context, index) {
                      final scheme = schemes[index];
                      return _SchemeCard(
                        scheme: scheme,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SchemeCreatingPage(scheme: scheme),
                            ),
                          );
                          if (result == true) {
                            loadSchemes();
                          }
                        },
                        onDelete: () => _deleteScheme(scheme),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
      },
    );
  }
}

// тест для сохранения схем
class _SchemeCard extends StatelessWidget {
  final SavedSchemeModel scheme;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SchemeCard({
    required this.scheme,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.primaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:  BorderSide(color: ColorManager.primary, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Icon(Icons.draw, color: ColorManager.primary, size: 28),
                  IconButton(
                    icon:  Icon(Icons.delete_outline, color: ColorManager.delete, size: 20),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                scheme.name,
                style:  TextStyle(
                  color: ColorManager.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Элементов: ${scheme.elements.length}',
                style:  TextStyle(color: ColorManager.text, fontSize: 12),
              ),
              Text(
                'Создана: ${_formatDate(scheme.createdAt)}',
                style:  TextStyle(color: ColorManager.text, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}