import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';
import 'package:yukmasak/views/Recipes/AddRecipeScreen.dart'; // <- kalau form editnya pakai ini

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final ingredients = recipe.ingredients.split('||');
    final steps = recipe.steps.split('||');

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.orange,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "edit") {
                // Navigasi ke halaman form (AddRecipeScreen bisa dipakai juga untuk edit)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRecipeScreen(
                      // kasih param recipe untuk edit
                      key: UniqueKey(),
                      recipe: recipe,
                    ),
                  ),
                );
              } else if (value == "delete") {
                // Konfirmasi hapus
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Hapus Resep"),
                    content: const Text(
                      "Apakah kamu yakin ingin menghapus resep ini?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Batal"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Hapus"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await DbHelper.deleteRecipe(recipe.id!);
                  // Setelah hapus, balik ke halaman sebelumnya
                  Navigator.pop(context, true);
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Delete"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
