import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orana/main/screens/dialog_screens/delete_alert_dialog.dart';
import 'package:orana/main/widgets/custom_card.dart';
import 'package:orana/utils/app_colors.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({
    super.key,
    required this.ingredients,
    this.initialSelectedIngredients
  });
  final List ingredients;
  final List? initialSelectedIngredients;

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  @override
  Widget build(BuildContext context) {

    List selectedIngredients = [];
    if (widget.initialSelectedIngredients != null) {
      selectedIngredients.insertAll(0, widget.initialSelectedIngredients!);
    }



    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: AppColors.icons,
        ),
      ),
      body: ListView.builder(
        itemCount: selectedIngredients.length,
        itemBuilder: (context, index) {

          final double price = selectedIngredients[index]['price'] / 100;
          final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
          final String priceText = formatter.format(price);

          Future<void> onTapHandler() async {
            final bool? delete = await deleteAlertDialog(context);

            if (delete != null && delete) {
              setState(() {
                selectedIngredients.removeAt(index);
              });
            }
          }

          return CustomCard(
            title: "${selectedIngredients[index]['name']}",
            onTapHandler: onTapHandler,
            valueText: priceText,
            index: index,
            items: selectedIngredients,
            customExpansion: Text(
              selectedIngredients[index]['description'],
              style: TextStyle(color: AppColors.secondary),
            ),
            trailing: Icons.delete,
            trailingColor: Colors.red,
          );
        }
      ),
    );
  }
}