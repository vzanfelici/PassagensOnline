import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/passagem.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Passagem>> buscarPassagens(
      String origem, String destino, String dataPartida) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/passagens/buscar?origem=$origem&destino=$destino&dataPartida=$dataPartida'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Passagem.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar passagens');
    }
  }

  Future<List<String>> buscarOrigens() async {
    final response = await http.get(Uri.parse('$baseUrl/passagens/origens'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return List<String>.from(body);
    } else {
      throw Exception('Erro ao buscar origens');
    }
  }

  Future<List<String>> buscarDestinos() async {
    final response = await http.get(Uri.parse('$baseUrl/passagens/destinos'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return List<String>.from(body);
    } else {
      throw Exception('Erro ao buscar destinos');
    }
  }
}
