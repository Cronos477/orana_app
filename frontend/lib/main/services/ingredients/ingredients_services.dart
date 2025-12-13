import 'dart:convert';
import 'package:http/http.dart';
import 'package:orana/utils/backend_info.dart';

Future<bool> updateIngredient(Map<String, dynamic> ingredient) async{
  final ingredientId = ingredient['id'];

  final String body = jsonEncode(ingredient);

  final Response response = await put(
    Uri.parse('${BackendInfo.baseUrl}/ingredients/$ingredientId/'),
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json'
    },
    body: body
  );

  return response.statusCode == 201 || response.statusCode == 200;
}
Future<dynamic> createIngredient(Map<String, dynamic> ingredient) async{
  final String body = jsonEncode(ingredient);

  final Response response = await post(
    Uri.parse('${BackendInfo.baseUrl}/ingredients/'),
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json'
    },
    body: body
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return (true, jsonDecode(response.body));
  }

  return (false, null);
}
Future<bool> deleteIngredient(Map<String, dynamic> ingredient) async{
  final ingredientId = ingredient['id'];

  final Response response = await delete(
    Uri.parse('${BackendInfo.baseUrl}/ingredients/$ingredientId/'),
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json'
    },
  );

  return response.statusCode == 204;
}

(int, String) parseMeasurementSent(int measurement, String measurementUnit) {
  if (measurementUnit == 'Kg') {
    return (measurement*1000, 'g');
  } else if (measurementUnit == 'L') {
    return (measurement*1000, 'mL');
  }

  return (measurement, measurementUnit);
}
(int, String) parseMeasurementReceive(int measurement, String measurementUnit) {
  if (measurement >= 1000) {
    if (measurementUnit == 'mL') {
      return ((measurement/1000).round(), 'L');
    }
    return ((measurement/1000).round(), 'Kg');
  }
  return (measurement, measurementUnit);
}