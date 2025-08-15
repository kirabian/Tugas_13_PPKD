// import 'package:flutter/material.dart';
// import 'package:yukmasak/extension/navigation.dart';
// import 'package:yukmasak/views/start.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   static const id = "/main";
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndexDrawer = 0;
//   static const List<Widget> _widgetOptions = <Widget>[
//     StartWidget(appBar: false),
//     Day6(),
//     InputWidget(),
//     Day14ListOnListViewBuilder(),
//     Day15ParsingData(),
//     Day16UserScreen(),
//   ];
//   void onItemTap(int index) {
//     setState(() {
//       _selectedIndexDrawer = index;
//     });
//     context.pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: _widgetOptions[_selectedIndexDrawer]),
//       appBar: AppBar(),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             ListTile(
//               title: Text("Day 4-5"),
//               onTap: () {
//                 onItemTap(0);
//               },
//             ),

//             ListTile(
//               title: Text("Day 6"),
//               onTap: () {
//                 onItemTap(1);
//               },
//             ),
//             ListTile(
//               title: Text("Input Widget"),
//               onTap: () {
//                 onItemTap(2);
//               },
//             ),
//             ListTile(
//               title: Text("Day 14"),
//               onTap: () {
//                 onItemTap(3);
//               },
//             ),
//             ListTile(
//               title: Text("Day 15"),
//               onTap: () {
//                 onItemTap(4);
//               },
//             ),
//             ListTile(
//               title: Text("Day 16"),
//               onTap: () {
//                 onItemTap(5);
//               },
//             ),
//           ],
//         ),
//       ),
//       // endDrawer: Drawer(child: Column(children: [])),
//     );
//   }
// }
