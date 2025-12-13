import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orana/utils/backend_info.dart';

Future<List> getMenu() async {
  try {
    final req = await http.get(
      Uri.parse("${BackendInfo.baseUrl}/menu"),
      headers: {
        "Authorization": "Token ${BackendInfo.appToken}"
      },
    );

    if (req.statusCode != 200) {
      throw Error();
    }

    final ingredients = jsonDecode(req.body);

    return ingredients;

  } catch (e) {
    return ['Error', e];
  }
}

Future<List> getIngredients() async {
  try {
    final req = await http.get(
      Uri.parse("${BackendInfo.baseUrl}/ingredients"),
      headers: {
        "Authorization": "Token ${BackendInfo.appToken}"
      },
    );

    if (req.statusCode != 200) {
      throw Error();
    }

    final List ingredients = jsonDecode(req.body);

    return ingredients;

  } catch (e) {
    return ['Error', e];
  }
}

Future<dynamic> getCostsScreen() async {
    final constants = await getConstants();
    final fixedCosts = await getFixedCosts();
    return (constants, fixedCosts);
}

Future<List> getConstants() async {
  try {
    final req = await http.get(
      Uri.parse("${BackendInfo.baseUrl}/constants"),
      headers: {
        "Authorization": "Token ${BackendInfo.appToken}"
      },
    );

    if (req.statusCode != 200) {
      throw Error();
    }

    final constants = jsonDecode(req.body);

    return constants;

  } catch (e) {
    return ['Error', e];
  }
}

Future<List> getFixedCosts() async {
  try {
    final req = await http.get(
      Uri.parse("${BackendInfo.baseUrl}/fixed_costs"),
      headers: {
        "Authorization": "Token ${BackendInfo.appToken}"
      },
    );

    if (req.statusCode != 200) {
      throw Error();
    }

    final constants = jsonDecode(req.body);

    return constants;

  } catch (e) {
    return ['Error', e];
  }
}
