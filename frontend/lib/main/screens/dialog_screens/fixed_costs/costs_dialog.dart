import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orana/main/classes/currency_input_formatter.dart';
import 'package:orana/main/services/fixed_costs/costs_services_data.dart';
import 'package:orana/main/widgets/custom_text_field.dart';
import 'package:orana/utils/app_colors.dart';

Future<bool?> showCostsDialog(BuildContext parentContext, List costs, int? index) async {
  final bool editing = index != null;

  Map<String, dynamic>? cost = editing
      ? costs[index]
      : null;

  String? valueText;

  if (editing) {
    num value = int.parse(costs[index]['value'].toString());
    value /= 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    valueText = formatter.format(value).trim();
  } else {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    valueText = formatter.format(0.00).trim();
  }

  TextEditingController nameTextEditingController = TextEditingController(
    text: cost != null ?
    cost['name'] :
    null
  );
  TextEditingController descriptionTextEditingController = TextEditingController(
      text: cost != null ?
      cost['description'] :
      null
  );
  TextEditingController valueTextEditingController = TextEditingController(
      text: valueText
  );

  bool saving = false;

  return showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> handleSave() async{
            bool success;
            Map? costGen;

            if (editing) {
              cost!['name'] = nameTextEditingController.text;
              cost['description'] = descriptionTextEditingController.text;
              cost['value'] = int.parse(valueTextEditingController.text.replaceAll('.', '').replaceAll(',', ''));
              success = await updateCostsData(cost);
            } else {
              final int value = int.parse(valueTextEditingController.text
                  .replaceAll('.', '')
                  .replaceAll(',', ''));

              final Map<String, dynamic> reqCost = {
                "name": nameTextEditingController.text,
                "value": value,
                "description": descriptionTextEditingController.text
              };

              (success, costGen) = await createCostsData(reqCost);

              if (success) {
                costs.add(costGen);
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
            final bool success = await deleteCostsData(cost!);

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
            title: Text('Custo Fixo'),
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
                      labelText: "Nome",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      textEditingController: valueTextEditingController,
                      labelText: "Valor",
                      prefix: Text(
                        'R\$ ',
                        style: TextStyle(
                            color: AppColors.primary
                        ),
                      ),
                      textInputType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
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
            actionsAlignment: editing && !saving ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            actions: <Widget>[
              if (saving)
                CircularProgressIndicator(color: AppColors.primary)
              else if (editing) ...[
                deleteButton,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [cancelButton, saveButton],
                )
              ] else ...[
                cancelButton,
                saveButton,
              ]
            ],
          );
        },
      );
    },
  );
}
