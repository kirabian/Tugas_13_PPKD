import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari Resep'),
        // BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark),
          label: 'Koleksi Resep',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      onTap: onTap,
    );
  }
}
