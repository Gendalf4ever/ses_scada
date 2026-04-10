import 'package:flutter/material.dart';
import 'package:ses_scada/models/saved_scheme_model.dart';
import 'package:ses_scada/scheme_creating_page.dart';
import 'package:ses_scada/state_manager/scheme_storage.dart';

class SchemesListPage extends StatefulWidget {
  const SchemesListPage({super.key});

  @override
  State<SchemesListPage> createState() => _SchemesListPageState();
}

class _SchemesListPageState extends State<SchemesListPage> {
  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  Future<void> _loadSchemes() async {
    await SchemeStorage().load();
    setState(() {});
  }

  Future<void> _deleteScheme(SavedSchemeModel scheme) async {
    await SchemeStorage().deleteScheme(scheme);
    setState(() {});
  }

  @override
Widget build(BuildContext context) {
  final schemes = SchemeStorage().schemes;

  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: const Center(
        child: Text(
        textAlign: TextAlign.center,
        'Схемы СЭС',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      ),
      backgroundColor: const Color(0xFF1E2A30),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadSchemes,
        ),
      ],
    ),
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
                _loadSchemes();
              }
            },
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Создать новую схему'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4AA3DF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: schemes.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.draw, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Нет сохранённых схем',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Нажмите "Создать новую схему" чтобы начать',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
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
                          _loadSchemes();
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
}
}

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
      color: const Color(0xFF2A3A40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF4AA3DF), width: 1),
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
                  const Icon(Icons.draw, color: Color(0xFF4AA3DF), size: 28),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                scheme.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Элементов: ${scheme.elements.length}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Создана: ${_formatDate(scheme.createdAt)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
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