import 'package:flutter/material.dart';
import 'package:ses_scada/main_layout.dart';
import 'package:ses_scada/state_manager/scheme_storage.dart';
import 'package:ses_scada/widgets/components/colorManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SchemeStorage().load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorManagerProvider(
      child: AnimatedBuilder(
        animation: ColorManager.themeChanges,
        builder: (context, _) {
          return MaterialApp(
            title: 'SES SCADA Scheme Editor',
            theme: ThemeData(
              brightness: ColorManager.activeTheme == AppThemes.dark 
                  ? Brightness.dark 
                  : Brightness.light,
              primaryColor: ColorManager.primary,
              scaffoldBackgroundColor: ColorManager.primaryBackground,
            ),
            home: const MainLayout(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}