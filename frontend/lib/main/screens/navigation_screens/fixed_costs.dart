import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orana/main/screens/dialog_screens/fixed_costs/constants_dialog.dart';
import 'package:orana/main/screens/dialog_screens/fixed_costs/costs_dialog.dart';
import 'package:orana/main/services/get_data.dart';
import 'package:orana/main/widgets/custom_card.dart';
import 'package:orana/utils/app_colors.dart';

class FixedCosts extends StatefulWidget {
  const FixedCosts({super.key});

  @override
  State<FixedCosts> createState() => _FixedCostsState();
}

class _FixedCostsState extends State<FixedCosts> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCostsScreen(),
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
          List costs;
          List constants = [];

          (constants, costs) = snapshot.data;

          return Scaffold(
            backgroundColor: AppColors.background,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      backgroundColor: AppColors.primary,
                      onPressed: () async {
                        await showConstantsDialog(context, constants);
                      },
                      child: Text(
                        'Const.',
                        style: TextStyle(
                          color: AppColors.icons
                        ),
                      ),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    onPressed: () async {
                      final bool? success = await showCostsDialog(context, costs, null);

                      if (success != null && success) {
                        setState(() {});
                      }
                    },
                    child: Icon(
                      Icons.add,
                      color: AppColors.icons,
                    ),
                  ),
                ),
              ]
            ),
            body: ListView.builder(
              itemCount: costs.length,
              padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
              itemBuilder: (BuildContext context, int index) {
                final double value = costs[index]['value']/100;
                final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
                final String valueText = formatter.format(value);

                Future<void> onTapHandler() async {
                  final bool? success = await showCostsDialog(
                      context,
                      costs,
                      index
                  );

                  if (success != null && success) {
                    setState(() {});
                  }
                }

                return Padding(
                  padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
                  child: CustomCard(
                    onTapHandler: onTapHandler,
                    valueText: valueText,
                    index: index,
                    items: costs,
                  ),
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
      },
    );
  }
}
