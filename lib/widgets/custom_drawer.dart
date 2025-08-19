import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTap;

  const CustomDrawer({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(title: const Text("Day 4-5"), onTap: () => onItemTap(0)),
          ListTile(title: const Text("Day 6"), onTap: () => onItemTap(1)),
          ListTile(
            title: const Text("Input Widget"),
            onTap: () => onItemTap(2),
          ),
          ListTile(title: const Text("Day 14"), onTap: () => onItemTap(3)),
          ListTile(title: const Text("Day 15"), onTap: () => onItemTap(4)),
          ListTile(title: const Text("Day 16"), onTap: () => onItemTap(5)),
        ],
      ),
    );
  }
}
