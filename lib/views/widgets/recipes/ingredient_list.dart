import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final List<TextEditingController> ingredientControllers;
  final VoidCallback onAdd;
  final void Function(int) onRemove;

  const IngredientList({
    super.key,
    required this.ingredientControllers,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bahan:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ingredientControllers.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: ingredientControllers[index],
                    decoration: InputDecoration(
                      labelText: "Bahan ${index + 1}",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => onRemove(index),
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text("Tambah Bahan"),
        ),
      ],
    );
  }
}
