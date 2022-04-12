import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';
import 'mysql.dart';

// initialize database
var db = new Mysql();

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {


  // string for displaying the error Message
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();

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
      // validator: (value) {
      //   RegExp regex = new RegExp(r'^.{5,}$');
      //   if (value!.isEmpty) {
      //     return ("Username cannot be empty.");
      //   }
      //   if (!regex.hasMatch(value)) {
      //     return ("Enter valid username. Minimum of 5 characters.");
      //   }
      //   return null;
      // },
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
    // final buildEmail = TextFormField(
    //   autofocus: false,
    //   controller: emailEditingController,
    //   keyboardType: TextInputType.emailAddress,
    //   validator: (value) {
    //     if (value!.isEmpty) {
    //       return ("Please enter your email.");
    //     }
    //     // reg expression for email validation
    //     if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
    //         .hasMatch(value)) {
    //       return ("Please enter a valid email.");
    //     }
    //     return null;
    //   },
    //   onSaved: (value) {
    //     emailEditingController.text = value!;
    //   },
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     fillColor: Colors.white,
    //     filled: true,
    //     border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10)
    //     ),
    //     contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    //     prefixIcon: Icon(
    //       Icons.email,
    //       color: Colors.green.shade900,
    //     ),
    //     hintText: 'Email',
    //   ),
    //   style: const TextStyle(
    //       fontFamily: 'Tahoma'
    //   ),
    // );

    // password field
    final buildPassword = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      // validator: (value) {
      //   RegExp regex = new RegExp(r'^.{6,}$');
      //   if (value!.isEmpty) {
      //     return ("Please enter your password.");
      //   }
      //   if (!regex.hasMatch(value)) {
      //     return ("Enter a valid password. Minimum of 6 characters.");
      //   }
      // },
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
      // validator: (value) {
      //   if (cpasswordEditingController.text != passwordEditingController.text) {
      //     return "Password doesn't match.";
      //   }
      //   return null;
      // },
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
      style: const TextStyle(
          fontFamily: 'Tahoma'
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
          if (passwordEditingController.text == cpasswordEditingController.text){
            signUp(usernameEditingController.text, passwordEditingController.text);
          } else {
            Fluttertoast.showToast(msg: "Passwords do not match");
          }
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
                                      builder: (context) => const LoginScreen()));
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
  void signUp(String username, String password) async {
    db.getConnection().then((conn) {
      String sql = 'SELECT username FROM Guidance_system.users WHERE username="$username";';
      conn.query(sql).then((results) {
        var users = results.toList();
        if (users.isEmpty) {
          insertToDatabase(username, password);
        } else {
          Fluttertoast.showToast(msg: "Username already taken.");
        }
      });
      conn.close();
    });
  }

  void insertToDatabase(String username, String password){
    db.getConnection().then((conn) {
      String sql = 'INSERT INTO Guidance_system.users (username, password, user_level) VALUES ("$username", "$password", "user")';
      conn.query(sql);
      Fluttertoast.showToast(msg: "Account created successfully");
      conn.close();
    });
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
  }
}