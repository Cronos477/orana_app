import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orana/main/classes/miscellaneous/currency_input_formatter.dart';
import 'package:orana/main/classes/miscellaneous/custom_response.dart';
import 'package:orana/main/classes/fixed_costs/fixed_costs.dart';
import 'package:orana/main/services/fixed_costs/costs_services_data.dart';
import 'package:orana/main/widgets/custom_text_field.dart';
import 'package:orana/utils/app_colors.dart';

Future<bool?> showCostsDialog(BuildContext parentContext, List costs, int? index) async {
  final bool editing = index != null;

  FixedCost cost = editing
      ? costs[index]
      : FixedCost(name: "");

  String valueText = cost.parseValueToString();

  TextEditingController nameTextEditingController = TextEditingController(
    text: cost.name
  );
  TextEditingController descriptionTextEditingController = TextEditingController(
      text: cost.description
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
            final CustomResponse response;

            cost.name = nameTextEditingController.text;
            cost.description = descriptionTextEditingController.text;
            cost.value = cost.parseTextValueToInt(valueTextEditingController.text);

            if (editing) {
              response = await updateCostsData(cost.toMap());
            } else {
              response = await createCostsData(cost.toMap());

              if (response.success) {
                response as ReqSuccess;
                costs.add(response.data);
              }
            }

            if (context.mounted) {
              ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      response.success ?
                      'Alterações salvas com sucesso!' :
                      'Ocorreu um erro ao realizar as alterações! ERROR: ${response.statusCode}',
                      style: TextStyle(color: AppColors.text),
                    ),
                    backgroundColor: response.success
                        ? AppColors.secondary
                        : AppColors.snackBarError,
                  )
              );
              Navigator.of(context).pop(response.success);
            }
          }
          Future<void> handleDelete() async{
            final CustomResponse response = await deleteCostsData(cost.toMap());

            if (context.mounted) {
              ScaffoldMessenger.of(parentContext).showSnackBar(
                SnackBar(
                  content: Text(
                    response.success ?
                    'Item removido com sucesso!' :
                    'Ocorreu um erro ao realizar a exclusão! ERROR: ${response.statusCode}',
                    style: TextStyle(color: AppColors.text),
                  ),
                  backgroundColor: response.success
                      ? AppColors.secondary
                      : AppColors.snackBarError,
                ),
              );

              Navigator.of(context).pop(response.success);
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
