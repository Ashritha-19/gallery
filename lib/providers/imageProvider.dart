import 'package:flutter/material.dart';
import 'package:gallery/models/imageModel.dart';
import 'package:gallery/services/imageService.dart';


class ImageListProvider extends ChangeNotifier {
  final ImageService _service = ImageService();

  List<ImageModel> images = [];
  int _page = 1;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> fetchImages() async {
    if (isLoading || !hasMore) return;

    try {
      isLoading = true;
      notifyListeners();

      final newImages = await _service.fetchImages(_page);

      if (newImages.isEmpty) {
        hasMore = false;
      } else {
        images.addAll(newImages);
        _page++;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
