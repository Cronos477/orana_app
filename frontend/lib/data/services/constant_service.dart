import 'dart:convert';

import 'package:http/http.dart';
import 'package:orana/core/exceptions/custom_exception.dart';
import 'package:orana/data/models/constant.dart';
import 'package:orana/utils/constants/backend_info.dart';

class ConstantService {
  final String _baseUrl = "${BackendInfo.baseUrl}/constants";
  final Map<String, String> headers = {
    'Authorization': 'Token ${BackendInfo.appToken}',
    'Content-Type': 'application/json',
  };

  Future<List<Constant>> getConstants() async {
    try {
      List<Constant> constants = [];

      final Response response = await get(
        Uri.parse(_baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        for (Map<String, dynamic> constant in jsonDecode(response.body)) {
          constants.add(Constant.fromJson(constant));
        }

        return constants;
      }

      throw ReqExeption(
        message: "Erro ao buscar constantes.",
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw ReqExeption(message: e.toString(), statusCode: null);
    }
  }

  Future<void> updateConstants(List<Constant> constants) async {
    try {
      for (Constant constant in constants) {
        final Response response = await put(
          Uri.parse("$_baseUrl/${constant.id}"),
          body: constant.toMap(),
          headers: headers,
        );

        if (response.statusCode != 204) {
          throw ReqExeption(
            message: "Falha ao fazer atualizações: ${constant.name}",
            statusCode: response.statusCode,
          );
        }
      }
    } catch (e) {
      throw ReqExeption(message: e.toString(), statusCode: null);
    }
  }
}
