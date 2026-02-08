import 'package:flutter/material.dart';
import 'package:orana/utils/constants/app_colors.dart';

Future<bool?> deleteAlertDialog(BuildContext parentContext) {
  return showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmação'),
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        content: Center(
          child: Text(
            'Ao confirmar a ação a seguir, o item será removido da lista. Tem certeza de que deseja continuar?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              "Não",
              style: TextStyle(
                color: AppColors.primary
              ),
            )
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Sim",
              style: TextStyle(
                color: Colors.red
              ),
            )
          )
        ],
      );
    }
  );
}