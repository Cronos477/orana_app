import 'package:flutter/material.dart';
import 'package:orana/main/screens/navigation_screens/fixed_costs.dart';
import 'package:orana/main/screens/navigation_screens/ingredients.dart';
import 'package:orana/main/screens/navigation_screens/menu.dart';
import 'package:orana/utils/app_colors.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgets = [
    MenuScreen(),
    Ingredients(),
    FixedCosts()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Orana",
          style: TextStyle(
            color: AppColors.icons,
          ),
        ),
      ),
      body: Center(
        child: _widgets.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(
              Icons.restaurant_menu,
              color: AppColors.secondaryText,
            ),
            selectedIcon: Icon(
              Icons.restaurant_menu,
              color: AppColors.icons,
            ),
            label: "Cardápio",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_basket_outlined,
              color: AppColors.secondaryText,
            ),
            selectedIcon: Icon(
              Icons.shopping_basket,
              color: AppColors.icons,
            ),
            label: "Ingredientes"
          ),
          NavigationDestination(
              icon: Icon(
                Icons.attach_money,
                color: AppColors.secondaryText,
              ),
              selectedIcon: Icon(
                Icons.attach_money,
                color: AppColors.icons,
              ),
              label: "Custos Fixos"
          ),
        ],
        labelTextStyle: WidgetStateProperty<TextStyle>.fromMap(
          {
            WidgetState.selected: TextStyle(
              color: AppColors.text
            ),
            WidgetState.any: TextStyle(
                color: AppColors.secondaryText
            ),
          }
        ),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: AppColors.primary,
        indicatorColor: AppColors.secondary,
        elevation: 10,
      ),
    );
  }
}
