import 'package:intl/intl.dart';

enum ConstantType {
  currency,
  integer,
  percentage
}

class Constant {
  final String? id;
  final String name;
  final String description;
  final ConstantType constantType;
  final int value;
  final bool edited;

  Constant({
    this.id,
    required this.name,
    this.description = "",
    this.constantType = ConstantType.currency,
    this.value = 0,
    this.edited = false
  });

  factory Constant.fromJson(Map<String, dynamic> json) {
    return Constant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "description": description, "value": value};
  }

  String parseValueToString() {
    final num measureValue = value / 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    final String measureText = formatter.format(measureValue).trim();

    return measureText;
  }

  int parseTextValueToInt(String textValue) {
    return int.parse(textValue.replaceAll('.', '').replaceAll(',', ''));
  }
}
