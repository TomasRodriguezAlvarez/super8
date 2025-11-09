import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'http://localhost:3000';

  // En Android Emulator: 'http://10.0.2.2:3000'

  static Future<Map<String, dynamic>> _get(String path, [Map<String, String>? q]) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: q);
    print('➡️ GET $uri');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    print('⬅️ ${res.statusCode} ${res.reasonPhrase}');
    if (res.statusCode != 200) {
      throw Exception('GET $path -> ${res.statusCode} ${res.body}');
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> _getList(String path, [Map<String, String>? q]) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: q);
    print('➡️ GET $uri');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    print('⬅️ ${res.statusCode} ${res.reasonPhrase}');
    if (res.statusCode != 200) {
      throw Exception('GET $path -> ${res.statusCode} ${res.body}');
    }
    final data = json.decode(res.body);
    if (data is List) return data;
    if (data is Map && data['items'] is List) return data['items'];
    throw Exception('Formato inesperado en $path');
  }

  static Future<List<Map<String, dynamic>>> fichas({
    String search = '',
    int page = 1,
    int pageSize = 20,
  }) async {
    final list = await _getList('/fichas', {
      'search': search,
      'page': '$page',
      'pageSize': '$pageSize',
    });
    return list.cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> fichaDetalle(int id) async {
    return _get('/fichas/$id');
  }

  static Future<bool> health() async {
    final data = await _get('/health');
    return data['db'] == true;
  }
}
