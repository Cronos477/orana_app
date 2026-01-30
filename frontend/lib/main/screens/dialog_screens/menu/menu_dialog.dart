import 'package:flutter/material.dart';
import 'package:orana/main/widgets/custom_dropdown_list.dart';
import 'package:orana/utils/app_colors.dart';


Future<(bool, dynamic)?> showAddIngredientDialog(BuildContext parentContext, List<Map> ingredients) async{
  final List<String> ingredientsNames = ingredients.map(
    (Map ingredient) {
      final num value = ingredient['value']/100;
      return "${ingredient['name']} - ${value.toStringAsFixed(2)}${ingredient['measurement_unit']}";
    }
  ).toList();

  String selectedIngredient = ingredientsNames.first;

  void updateFromChild(String? newValue) {
    if (newValue != null) {
      selectedIngredient = newValue;
    }
  }

  return showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomDropdownList(
              items: ingredientsNames,
              parentValue: updateFromChild,
              initial: selectedIngredient
            )
          ],
        ),
      );
    }
  );
}