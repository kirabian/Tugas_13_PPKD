import 'package:flutter/material.dart';
import 'package:yukmasak/preference/shared_preference.dart';
import 'package:yukmasak/views/authentication/login.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTap;

  const CustomDrawer({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.orange),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(title: const Text("Home"), onTap: () => onItemTap(0)),
          ListTile(title: const Text("Profile"), onTap: () => onItemTap(1)),
          // ListTile(title: const Text("Logout"), onTap: () => onItemTap(2)),
          // ListTile(
          //   title: const Text("Input Widget"),
          //   onTap: () => onItemTap(2),
          // ),
          // ListTile(title: const Text("Day 14"), onTap: () => onItemTap(3)),
          // ListTile(title: const Text("Day 15"), onTap: () => onItemTap(4)),
          // ListTile(title: const Text("Day 16"), onTap: () => onItemTap(5)),
          Spacer(),
          ListTile(
            title: const Text("Logout"),
            onTap: () {
              PreferenceHandler.removeLogin(); // hapus session login
              Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.id,
                (route) => false, // hapus semua halaman sebelumnya
              );
            },
          ),
        ],
      ),
    );
  }
}
