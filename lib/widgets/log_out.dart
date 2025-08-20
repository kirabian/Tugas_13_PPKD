import 'package:flutter/material.dart';
import 'package:yukmasak/extension/navigation.dart';
import 'package:yukmasak/preference/shared_preference.dart';
import 'package:yukmasak/views/authentication/login.dart';

class LogOutButton extends StatelessWidget {
  static const id = "/logout";
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PreferenceHandler.removeLogin();
        context.pushReplacementNamed(LoginScreen.id);
      },
      child: Text("Keluar"),
    );
  }
}
