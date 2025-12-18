import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orana/main/classes/currency_input_formatter.dart';
import 'package:orana/main/services/menu/menu_services.dart';
import 'package:orana/main/widgets/custom_text_field.dart';
import 'package:orana/utils/app_colors.dart';

Future<bool?> showMenuDialog(BuildContext parentContext, List menuItems, int? index) async{
  final bool editing = index != null;

  Map<String, dynamic>? menuItem = editing
      ? menuItems[index]
      : null;
  
  String? priceText;

  if (editing) {
    num price = int.parse(menuItem!['price'].toString());
    price /= 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    priceText = formatter.format(price).trim();
  } else {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    priceText = formatter.format(0.00).trim();
  }

  TextEditingController nameTextEditingController = TextEditingController(
      text: menuItem != null ?
      menuItem['name'] :
      null
  );
  TextEditingController descriptionTextEditingController = TextEditingController(
      text: menuItem != null ?
      menuItem['description'] :
      null
  );
  TextEditingController priceTextEditingController = TextEditingController(
      text: priceText
  );
  TextEditingController unitTextEditingController = TextEditingController(
      text: menuItem != null ?
      menuItem['units'] :
      null
  );

  bool saving = false;

  return showDialog(
    context: parentContext,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> handleSave(Map<String, dynamic> ingredients) async{
            bool success;
            Map responseBody;

            final int price = int.parse(priceTextEditingController.text
                .replaceAll('.', '')
                .replaceAll(',', ''));

            final Map<String, dynamic> body = {
              'name': nameTextEditingController.text,
              'description': descriptionTextEditingController.text,
              'price': price,
              'ingredients': jsonEncode(ingredients),
              'units': int.parse(unitTextEditingController.text)
            };

            if (editing) {
              body['id'] = menuItem!['id'];
              success = await updateMenuItem(body);
            } else {
              (success, responseBody) = await createMenuItem(body);

              if (success) {
                menuItems.add(responseBody);
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
          Future<void> handleDelete() async{
            final success = await deleteMenuItem(menuItem!);

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
          
          Map<String, dynamic> ingredients = {};

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
                await handleSave(ingredients);
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
            title: Text('Menu'),
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
                    child: CustomTextField(
                      textEditingController: unitTextEditingController,
                      labelText: 'Quantidade',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
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
                  //TODO: Adicionar tela para adicionar/remover ingredientes, aqui aparece como: x ingredientes adicionados.
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
        }
      );
    }
  );
}