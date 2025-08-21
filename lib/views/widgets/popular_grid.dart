import 'package:flutter/material.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/views/Recipes/RecipeDetailPage.dart';

class PopularGrid extends StatelessWidget {
  const PopularGrid({super.key});

  Widget _buildFoodCard(BuildContext context, String title, String imagePath) {
    final recipe = Recipe(
      title: title,
      description: "Deskripsi $title",
      imagePath: imagePath,
      isPremium: 0,
      ingredients: "Bahan 1||Bahan 2",
      steps: "Langkah 1||Langkah 2",
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3.5,
      children: [
        _buildFoodCard(
          context,
          "Fluffy Pancake",
          "assets/images/DataResep/fluffy_pancake.jpg",
        ),
        _buildFoodCard(
          context,
          "Mie Gacoan",
          "assets/images/DataResep/gacoan.jpg",
        ),
        _buildFoodCard(
          context,
          "Rendang",
          "assets/images/DataResep/rendang.jpg",
        ),
        _buildFoodCard(
          context,
          "Ayam Katsu",
          "assets/images/DataResep/ayam_katsu.jpg",
        ),
        _buildFoodCard(context, "Dimsum", "assets/images/DataResep/dimsum.jpg"),
        _buildFoodCard(context, "Donat", "assets/images/DataResep/donat.jpg"),
      ],
    );
  }
}
