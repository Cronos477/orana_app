import 'dart:convert';
import 'package:http/http.dart';
import 'package:orana/utils/backend_info.dart';

Future<Map<String, dynamic>> updateConstants(List constants) async {
  Map<String, dynamic> responses = {
    'success': 0,
    'errors': constants.length,
    'error_items': []
  };

  for (var constant in constants) {
    Map changeMap = {...constant};
    if (!changeMap['edited']) {
      responses['errors'] -= 1;
      responses['success'] += 1;
      continue;
    }

    if (changeMap['name'] == "Salário") {
      String textToParse = changeMap['value'].toString().replaceAll('.', '');
      textToParse = textToParse.replaceAll(',', '');
      changeMap['value'] = int.tryParse(textToParse) ?? 0;
    } else {
      changeMap['value'] = int.tryParse(changeMap['value'].toString()) ?? 0;
    }

    final String body = jsonEncode({
      'name': changeMap['name'],
      'description': changeMap['description'],
      'value': changeMap['value']
    });

    final Response response = await put(
      Uri.parse("${BackendInfo.baseUrl}/constants/${changeMap['id']}/"),
      body: body,
      headers: {
        'Authorization': 'Token ${BackendInfo.appToken}',
        'Content-Type': 'application/json'
      }
    );

    if (response.statusCode != 200) {
      responses['error_items'].add(changeMap['name']);
      continue;
    }

    responses['errors'] -= 1;
    responses['success'] += 1;
  }

  return responses;
}
