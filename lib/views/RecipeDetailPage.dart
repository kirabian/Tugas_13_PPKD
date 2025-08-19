import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yukmasak/model/Recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Pecah bahan dan langkah dari string "||" menjadi List
    final ingredients = recipe.ingredients.split('||');
    final steps = recipe.steps.split('||');

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar resep
            SizedBox(
              width: double.infinity,
              height: 220,
              child: recipe.imagePath.startsWith('assets/')
                  ? Image.asset(recipe.imagePath, fit: BoxFit.cover)
                  : Image.file(File(recipe.imagePath), fit: BoxFit.cover),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Bahan
                  const Text(
                    "Bahan-bahan:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...ingredients.map(
                    (bahan) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text("• $bahan"),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Langkah
                  const Text(
                    "Langkah-langkah:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...steps.asMap().entries.map((entry) {
                    int index = entry.key;
                    String step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text("${index + 1}. $step"),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
