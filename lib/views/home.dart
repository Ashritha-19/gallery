// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/providers/authProvider.dart';
import 'package:gallery/providers/imageProvider.dart';
import 'package:gallery/views/authentication/login.dart';
import 'package:gallery/views/favorite.dart';
import 'package:gallery/widget/imagetile.dart';
import 'package:get/get.dart';
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
      if (provider.images.isEmpty) {
        provider.fetchImages();
      }
    });

    _scrollController.addListener(() {
      final provider = context.read<ImageListProvider>();

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading &&
          provider.hasMore) {
        provider.fetchImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImageListProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final screens = [
      // HOME TAB
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
              onPressed: () {
                Get.defaultDialog(
                  title: "Confirm Logout",
                  middleText: "Are you sure you want to logout?",
                  radius: 12,
                  textCancel: "Cancel",
                  textConfirm: "Logout",
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    Get.back();
                    await context.read<AuthProvider>().logout();
                    Get.offAll(() => const LoginScreen());
                  },
                );
              },
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

      // FAVORITES TAB
      const FavoritesScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        // If NOT on Home tab → go to Home
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }

        // If already on Home → show exit dialog
        bool? exit = await Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.exit_to_app,
                      size: 40, color: Colors.red),
                  const SizedBox(height: 15),
                  const Text(
                    "Exit App",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to exit?",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Get.back(result: false),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () =>
                              Get.back(result: true),
                          child: const Text("Exit"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        return exit ?? false;
      },
      child: Scaffold(
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
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorites"),
          ],
        ),
      ),
    );
  }
}