// lib/views/AddRecipeScreen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _selectedImage;
  bool _isPremium = false;

  // Untuk bahan-bahan
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController(),
  ];

  // Untuk langkah-langkah
  final List<TextEditingController> _stepControllers = [
    TextEditingController(),
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      // Konversi bahan-bahan ke List<String>
      final ingredients = _ingredientControllers
          .where((controller) => controller.text.isNotEmpty)
          .map((controller) => controller.text)
          .toList();

      // Konversi langkah-langkah ke List<String>
      final steps = _stepControllers
          .where((controller) => controller.text.isNotEmpty)
          .map((controller) => controller.text)
          .toList();

      if (ingredients.isEmpty || steps.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tambahkan minimal 1 bahan dan 1 langkah!"),
          ),
        );
        return;
      }

      final recipe = Recipe(
        title: _titleController.text,
        description: _descController.text,
        imagePath: _selectedImage!.path,
        isPremium: _isPremium ? 1 : 0,
        ingredients: ingredients.join('||'),
        steps: steps.join('||'),
      );

      try {
        await DbHelper.insertRecipe(recipe);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resep berhasil ditambahkan!")),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan resep: $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi form dan pilih gambar!")),
      );
    }
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers.removeAt(index);
      });
    }
  }

  void _addStepField() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStepField(int index) {
    if (_stepControllers.length > 1) {
      setState(() {
        _stepControllers.removeAt(index);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Resep Baru")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Resep
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Judul Resep",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Judul tidak boleh kosong"
                      : null,
                ),
                const SizedBox(height: 16),

                // Deskripsi
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Deskripsi tidak boleh kosong"
                      : null,
                ),
                const SizedBox(height: 16),

                // Gambar
                Row(
                  children: [
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, size: 40),
                          ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload),
                      label: const Text("Pilih Gambar"),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Bahan-bahan
                const Text(
                  "Bahan-bahan:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._ingredientControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: "Bahan ${index + 1}",
                              border: const OutlineInputBorder(),
                              suffixIcon: _ingredientControllers.length > 1
                                  ? IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () =>
                                          _removeIngredientField(index),
                                    )
                                  : null,
                            ),
                            validator: (value) {
                              if (index == 0 &&
                                  (value == null || value.isEmpty)) {
                                return "Minimal 1 bahan diperlukan";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addIngredientField,
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Bahan"),
                  ),
                ),
                const SizedBox(height: 16),

                // Langkah-langkah
                const Text(
                  "Langkah-langkah:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._stepControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "Langkah ${index + 1}",
                              border: const OutlineInputBorder(),
                              suffixIcon: _stepControllers.length > 1
                                  ? IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => _removeStepField(index),
                                    )
                                  : null,
                            ),
                            validator: (value) {
                              if (index == 0 &&
                                  (value == null || value.isEmpty)) {
                                return "Minimal 1 langkah diperlukan";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addStepField,
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Langkah"),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Simpan Resep",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Checkbox Premium di bawah tombol dengan card
                Card(
                  color: Colors.orange.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isPremium,
                          onChanged: (value) {
                            setState(() {
                              _isPremium = value ?? false;
                            });
                          },
                          activeColor: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Tandai sebagai Resep Premium",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const Icon(Icons.star, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
