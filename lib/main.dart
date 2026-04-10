import 'package:flutter/material.dart';
import 'package:ses_scada/state_manager/scheme_storage.dart';
import 'package:ses_scada/widgets/schemes_list_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SchemeStorage().load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SES SCADA Scheme Editor',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SchemesListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}