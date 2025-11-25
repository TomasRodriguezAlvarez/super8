import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String _baseUrl = 'http://localhost:3000';

  // LISTAR
  static Future<List<dynamic>> getFichas({String search = ''}) async {
    final uri = Uri.parse(
        '$_baseUrl/fichas?search=$search&page=1&pageSize=200'); // ajusta si quieres
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List;
    } else {
      throw Exception('Error cargando fichas: ${res.statusCode}');
    }
  }

  // OBTENER 
  static Future<Map<String, dynamic>> getFicha(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/fichas/$id'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error cargando ficha: ${res.statusCode}');
    }
  }

  // CREAR
  static Future<Map<String, dynamic>> createFicha(
      Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/fichas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error creando ficha: ${res.statusCode} ${res.body}');
    }
  }

  // ACTUALIZAR
  static Future<Map<String, dynamic>> updateFicha(
      int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/fichas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error actualizando ficha: ${res.statusCode}');
    }
  }

  // ELIMINAR
  static Future<void> deleteFicha(int id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/fichas/$id'));
    if (res.statusCode != 200) {
      throw Exception('Error eliminando ficha: ${res.statusCode}');
    }
  }
}
