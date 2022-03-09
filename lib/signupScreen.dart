import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'loginScreen.dart';
import 'data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homeScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();

  final emailEditingController = new TextEditingController();
  final usernameEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final cpasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    // username field
    final buildUsername = TextFormField(
      autofocus: false,
      controller: usernameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{5,}$');
        if (value!.isEmpty) {
          return ("Username cannot be empty.");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid username. Minimum of 5 characters.");
        }
        return null;
      },
      onSaved: (value) {
        usernameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(
            Icons.account_circle,
            color: Colors.green.shade900),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Username",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),
    );

    // email field
    final buildEmail = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email.");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please enter a valid email.");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.green.shade900,
        ),
        hintText: 'Email',
      ),
      style: const TextStyle(
          fontFamily: 'Tahoma'
      ),
    );

    // password field
    final buildPassword = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please enter your password.");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter a valid password. Minimum of 6 characters.");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.vpn_key, color: Colors.green.shade900),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(
          fontFamily: 'Tahoma'
      ),
    );

    // confirm password field
    final buildCPassword = TextFormField(
      autofocus: false,
      controller: cpasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (cpasswordEditingController.text != passwordEditingController.text) {
          return "Password doesn't match.";
        }
        return null;
      },
      onSaved: (value) {
        cpasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.vpn_key, color: Colors.green.shade900),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green.shade900,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'Bebas Neue',
              color: Colors.white,
              letterSpacing: 3,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade900),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 100,
                        child: Image.asset(
                          "assets/samplelogo.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 45),
                    buildUsername,
                    const SizedBox(height: 20),
                    buildEmail,
                    const SizedBox(height: 20),
                    buildPassword,
                    const SizedBox(height: 20),
                    buildCPassword,
                    const SizedBox(height: 20),
                    signUpButton,
                    const SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already have an account? ",
                            style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white
                            ),),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginScreen()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tahoma'
                              ),
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is incorrect.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests.";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with email and password is not enabled.";
            break;
          default:
            errorMessage = "An undefined error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  postDetailsToFirestore() async {
    // calling firestore
    // calling user data
    // send these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserData userData = UserData();

    // writing all the values
    userData.email = user!.email;
    userData.uid = user.uid;
    userData.username = usernameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userData.toMap());
    Fluttertoast.showToast(msg: "Account created successfully.");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
  }
}
