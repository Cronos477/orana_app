import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orana/data/models/constant.dart';
import 'package:orana/utils/formatters/currency_input_formatter.dart';
import 'package:orana/main/services/fixed_costs/update_constants_data.dart';
import 'package:orana/utils/constants/app_colors.dart';

Future<void> showConstantsDialog(BuildContext parentContext, List<Constant> constants) async {
  for (var constant in constants) {
    String textValue;
    if (constant.constantType == ConstantType.currency) {
      textValue = constant.parseValueToString();
    } else {
      textValue = constant.value.toString();
    }

    constant.controller.text = textValue;
    constant.controller.addListener(() {
      if (constant.constantType == ConstantType.currency) {
        constant.value = constant.parseTextValueToInt();
      }
    });
  }

  bool saving = false;

  return showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Editar Constantes"),
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.background,
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: constants.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = constants[index].name;
                  TextEditingController controller = constants[index].controller;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      style: TextStyle(color: AppColors.primary),
                      controller: controller,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      cursorColor: AppColors.secondary,
                      inputFormatters: constants[index].constantType == ConstantType.currency
                          ? [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter(),
                            ]
                          : null,
                      decoration: InputDecoration(
                        labelText: key,
                        labelStyle: TextStyle(color: AppColors.primary),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.secondary,
                            width: 2,
                          ),
                        ),
                        focusColor: AppColors.secondary,
                        prefix: constants[index].constantType == ConstantType.currency
                            ? Text(
                                'R\$ ',
                                style: TextStyle(color: AppColors.primary),
                              )
                            : null,
                        suffix:
                            (constants[index].constantType == ConstantType.percentage)
                            ? Text(
                                '%',
                                style: TextStyle(color: AppColors.primary),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              if (saving) ...[
                CircularProgressIndicator(color: AppColors.primary),
              ] else ...[
                TextButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: AppColors.primary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: AppColors.primary),
                  ),
                  onPressed: () async {
                    setState(() {
                      saving = true;
                    });

                    final Map responses = await updateConstants(constants);

                    final bool success =
                        responses['success'] == constants.length;

                    if (context.mounted) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Dados atualizados com sucesso!'
                                : '${responses['errors']} ao tentar atualizar!',
                            style: TextStyle(color: AppColors.text),
                          ),
                          backgroundColor: success
                              ? AppColors.secondary
                              : AppColors.snackBarError,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ],
          );
        },
      );
    },
  );
}
