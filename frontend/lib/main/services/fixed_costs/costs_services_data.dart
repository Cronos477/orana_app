import 'dart:convert';
import 'package:http/http.dart';
import 'package:orana/core/exceptions/custom_exception.dart';
import 'package:orana/utils/constants/backend_info.dart';

Future<ReqExeption> updateCostsData(Map<String, dynamic> cost) async {
  final String body = jsonEncode(cost);
  final costId = cost['id'];

  final Response response = await put(
    Uri.parse("${BackendInfo.baseUrl}/fixed_costs/$costId/"),
    body: body,
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json',
    },
  );

  final bool success = response.statusCode == 201 || response.statusCode == 200;

  if (success) {
    return ReqSuccess(success, response.statusCode, null);
  }

  return ReqError(success, response.statusCode);
}

Future<ReqExeption> createCostsData(Map<String, dynamic> cost) async {
  final String body = jsonEncode(cost);

  final Response response = await post(
    Uri.parse("${BackendInfo.baseUrl}/fixed_costs/"),
    body: body,
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json',
    },
  );

  final bool success = response.statusCode == 201 || response.statusCode == 200;

  if (success) {
    return ReqSuccess(success, response.statusCode, jsonDecode(response.body));
  }

  return ReqError(success, response.statusCode);
}

Future<ReqExeption> deleteCostsData(Map<String, dynamic> cost) async {
  final costId = cost['id'];

  final Response response = await delete(
    Uri.parse("${BackendInfo.baseUrl}/fixed_costs/$costId/"),
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json',
    },
  );

  final bool success = response.statusCode == 204;

  if (success) {
    return ReqSuccess(success, response.statusCode, null);
  }

  return ReqError(success, response.statusCode);
}
