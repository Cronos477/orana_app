import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


//TODO: (IDEA) Criar um mini-blog com tecnológias/códigos úteis e interessantes que já usei, incluir esse.
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '0.00',
        selection: TextSelection.collapsed(offset: 4)
      );
    }

    String newText = newValue.text.replaceAll(r'[^0-9]', '');

    int value = int.parse(newText);

    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    String formattedText = formatter.format(value/100).trim();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length)
    );
  }

}
