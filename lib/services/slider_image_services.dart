import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/slider_image.dart';

class SliderImageServices {
  static const String _baseUrl = 'http://128.199.42.59/api/Api.php?apicall=';

  Future<List<SliderImage>> getSliderImages() async {
    final response = await http.post(Uri.parse('${_baseUrl}getSliderImages'));
    final json = jsonDecode(response.body);
    if (json['error'] == true) throw Exception(json['message']);
    return (json['images'] as List)
        .map((e) => SliderImage.fromJson(e))
        .toList();
  }

  Future<void> uploadSliderImage({
    required String imageName,
    required String imageDataBase64,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}uploadSliderImage'),
      body: {
        'image_name': imageName,
        'image_data': imageDataBase64,
      },
    );
    final json = jsonDecode(response.body);
    if (json['error'] == true) throw Exception(json['message']);
  }

  Future<void> deleteSliderImage(String id) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}deleteSliderImage'),
      body: {'id': id},
    );
    final json = jsonDecode(response.body);
    if (json['error'] == true) throw Exception(json['message']);
  }
}
