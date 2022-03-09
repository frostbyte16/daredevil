import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'loginScreen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Initialize Firebase App
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'ThesisApp',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return const LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}