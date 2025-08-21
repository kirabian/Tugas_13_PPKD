import 'package:flutter/material.dart';

class PremiumCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const PremiumCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text("Jadikan resep premium"),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.orange,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
