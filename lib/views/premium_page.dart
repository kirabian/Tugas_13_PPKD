import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  // Ganti dengan username Saweria kamu
  final String saweriaUsername = "Rubaku";

  Future<void> _launchSaweria() async {
    final Uri url = Uri.parse("https://saweria.co/Rubaku?nominal=9900");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Tidak bisa membuka Saweria");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium Recipes"),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Langganan Premium",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Nikmati akses tak terbatas ke ribuan resep premium, "
              "menu mingguan eksklusif, dan koleksi resep terbaik yang selalu diperbarui.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Benefit List
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text("Akses lebih dari 1000 resep eksklusif"),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text("Menu mingguan spesial setiap minggu"),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text("Resep favorit paling populer tanpa batas"),
                ),
              ],
            ),

            const Spacer(),

            // Harga + Tombol
            Center(
              child: Column(
                children: [
                  const Text(
                    "Harga: Rp9.900,00 / minggu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _launchSaweria,
                    child: const Text(
                      "Langganan Sekarang",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
