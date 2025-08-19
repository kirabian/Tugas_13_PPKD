import 'package:flutter/material.dart';
import 'package:yukmasak/extension/navigation.dart';
import 'package:yukmasak/preference/shared_preference.dart';
import 'package:yukmasak/utils/app_image.dart';
import 'package:yukmasak/views/authentication/login.dart';
import 'package:yukmasak/views/main_screen.dart';

class Day16SplashScreen extends StatefulWidget {
  const Day16SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<Day16SplashScreen> createState() => _Day16SplashScreenState();
}

class _Day16SplashScreenState extends State<Day16SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    // Get the login status from shared preferences.
    bool? isLogin = await PreferenceHandler.getLogin();

    // Wait for 3 seconds before navigating.
    Future.delayed(const Duration(seconds: 3)).then((value) {
      // Check if the widget is still in the widget tree before navigating.
      if (!mounted) return;

      if (isLogin == true) {
        // If the user is logged in, go to the main screen.
        context.pushReplacementNamed(MainScreen.id);
      } else {
        // Otherwise, go to the login screen.
        context.push(LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use SizedBox.expand to make its child fill the entire screen.
      body: SizedBox.expand(
        child: Image.asset(
          AppImage.Background,
          // BoxFit.cover ensures the image covers the screen,
          // maintaining its aspect ratio by cropping if necessary.
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
