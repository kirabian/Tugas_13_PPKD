import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';
import 'package:yukmasak/views/Recipes/RecipeDetailPage.dart';

class AllRecentRecipesPage extends StatelessWidget {
  const AllRecentRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Resep Terbaru"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: DbHelper.getAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada resep tersimpan"));
          }

          final recipes = snapshot.data!;
          // Urutkan biar terbaru muncul di atas
          final reversed = recipes.reversed.toList();

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: reversed.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final recipe = reversed[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(recipe: recipe),
                    ),
                  );
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: recipe.imagePath.startsWith("assets/")
                      ? Image.asset(
                          recipe.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(recipe.imagePath),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                ),
                title: Text(
                  recipe.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  recipe.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
