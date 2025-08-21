import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/sqflite/db_helper.dart';
import 'package:yukmasak/views/widgets/recipes/image_picker_field.dart';
import 'package:yukmasak/views/widgets/recipes/ingredient_list.dart';
import 'package:yukmasak/views/widgets/recipes/premium_checkbox.dart';
import 'package:yukmasak/views/widgets/recipes/step_list.dart';

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
        id: widget.recipe?.id,
        title: _titleController.text,
        description: _descController.text,
        imagePath: _selectedImage!.path,
        isPremium: _isPremium ? 1 : 0,
        ingredients: ingredients.join('||'),
        steps: steps.join('||'),
      );

      try {
        if (widget.recipe == null) {
          await DbHelper.insertRecipe(recipe);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Resep berhasil ditambahkan!")),
          );
        } else {
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
                ImagePickerField(
                  selectedImage: _selectedImage,
                  onPickImage: _pickImage,
                ),
                const SizedBox(height: 24),

                // Bahan
                IngredientList(
                  ingredientControllers: _ingredientControllers,
                  onAdd: () => setState(
                    () => _ingredientControllers.add(TextEditingController()),
                  ),
                  onRemove: (index) =>
                      setState(() => _ingredientControllers.removeAt(index)),
                ),
                const SizedBox(height: 16),

                // Langkah
                StepList(
                  stepControllers: _stepControllers,
                  onAdd: () => setState(
                    () => _stepControllers.add(TextEditingController()),
                  ),
                  onRemove: (index) =>
                      setState(() => _stepControllers.removeAt(index)),
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
                    child: Text(
                      isEdit ? "Update Resep" : "Simpan Resep",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Premium
                PremiumCheckbox(
                  value: _isPremium,
                  onChanged: (v) => setState(() => _isPremium = v ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
