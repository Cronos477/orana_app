import 'package:intl/intl.dart';
import 'package:orana/main/screens/menu_editing_screens/navigation_screens/attributes.dart';
import 'package:orana/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MenuEditingScreen extends StatefulWidget {
  const MenuEditingScreen({super.key, required this.menuItems, this.index});
  final int? index;
  final List menuItems;

  @override
  State<MenuEditingScreen> createState() => _MenuEditingScreenState();
}

class _MenuEditingScreenState extends State<MenuEditingScreen> {
  int selectedIndex = 0;

  String calculatedPriceText = '0,00';

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool editing = widget.index != null;
    final Map menuItem = editing ? widget.menuItems[widget.index!] : {};

    String realPriceText = '0,00';

    if (editing) {
      num price = int.parse(menuItem['price'].toString());
      price /= 100;
      final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
      realPriceText = formatter.format(price).trim();
    } else {
        final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
        realPriceText = formatter.format(0.00).trim();
    }

    final TextEditingController nameTextEditingController = TextEditingController(
      text: editing
        ? menuItem['name']
        : ''
    );
    final TextEditingController unitTextEditingController = TextEditingController(
      text: editing
        ? menuItem['unit']
        : '0'
    );
    final TextEditingController realPriceTextEditingController = TextEditingController(
      text: realPriceText,
    );
    final TextEditingController calculatePriceTextEditingController = TextEditingController(
      text: calculatedPriceText
    );
    final TextEditingController descriptionTextEditingController = TextEditingController(
      text: editing 
        ? menuItem['description']
        : ''
    );

    List<Widget> screens = [
      Attributes(
        nameTextEditingController: nameTextEditingController,
        unitTextEditingController: unitTextEditingController,
        realPriceTextEditingController: realPriceTextEditingController,
        calculatePriceTextEditingController: calculatePriceTextEditingController,
        descriptionTextEditingController: descriptionTextEditingController,
      ),
      Placeholder(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.icons),
        ),
        title: Text(
          editing ? "Edidar ${menuItem['name']}" : "Criar Item",
          style: TextStyle(color: AppColors.icons),
        ),
      ),
      body: Center(child: screens.elementAt(selectedIndex)),
      bottomNavigationBar: NavigationBar(
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(
              Icons.edit_attributes_outlined,
              color: AppColors.secondaryText,
            ),
            selectedIcon: Icon(Icons.edit_attributes, color: AppColors.icons),
            label: "Atributos",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_basket_outlined,
              color: AppColors.secondaryText,
            ),
            selectedIcon: Icon(Icons.shopping_basket, color: AppColors.icons),
            label: "Ingredientes",
          ),
        ],
        labelTextStyle: WidgetStateProperty<TextStyle>.fromMap({
          WidgetState.selected: TextStyle(color: AppColors.text),
          WidgetState.any: TextStyle(color: AppColors.secondaryText),
        }),
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        backgroundColor: AppColors.primary,
        indicatorColor: AppColors.secondary,
        elevation: 10,
      ),
    );
  }
}
