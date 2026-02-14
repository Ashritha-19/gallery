import 'package:flutter/material.dart';
import 'package:gallery/providers/authProvider.dart';
import 'package:gallery/providers/imageProvider.dart';
import 'package:gallery/views/favorite.dart';
import 'package:gallery/widget/imagetile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ImageListProvider>();
      provider.fetchImages();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ImageListProvider>().fetchImages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImageListProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final screens = [
      Scaffold(
        appBar: AppBar(
          title: Text(
            "PicVerse",
            style: GoogleFonts.instrumentSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: colorScheme.onPrimary),
              onPressed: () => context.read<AuthProvider>().logout(),
            ),
          ],
        ),
        body: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(6),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount:
              imageProvider.images.length + (imageProvider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < imageProvider.images.length) {
              return ImageTile(image: imageProvider.images[index]);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      const FavoritesScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
