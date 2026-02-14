import 'package:flutter/material.dart';
import 'package:gallery/models/imageModel.dart';
import 'package:gallery/views/imagedetail.dart';


class ImageTile extends StatelessWidget {
  final ImageModel image;

  const ImageTile({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageDetailScreen(id: image.id),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          image.downloadUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
