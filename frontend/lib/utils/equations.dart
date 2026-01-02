import 'package:orana/main/services/get_data.dart';

Future<num> priceCalculation(List ingredients) async {
  final List constants = await getConstants();
  final List costs = await getFixedCosts();

  if (constants[0] == 'Error' || costs[0] == 'Error' || ingredients.isEmpty) {
    return 0;
  }

  final num salary = constants.where((constant) => constant['name'] == 'Salário').first['value']/100;
  final num divisionConstant = constants.where((constant) => constant['name'] == 'Constante de divisão').first['value']/100;
  final num invisibleExpanses = constants.where((constant) => constant['name'] == '% Dispesas Invisíveis').first['value']/100;
  final num profit = constants.where((constant) => constant['name'] == 'Lucro').first['value']/100;

  final num ingredientsPrices = ingredients.fold(0, (sum, ingredient) => sum + (ingredient['price']/100));
  num fixedCost = costs.fold(0, (sum, cost) => sum + (cost['price']/100));
  fixedCost /= divisionConstant;

  final num total = profit * (salary + ingredientsPrices + invisibleExpanses + fixedCost);



  return total;
}