import 'dart:convert';
import 'package:http/http.dart';
import 'package:orana/utils/backend_info.dart';

Future<bool> updateMenuItem(Map<String, dynamic> menuItem) async{
  final menuItemId = menuItem['id'];

  final String body = jsonEncode(menuItem);

  final Response response = await put(
    Uri.parse('${BackendInfo.baseUrl}/menu/$menuItemId'),
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json'
    },
    body: body
  );

  return response.statusCode == 201 || response.statusCode == 200;
}

Future<dynamic> createMenuItem(Map<String, dynamic> menuItem) async{
  final String body = jsonEncode(menuItem);

  final Response response = await post(
    Uri.parse('${BackendInfo.baseUrl}/menu'),
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

Future<bool> deleteMenuItem(Map<String, dynamic> menuItem) async{
  final menuItemId = menuItem['id'];

  final Response response = await delete(
    Uri.parse('${BackendInfo.baseUrl}/menu/$menuItemId/'),
    headers: {
      'Authorization': 'Token ${BackendInfo.appToken}',
      'Content-Type': 'application/json'
    },
  );

  return response.statusCode == 204;
}
