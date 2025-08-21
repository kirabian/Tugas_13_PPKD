import 'package:flutter/material.dart';

class StepList extends StatelessWidget {
  final List<TextEditingController> stepControllers;
  final VoidCallback onAdd;
  final void Function(int) onRemove;

  const StepList({
    super.key,
    required this.stepControllers,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Langkah:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stepControllers.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: stepControllers[index],
                    decoration: InputDecoration(
                      labelText: "Langkah ${index + 1}",
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
          label: const Text("Tambah Langkah"),
        ),
      ],
    );
  }
}
