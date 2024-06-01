import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:3000';

  Future<String> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Falha ao fazer login');
    }
  }
}
