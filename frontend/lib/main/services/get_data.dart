import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orana/utils/backend_info.dart';
import 'package:orana/main/classes/fixed_costs/constant.dart';
import 'package:orana/main/classes/fixed_costs/fixed_costs.dart';
import 'package:orana/main/classes/ingredient/ingredient.dart';

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

Future<(List<Constant>, List<FixedCost>)> getCostsScreen() async {
  final List<Constant> constants = await getConstants();
  final List<FixedCost> fixedCosts = await getFixedCosts();
  return (constants, fixedCosts);
}

Future<List<Constant>> getConstants() async {
  final List<Constant> constants = [];

  final req = await http.get(
    Uri.parse("${BackendInfo.baseUrl}/constants"),
    headers: {"Authorization": "Token ${BackendInfo.appToken}"},
  );

  if (req.statusCode != 200) {
    throw FormatException("HTTP_ERROR: ${req.statusCode}");
  }

  final response = jsonDecode(req.body);

  for (Map<String, dynamic> constant in response) {
    constants.add(Constant.fromJson(constant));
  }

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
