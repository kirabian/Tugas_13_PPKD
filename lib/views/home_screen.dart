import 'package:flutter/material.dart';
import 'package:yukmasak/views/Recipes/AddRecipeScreen.dart';
import 'package:yukmasak/views/widgets/latest_recipes.dart';
import 'package:yukmasak/views/widgets/popular_grid.dart';
import 'package:yukmasak/views/widgets/premium_section.dart';
import 'package:yukmasak/views/widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  static const id = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _refreshRecipes() => setState(() {});
  void _navigateToAddRecipeScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
    );
    if (result == true) _refreshRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecipeScreen,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(),
            const SizedBox(height: 24),
            PopularGrid(),
            const SizedBox(height: 24),
            PremiumSection(),
            const SizedBox(height: 24),
            LatestRecipes(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
