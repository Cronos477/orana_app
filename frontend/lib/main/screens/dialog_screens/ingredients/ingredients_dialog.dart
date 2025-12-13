import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orana/main/classes/currency_input_formatter.dart';
import 'package:orana/main/services/ingredients/ingredients_services.dart';
import 'package:orana/main/widgets/custom_dropdown_list.dart';
import 'package:orana/main/widgets/custom_text_field.dart';
import 'package:orana/utils/app_colors.dart';

Future<bool?> showIngredientsDialog(BuildContext parentContext, List ingredients, int? index) async {
  final bool editing = index != null;

  Map<String, dynamic>? ingredient = editing
      ? ingredients[index]
      : null;

  String? priceText;
  String? measureText;
  String? initialMeasureUnit;

  if (editing) {
    num price = int.parse(ingredients[index]['price'].toString());
    price /= 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    priceText = formatter.format(price).trim();

    num measureValue = int.parse(ingredient!['value'].toString());
    measureValue /= 100;

    (measureValue, initialMeasureUnit) = parseMeasurementReceive(measureValue.round(), ingredient['measurement_unit']);

    measureText = formatter.format(measureValue).trim();
  } else {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    priceText = formatter.format(0.00).trim();
    measureText = formatter.format(0.00).trim();
  }

  TextEditingController nameTextEditingController = TextEditingController(
      text: ingredient != null ?
      ingredient['name'] :
      null
  );
  TextEditingController descriptionTextEditingController = TextEditingController(
      text: ingredient != null ?
      ingredient['description'] :
      null
  );
  TextEditingController priceTextEditingController = TextEditingController(
      text: priceText
  );
  TextEditingController valueTextEditingController = TextEditingController(
      text: measureText
  );
  String measurementUnit = editing ? initialMeasureUnit! : 'g';

  bool saving = false;

  return showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> handleSave() async {
            bool success;
            Map responseBody;

            final String finalUnit;
            final int finalMeasurement;

            final int price = int.parse(priceTextEditingController.text
                .replaceAll('.', '')
                .replaceAll(',', ''));

            final int value = int.parse(valueTextEditingController.text
                .replaceAll('.', '')
                .replaceAll(',', ''));

            (finalMeasurement, finalUnit) = parseMeasurementSent(value, measurementUnit);

            final Map<String, dynamic> body = {
              'name': nameTextEditingController.text,
              'description': descriptionTextEditingController.text,
              'price': price,
              'value': finalMeasurement,
              'measurement_unit': finalUnit
            };

            if (editing) {
              body['id'] = ingredient!['id'];
              success = await updateIngredient(body);
            } else {
              (success, responseBody) = await createIngredient(body);

              if (success) {
                ingredients.add(responseBody);
              }
            }

            if (context.mounted) {
              ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ?
                      'Alterações salvas com sucesso!' :
                      'Ocorreu um erro ao realizar as alterações!',
                      style: TextStyle(color: AppColors.text),
                    ),
                    backgroundColor: success
                        ? AppColors.secondary
                        : AppColors.snackBarError,
                  )
              );
              Navigator.of(context).pop(success);
            }
          }
          Future<void> handleDelete() async {
            final success = await deleteIngredient(ingredient!);

            if (context.mounted) {
              ScaffoldMessenger.of(parentContext).showSnackBar(
                SnackBar(
                  content: Text(
                    success ?
                    'Item removido com sucesso!' :
                    'Ocorreu um erro ao realizar a exclusão!',
                    style: TextStyle(color: AppColors.text),
                  ),
                  backgroundColor: success
                      ? AppColors.secondary
                      : AppColors.snackBarError,
                ),
              );

              Navigator.of(context).pop(success);
            }
          }

          void updateFromChild(String? newValue) {
            if (newValue != null) {
              measurementUnit = newValue;
            }
          }

          final cancelButton = TextButton(
              child: Text(
                "Cancelar",
                style: TextStyle(color: AppColors.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          final saveButton = TextButton(
              child: Text(
                "Salvar",
                style: TextStyle(color: AppColors.primary),
              ),
              onPressed: () async {
                setState(() {
                  saving = true;
                });
                await handleSave();
              },
            );
          final deleteButton = IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                setState(() {
                  saving = true;
                });
                handleDelete();
              },
            );

          return AlertDialog(
            title: Text('Ingredientes'),
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.background,
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      textEditingController: nameTextEditingController,
                      labelText: 'Nome',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      textEditingController: priceTextEditingController,
                      labelText: "Valor",
                      prefix: Text(
                        'R\$ ',
                        style: TextStyle(
                          color: AppColors.primary
                        ),
                      ),
                      textInputType: TextInputType.numberWithOptions(
                        decimal: true
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            textEditingController: valueTextEditingController,
                            labelText: 'Massa',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomDropdownList(
                            items: ['g', 'Kg', 'mL', 'L'],
                            initial: measurementUnit,
                            parentValue: updateFromChild,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      textEditingController: descriptionTextEditingController,
                      labelText: "Descrição",
                    ),
                  ),
                ],
              ),
            ),
            actionsAlignment: editing && !saving
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            actions: <Widget>[
              if (saving)
                CircularProgressIndicator(color: AppColors.primary)
              else if (editing) ...[
                deleteButton,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [cancelButton, saveButton],
                ),
              ] else ...[
                cancelButton,
                saveButton,
              ],
            ],
          );
        },
      );
    },
  );
}
