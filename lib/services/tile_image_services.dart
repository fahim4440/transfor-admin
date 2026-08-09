import 'dart:convert';

import 'package:http/http.dart' as http;

class TileImageServices {
  static const String _baseUrl = 'http://128.199.42.59/api/Api.php?apicall=';

  Future<Map<String, String>> getTileImages() async {
    final response = await http.post(Uri.parse('${_baseUrl}getTileImages'));
    final json = jsonDecode(response.body);
    if (json['error'] == true) throw Exception(json['message']);
    final raw = json['tiles'] as Map<String, dynamic>;
    return raw.map((k, v) => MapEntry(k, v.toString()));
  }

  Future<void> updateTileImage({
    required String tileKey,
    required String imageDataBase64,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}updateTileImage'),
      body: {
        'tile_key': tileKey,
        'image_data': imageDataBase64,
      },
    );
    final json = jsonDecode(response.body);
    if (json['error'] == true) throw Exception(json['message']);
  }
}
