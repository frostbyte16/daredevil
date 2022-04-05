import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'loginScreen.dart';
import 'signupScreen.dart';
import 'homeScreen.dart';
import 'adminScreen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThesisApp',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}