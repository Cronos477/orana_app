import 'package:orana/main/classes/currency_input_formatter.dart';
import 'package:orana/main/widgets/custom_text_field.dart';
import 'package:orana/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Attributes extends StatefulWidget {
  const Attributes({
    super.key,
    required this.nameTextEditingController,
    required this.unitTextEditingController,
    required this.realPriceTextEditingController,
    required this.calculatePriceTextEditingController,
    required this.descriptionTextEditingController,
  });
  final TextEditingController nameTextEditingController;
  final TextEditingController unitTextEditingController;
  final TextEditingController realPriceTextEditingController;
  final TextEditingController calculatePriceTextEditingController;
  final TextEditingController descriptionTextEditingController;

  @override
  State<Attributes> createState() => _AttributesState();
}

class _AttributesState extends State<Attributes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      textEditingController: widget.nameTextEditingController,
                      labelText: 'Nome',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      textEditingController: widget.unitTextEditingController,
                      labelText: 'Unidades',
                      textInputType: TextInputType.numberWithOptions(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      textEditingController: widget.realPriceTextEditingController,
                      labelText: 'Preço Real',
                      prefix: Text('R\$ '),
                      textInputType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      textEditingController: widget.calculatePriceTextEditingController,
                      labelText: 'Preço Teorico',
                      prefix: Text('R\$ '),
                      textInputType: TextInputType.numberWithOptions(),
                      readOnly: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                textEditingController: widget.descriptionTextEditingController,
                labelText: 'Descrição',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
