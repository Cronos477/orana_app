import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orana/main/classes/currency_input_formatter.dart';
import 'package:orana/main/services/fixed_costs/update_constants_data.dart';
import 'package:orana/utils/app_colors.dart';

Future<void> showConstantsDialog(BuildContext parentContext, List constants) async {
  final List<TextEditingController> controllers = [];
  for (var constant in constants) {
    constant['edited'] = false;

    String text;
    if (constant['name'] == 'Salário') {
      num value = int.parse(constant['value'].toString());
      value /= 100;
      final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
      text = formatter.format(value).trim();
    } else {
      text = constant['value'].toString();
    }

    controllers.add(TextEditingController(text: text));
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
                  String key = constants[index]['name'];
                  TextEditingController controller = controllers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      style: TextStyle(color: AppColors.primary),
                      controller: controller,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      cursorColor: AppColors.secondary,
                      inputFormatters: constants[index]['name'] == 'Salário'
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
                        prefix: constants[index]['name'] == 'Salário'
                            ? Text(
                                'R\$ ',
                                style: TextStyle(color: AppColors.primary),
                              )
                            : null,
                        suffix:
                            (constants[index]['name'] ==
                                    '% Dispesas Invisíveis' ||
                                constants[index]['name'] == 'Lucro')
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

                    for (int i = 0; i < constants.length; i++) {
                      if (constants[i]['name'] == 'Salário') {
                        controllers[i].text = controllers[i].text
                            .toString()
                            .replaceAll('.', '');
                        controllers[i].text = controllers[i].text.replaceAll(
                          ',',
                          '',
                        );
                      }
                      if (constants[i]['value'].toString() !=
                          controllers[i].text) {
                        constants[i]['value'] = controllers[i].text;
                        constants[i]['edited'] = true;
                      }
                    }
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
