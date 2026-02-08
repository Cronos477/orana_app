import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ConstantType {
  currency('c'),
  integer('i'),
  percentage('p');

  final String value;
  const ConstantType(this.value);

  static ConstantType fromString(String value) {
    return ConstantType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ConstantType.currency,
    );
  }
}

class Constant {
  final String? id;
  String name;
  String description;
  ConstantType constantType;
  TextEditingController controller;
  int value;

  Constant({
    this.id,
    required this.name,
    this.description = "",
    this.constantType = ConstantType.currency,
    required this.controller,
    this.value = 0,
  });

  factory Constant.fromJson(Map<String, dynamic> json) {
    return Constant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      constantType: ConstantType.fromString(json["constant_type"] ?? "c"),
      controller: TextEditingController(),
      value: json["value"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "const_type": constantType.value,
      "value": value
    };
  }

  String parseValueToString() {
    final num measureValue = value / 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    final String measureText = formatter.format(measureValue).trim();

    return measureText;
  }

  int parseTextValueToInt() {
    return int.parse(
      controller.text
      .replaceAll('.', '')
      .replaceAll(',', '')
    );
  }
}
