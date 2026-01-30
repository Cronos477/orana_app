// ignore_for_file: constant_identifier_names
import 'package:intl/intl.dart';

enum MesuarementUnit { mL, g, L, Kg }

class Ingredient {
  String? id;
  String name;
  String description;
  int price;
  int value;
  MesuarementUnit mesuarementUnit;

  Ingredient({
    this.id,
    required this.name,
    this.description = "",
    this.price = 0,
    this.value = 0,
    this.mesuarementUnit = MesuarementUnit.g,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: json["price"],
      value: json["value"],
      mesuarementUnit: json["measurement_unit"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "value": value,
      "measurement_unit": mesuarementUnit.name,
    };
  }

  String parsePriceToString() {
    final double dPrice = price / 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    final String priceText = formatter.format(dPrice);

    return priceText;
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
