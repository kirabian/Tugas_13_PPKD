import 'package:flutter/material.dart';
import 'package:yukmasak/views/authentication/login.dart';
import 'package:yukmasak/views/main_screen.dart';
import 'package:yukmasak/views/splash_screen.dart';

void main() {
  // initializeDateFormatting("id_ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Colors.blue.shade100,
        ),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      initialRoute: Day16SplashScreen.id,
      routes: {
        "/login": (context) => LoginScreen(),
        Day16SplashScreen.id: (context) => Day16SplashScreen(),
        // Day7GridView.id: (context) => Day7GridView(),
        MainScreen.id: (context) => MainScreen(),
      },
      // home: LoginScreen(),

      ///TEST
    );
  }
}
