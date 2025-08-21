import 'package:flutter/material.dart';
import 'package:yukmasak/views/premium_page.dart';

class PremiumSection extends StatelessWidget {
  const PremiumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              "assets/images/icons/logo_p.png",
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              "Premium Recipes",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PremiumPage()),
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/DataResep/salmon_mewah.jpg",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text("Jajaran Resep Premium"),
              subtitle: const Text("Resep dengan lebih dari 1000 koleksi"),
            ),
            Divider(color: Colors.grey.shade300),
          ],
        ),
      ],
    );
  }
}
