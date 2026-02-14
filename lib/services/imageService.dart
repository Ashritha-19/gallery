import 'dart:convert';
import 'package:gallery/models/imageModel.dart';
import 'package:http/http.dart' as http;

class ImageService {
  Future<List<ImageModel>> fetchImages(int page) async {
    final response = await http.get(
        Uri.parse("https://picsum.photos/v2/list?page=$page&limit=30"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => ImageModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load images");
    }
  }
}
