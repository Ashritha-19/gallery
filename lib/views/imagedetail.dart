// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gallery/providers/favoriteProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ImageDetailScreen extends StatefulWidget {
  final String id;

  const ImageDetailScreen({super.key, required this.id});

  @override
  State<ImageDetailScreen> createState() =>
      _ImageDetailScreenState();
}

class _ImageDetailScreenState
    extends State<ImageDetailScreen> {
  Map<String, dynamic>? data;
  bool isLoading = true;
  bool isFavorite = false;
  bool isProcessingFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://picsum.photos/id/${widget.id}/info"),
      );

      if (response.statusCode == 200) {
        final decoded =
            json.decode(response.body);

        setState(() {
          data = decoded;
          isLoading = false;
        });

        await checkFavoriteStatus();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkFavoriteStatus() async {
    final provider =
        context.read<FavoriteProvider>();
    final result =
        await provider.isFavorite(widget.id);

    if (mounted) {
      setState(() {
        isFavorite = result;
      });
    }
  }

  Future<void> toggleFavorite() async {
    if (data == null) return;

    final provider =
        context.read<FavoriteProvider>();

    setState(() {
      isProcessingFavorite = true;
    });

    try {
      if (isFavorite) {
        await provider.removeFavorite(widget.id);
        setState(() => isFavorite = false);
      } else {
        await provider.addFavorite({
          'id': data!['id'],
          'author': data!['author'],
          'width': data!['width'],
          'height': data!['height'],
          'download_url':
              data!['download_url'],
          'url': data!['url'],
        });
        setState(() => isFavorite = true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessingFavorite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image Detail",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          isProcessingFavorite
              ? const Padding(
                  padding:
                      EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons
                            .favorite_border,
                    color: isFavorite
                        ? Colors.red
                        : colorScheme
                            .onPrimary,
                  ),
                  onPressed:
                      toggleFavorite,
                ),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator())
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                            16),
                    child: Image.network(
                      data!['download_url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                      height: 24),
                  Card(
                    elevation: 4,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              16),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets
                              .all(20),
                      child: Column(
                        children: [
                          _detailRow(
                              "Author",
                              data!['author']),
                          const Divider(),
                          _detailRow(
                              "Width",
                              data!['width']
                                  .toString()),
                          const Divider(),
                          _detailRow(
                              "Height",
                              data!['height']
                                  .toString()),
                          const Divider(),
                          _detailRow(
                              "URL",
                              data!['url']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _detailRow(
      String title, String value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
              vertical: 10),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: GoogleFonts.poppins(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts
                  .sansation(),
            ),
          ),
        ],
      ),
    );
  }
}