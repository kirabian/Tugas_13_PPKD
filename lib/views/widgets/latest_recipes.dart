import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';
import 'package:yukmasak/views/Recipes/RecipeDetailPage.dart';

class LatestRecipes extends StatelessWidget {
  const LatestRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  separatorBuilder: (context, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final recipe = recipes[recipes.length - 1 - index];
                    return _buildHorizontalFoodCard(recipe, context);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalFoodCard(Recipe recipe, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
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
