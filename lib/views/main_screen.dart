import 'package:flutter/material.dart';
import 'package:yukmasak/views/AddRecipeScreen.dart';
import 'package:yukmasak/views/home_screen.dart';
import 'package:yukmasak/widgets/custom_buttom_nav.dart';
import 'package:yukmasak/widgets/custom_drawer.dart';
import 'package:yukmasak/widgets/log_out.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const id = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text("B"),
    LogOutButton(),
  ];

  void onDrawerItemTap(int index) {
    Navigator.pop(context); // tutup drawer setelah pilih menu
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(onItemTap: onDrawerItemTap),

      appBar: AppBar(
        title: const Text("Cari Resep"),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 20,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/icons/logo_f.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Center(child: _widgetOptions[_selectedIndex]),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, size: 32),
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
