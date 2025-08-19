// lib/views/HomeScreen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';
import 'package:yukmasak/views/RecipeDetailPage.dart';
import 'package:yukmasak/views/premium_page.dart';
import 'package:yukmasak/views/search_page.dart';
import 'package:yukmasak/widgets/log_out.dart';

class HomeScreen extends StatefulWidget {
  static const id = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text("A"), // placeholder
    Text("B"),
    LogOutButton(),
  ];

  void onDrawerItemTap(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Cari Resep',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      );
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Pencarian Populer
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Pencarian Populer",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    TextSpan(
                      text: "                               Diperbarui 08:00",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Grid makanan populer (statis)
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3.5,
                children: [
                  _buildFoodCard(
                    "Fluffy Pancake",
                    "assets/images/DataResep/fluffy_pancake.jpg",
                  ),
                  _buildFoodCard(
                    "Mie Gacoan",
                    "assets/images/DataResep/gacoan.jpg",
                  ),
                  _buildFoodCard(
                    "Rendang",
                    "assets/images/DataResep/rendang.jpg",
                  ),
                  _buildFoodCard(
                    "Ayam Katsu",
                    "assets/images/DataResep/ayam_katsu.jpg",
                  ),
                  _buildFoodCard(
                    "Dimsum",
                    "assets/images/DataResep/dimsum.jpg",
                  ),
                  _buildFoodCard("Donat", "assets/images/DataResep/donat.jpg"),
                ],
              ),

              const SizedBox(height: 24),

              // Premium Recipes
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/logo_p.png",
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Premium Recipes",
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PremiumPage(),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/DataResep/salmon_mewah.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: const Text("Jajaran Resep Premium"),
                        subtitle: const Text(
                          "Resep dengan lebih dari 1000 koleksi",
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PremiumPage(),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/DataResep/steak_mewah.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: const Text("Resep Paling Banyak Dilihat"),
                        subtitle: const Text(
                          "Resep yang paling banyak dicari dan dilihat",
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PremiumPage(),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/DataResep/icecream_mewah.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: const Text("Menu Mingguan Premium"),
                        subtitle: const Text("Menu spesial untuk kamu"),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Resep Terbaru (dari DB)
              const Text(
                "Resep Terbaru",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 200,
                child: FutureBuilder<List<Recipe>>(
                  future: DbHelper.getAllRecipes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Belum ada resep terbaru'),
                      );
                    } else {
                      final recipes = snapshot.data!;
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recipes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          return _buildHorizontalFoodCard(recipe);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper untuk grid populer
  Widget _buildFoodCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        final recipe = Recipe(
          title: title,
          description: "Deskripsi $title", // placeholder
          imagePath: imagePath,
          isPremium: 0,
          ingredients: "Bahan 1||Bahan 2", // placeholder
          steps: "Langkah 1||Langkah 2", // placeholder
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipe: recipe),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Container(
              color: Colors.black.withOpacity(0.4),
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk horizontal card (Resep Terbaru)
  Widget _buildHorizontalFoodCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipe: recipe),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              recipe.imagePath.startsWith('assets/')
                  ? Image.asset(recipe.imagePath, fit: BoxFit.cover)
                  : Image.file(File(recipe.imagePath), fit: BoxFit.cover),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  recipe.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
