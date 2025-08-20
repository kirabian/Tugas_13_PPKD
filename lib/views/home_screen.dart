// lib/views/HomeScreen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';
import 'package:yukmasak/views/Profile_Screen.dart';
import 'package:yukmasak/views/Recipes/AddRecipeScreen.dart'; // <-- Pastikan import ini ada
import 'package:yukmasak/views/Recipes/RecipeDetailPage.dart';
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
    LogOutButton(),
    ProfileScreen(),
  ];

  void onDrawerItemTap(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method untuk memicu build ulang widget dan memuat ulang data dari FutureBuilder
  void _refreshRecipes() {
    setState(() {
      // Panggilan setState kosong sudah cukup untuk memberitahu Flutter
      // agar menjalankan kembali method build()
    });
  }

  // Method untuk bernavigasi ke halaman tambah resep
  // Dibuat async untuk bisa menunggu hasil dari halaman tersebut
  void _navigateToAddRecipeScreen() async {
    // 'await' akan menjeda eksekusi sampai AddRecipeScreen ditutup (di-pop)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
    );

    // Periksa apakah hasil yang dikembalikan adalah 'true'
    // 'true' dikirim dari AddRecipeScreen jika resep berhasil disimpan
    if (result == true) {
      _refreshRecipes(); // Jika ya, panggil method refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menambahkan FloatingActionButton untuk tombol "Tambah Resep"
      floatingActionButton: FloatingActionButton(
        onPressed:
            _navigateToAddRecipeScreen, // Panggil fungsi navigasi saat ditekan
        backgroundColor: Colors.orange,
        tooltip: 'Tambah Resep Baru',
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding yang konsisten
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
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "                               Diperbarui 08:00",
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
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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
                      // ... (ListTile Premium lainnya)
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Resep Terbaru (dari DB)
              const Text(
                "Resep Terbaru",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
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
                        child: Text('Belum ada resep, ayo tambahkan!'),
                      );
                    } else {
                      final recipes = snapshot.data!;
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recipes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          // Membalik urutan list agar yang terbaru muncul pertama
                          final recipe = recipes[recipes.length - 1 - index];
                          return _buildHorizontalFoodCard(recipe);
                        },
                      );
                    }
                  },
                ),
              ),
              // Memberi jarak di bawah agar tidak tertutup oleh FloatingActionButton
              const SizedBox(height: 80),
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
                textAlign: TextAlign.center,
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
        // Navigasi ke detail page juga perlu 'await' jika ada kemungkinan
        // data diubah (misal: edit resep) dan ingin refresh setelah kembali.
        // Untuk saat ini, navigasi biasa sudah cukup.
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
          color: Colors.white,
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
              // Cek apakah path gambar dari asset atau file lokal
              recipe.imagePath.startsWith('assets/')
                  ? Image.asset(recipe.imagePath, fit: BoxFit.cover)
                  : Image.file(File(recipe.imagePath), fit: BoxFit.cover),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
                child: Text(
                  recipe.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
