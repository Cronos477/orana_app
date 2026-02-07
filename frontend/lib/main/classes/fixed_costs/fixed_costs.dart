import 'package:intl/intl.dart';

class FixedCost {
  final String? id;
  String name;
  String description;
  int value;

  //TODO: Adicionar controller dentro de todas as classes personalizadas como em Constant
  FixedCost({
    this.id,
    required this.name,
    this.description = "",
    this.value = 0,
  });

  factory FixedCost.fromJson(Map<String, dynamic> json) {
    return FixedCost(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "value": value
    };
  }

  String parseValueToString() {
    final num measureValue = value / 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    final String measureText = formatter.format(measureValue).trim();

    return measureText;
  }

  int parseTextValueToInt(String textValue) {
    return int.parse(
      textValue
      .replaceAll('.', '')
      .replaceAll(',', ''),
    );
  }
}
