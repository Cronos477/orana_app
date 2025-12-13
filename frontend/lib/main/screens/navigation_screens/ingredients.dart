import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orana/main/screens/dialog_screens/ingredients/ingredients_dialog.dart';
import 'package:orana/main/services/get_data.dart';
import 'package:orana/main/widgets/custom_card.dart';
import 'package:orana/utils/app_colors.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({super.key});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIngredients(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                    color: AppColors.primary
                ),
              ),
            );
          } else if (snapshot.hasData) {
            List ingredients = snapshot.data;

            return Scaffold(
              backgroundColor: AppColors.background,
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () async {
                  final bool? success = await showIngredientsDialog(
                    context,
                    ingredients,
                    null,
                  );

                  if (success != null && success) {
                    setState(() {});
                  }
                },
                child: Icon(
                  Icons.add,
                  color: AppColors.icons,
                ),
              ),
              body: ListView.builder(
                itemCount: ingredients.length,
                padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
                itemBuilder: (BuildContext context, int index) {
                  final double price = ingredients[index]['price']/100;
                  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
                  final String priceText = formatter.format(price);

                  Future<void> onTapHandler() async {
                    final bool? success = await showIngredientsDialog(
                        context,
                        ingredients,
                        index
                    );

                    if (success != null && success) {
                      setState(() {});
                    }
                  }

                  return CustomCard(
                    onTapHandler: onTapHandler,
                    valueText: priceText,
                    index: index,
                    items: ingredients,
                  );
                },
              ),
            );
          }

          return Center(
            child: Text(
              'Sem dados.',
              style: TextStyle(
                  color: AppColors.primary
              ),
            ),
          );
        }
    );
  }
}
