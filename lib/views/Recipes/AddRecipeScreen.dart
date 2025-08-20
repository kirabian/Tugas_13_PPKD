import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe; // null = tambah, ada isi = edit

  const AddRecipeScreen({super.key, this.recipe});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _selectedImage;
  bool _isPremium = false;

  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _stepControllers = [];

  @override
  void initState() {
    super.initState();

    // Kalau edit mode → isi field dengan data lama
    if (widget.recipe != null) {
      _titleController.text = widget.recipe!.title;
      _descController.text = widget.recipe!.description;
      _isPremium = widget.recipe!.isPremium == 1;
      _selectedImage = File(widget.recipe!.imagePath);

      // pecah string ke list lalu isi controller
      final ingredients = widget.recipe!.ingredients.split('||');
      final steps = widget.recipe!.steps.split('||');

      for (var i in ingredients) {
        _ingredientControllers.add(TextEditingController(text: i));
      }
      for (var s in steps) {
        _stepControllers.add(TextEditingController(text: s));
      }
    }

    // Kalau mode tambah → kasih minimal 1 field kosong
    if (_ingredientControllers.isEmpty) {
      _ingredientControllers.add(TextEditingController());
    }
    if (_stepControllers.isEmpty) {
      _stepControllers.add(TextEditingController());
    }
  }

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
      final ingredients = _ingredientControllers
          .where((c) => c.text.isNotEmpty)
          .map((c) => c.text)
          .toList();

      final steps = _stepControllers
          .where((c) => c.text.isNotEmpty)
          .map((c) => c.text)
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
        id: widget.recipe?.id, // penting untuk update
        title: _titleController.text,
        description: _descController.text,
        imagePath: _selectedImage!.path,
        isPremium: _isPremium ? 1 : 0,
        ingredients: ingredients.join('||'),
        steps: steps.join('||'),
      );

      try {
        if (widget.recipe == null) {
          // tambah baru
          await DbHelper.insertRecipe(recipe);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Resep berhasil ditambahkan!")),
          );
        } else {
          // update
          await DbHelper.updateRecipe(recipe);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Resep berhasil diperbarui!")),
          );
        }
        Navigator.pop(context, true);
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
    setState(() => _ingredientControllers.add(TextEditingController()));
  }

  void _removeIngredientField(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() => _ingredientControllers.removeAt(index));
    }
  }

  void _addStepField() {
    setState(() => _stepControllers.add(TextEditingController()));
  }

  void _removeStepField(int index) {
    if (_stepControllers.length > 1) {
      setState(() => _stepControllers.removeAt(index));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (var c in _ingredientControllers) {
      c.dispose();
    }
    for (var c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.recipe != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Resep" : "Tambah Resep Baru")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Judul Resep",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty
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
                  validator: (v) => v == null || v.isEmpty
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

                // Bahan
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
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: "Bahan ${index + 1}",
                        border: const OutlineInputBorder(),
                        suffixIcon: _ingredientControllers.length > 1
                            ? IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _removeIngredientField(index),
                              )
                            : null,
                      ),
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

                // Langkah
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

                // Tombol
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      isEdit ? "Update Resep" : "Simpan Resep",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Premium
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
                          onChanged: (v) =>
                              setState(() => _isPremium = v ?? false),
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
