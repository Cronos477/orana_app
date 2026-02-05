import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orana/main/classes/fixed_costs.dart';
import 'package:orana/main/classes/ingredient.dart';
import 'package:orana/utils/backend_info.dart';

Future<List> getMenu() async {
  final req = await http.get(
    Uri.parse("${BackendInfo.baseUrl}/menu"),
    headers: {"Authorization": "Token ${BackendInfo.appToken}"},
  );

  if (req.statusCode != 200) {
    throw FormatException("HTTP_ERROR: ${req.statusCode}");
  }

  final ingredients = jsonDecode(req.body);

  return ingredients;
}

Future<List<Ingredient>> getIngredients() async {
  List<Ingredient> ingredients = [];
  final req = await http.get(
    Uri.parse("${BackendInfo.baseUrl}/ingredients"),
    headers: {"Authorization": "Token ${BackendInfo.appToken}"},
  );

  if (req.statusCode != 200) {
    throw FormatException("HTTP_ERROR: ${req.statusCode}");
  }

  final List response = jsonDecode(req.body);

  for (Map<String, dynamic> ingredient in response) {
    ingredients.add(Ingredient.fromJson(ingredient));
  }

  return ingredients;
}

Future<(List, List<FixedCost>)> getCostsScreen() async {
  final constants = await getConstants();
  final fixedCosts = await getFixedCosts();
  return (constants, fixedCosts);
}

Future<List> getConstants() async {
  final req = await http.get(
    Uri.parse("${BackendInfo.baseUrl}/constants"),
    headers: {"Authorization": "Token ${BackendInfo.appToken}"},
  );

  if (req.statusCode != 200) {
    throw FormatException("HTTP_ERROR: ${req.statusCode}");
  }

  final constants = jsonDecode(req.body);

  return constants;
}

Future<List<FixedCost>> getFixedCosts() async {
  List<FixedCost> fixedCosts = [];

  final req = await http.get(
    Uri.parse("${BackendInfo.baseUrl}/fixed_costs"),
    headers: {"Authorization": "Token ${BackendInfo.appToken}"},
  );

  if (req.statusCode != 200) {
    throw FormatException("HTTP_ERROR: ${req.statusCode}");
  }

  final List response = jsonDecode(req.body);

  for (Map<String, dynamic> fixedCost in response) {
    fixedCosts.add(FixedCost.fromJson(fixedCost));
  }

  return fixedCosts;
}
