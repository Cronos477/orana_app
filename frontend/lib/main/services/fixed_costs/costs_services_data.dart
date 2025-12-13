import 'dart:convert';
import 'package:http/http.dart';
import 'package:orana/utils/backend_info.dart';

Future<bool> updateCostsData(Map<String, dynamic> cost) async {
  final String body = jsonEncode(cost);
  final costId = cost['id'];

  final Response response = await put(
      Uri.parse("${BackendInfo.baseUrl}/fixed_costs/$costId/"),
      body: body,
      headers: {
        'Authorization': 'Token ${BackendInfo.appToken}',
        'Content-Type': 'application/json'
      }
  );

  return response.statusCode == 201 || response.statusCode == 200;
}

Future<dynamic> createCostsData(Map<String, dynamic> cost) async {
  final String body = jsonEncode(cost);

  final Response response = await post(
      Uri.parse("${BackendInfo.baseUrl}/fixed_costs/"),
      body: body,
      headers: {
        'Authorization': 'Token ${BackendInfo.appToken}',
        'Content-Type': 'application/json'
      }
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    return (true, jsonDecode(response.body));
  }

  return (false, null);
}

Future<bool> deleteCostsData(Map<String, dynamic> cost) async {
  final costId = cost['id'];

  final Response response = await delete(
    Uri.parse("${BackendInfo.baseUrl}/fixed_costs/$costId/"),
    headers: {
        'Authorization': 'Token ${BackendInfo.appToken}',
        'Content-Type': 'application/json'
      },
  );

  return response.statusCode == 204;
}