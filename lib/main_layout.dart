import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/components/colorManager.dart';
import 'widgets/schemes_list_page.dart';
import 'widgets/ui/customButton.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;


  final GlobalKey<SchemesListPageState> _schemesKey = GlobalKey<SchemesListPageState>();

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _pageController.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        _triggerRefresh();
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.keyT) {
        _toggleTheme();
        return true;
      }
    }
    return false;
  }


  void _triggerRefresh() {
    if (_currentIndex == 1) {
      _schemesKey.currentState?.loadSchemes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Обновление дашборда..."),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

void _toggleTheme() {
    final isDark = ColorManager.activeTheme == AppThemes.dark;
    final nextTheme = isDark ? AppThemes.light : AppThemes.dark;
    ColorManager.switchTheme(nextTheme);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ColorManager.themeChanges,
      builder: (context, _) {
        final isDark = ColorManager.activeTheme == AppThemes.dark;

        return Scaffold(
          backgroundColor: ColorManager.primaryBackground,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBackground,
                    border: Border(
                      bottom: BorderSide(color: ColorManager.primary, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // page switch
                      Row(
                        children: [
                          CustomButton(
                            label: 'Дашборд',
                            width: 120,
                            height: 40,
                            color: _currentIndex == 0 ? ColorManager.primary : Colors.transparent,
                            onPressed: () => _onTabTapped(0),
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            label: 'Схемы',
                            width: 120,
                            height: 40,
                            color: _currentIndex == 1 ? ColorManager.primary : Colors.transparent,
                            onPressed: () => _onTabTapped(1),
                          ),
                        ],
                      ),

                      // refresh and change theme button
                      Row(
                        children: [
                          Tooltip(
                            message: "Обновить данные (клавиша R)",
                            child: SizedBox(
                              width: 38,
                              height: 38,
                              child: CustomButton(
                                icon: Icon(Icons.refresh, color: ColorManager.text),
                                onPressed: _triggerRefresh,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Tooltip(
                            message: "Поменять тему приложения (клавиша T)",
                            child: SizedBox(
                              width: 38,
                              height: 38,
                              child: CustomButton(
                              // label: 'T',
                                icon: Icon(
                                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                                  color: ColorManager.text,
                                ),
                                onPressed: _toggleTheme,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: [
                       Center(
                        child: Text(
                          'Дашборд в разработке',
                          style: TextStyle(color: ColorManager.text, fontSize: 22),
                        ),
                      ),
                      SchemesListPage(key: _schemesKey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}