import 'package:flutter/material.dart';
import 'widgets/components/colorManager.dart';
import 'widgets/ui/customButton.dart';
//import 'schemes_list_page.dart'; 
// import 'dashboard_page.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainLayout> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onTabTapped(int index){
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
      builder: (context, _){
        final isDark = ColorManager.activeTheme == AppThemes.dark;

        return Scaffold(
          backgroundColor: ColorManager.primaryBackground,
          body: SafeArea(
            child: Column(
              children: [
                //main appbar
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
                      //page switch
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
                      //refresh and change theme
                      Row(
                        children: [
                          Tooltip(
                            message: "Обновить данные(клавиша R)",
                            child: SizedBox(
                              width: 38,
                              height: 38,
                              child: CustomButton(
                                icon: Icon(Icons.refresh, color: ColorManager.text),
                                onPressed: (){
                                  //refresh
                                }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
            ),
        );
      }
      );
  }
}