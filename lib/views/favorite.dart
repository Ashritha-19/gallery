import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:gallery/providers/favoriteProvider.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: StreamBuilder<QuerySnapshot>(
        stream: provider.getFavorites(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text("Something went wrong"));
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites Yet ❤️",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(6),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onLongPress: () {
                  Get.defaultDialog(
                    title: "Remove Favorite",
                    middleText:
                        "Do you want to remove this image from favorites?",
                    textCancel: "Cancel",
                    textConfirm: "Remove",
                    confirmTextColor: Colors.white,
                    onConfirm: () async {
                      Get.back();
                      await provider
                          .removeFavorite(data['id']);

                      Get.snackbar(
                        "Removed",
                        "Removed from Favorites",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: Image.network(
                    data['download_url'],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}