import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mysql.dart';
import 'signupScreen.dart';
import 'homeScreen.dart';
import 'styles.dart';

var userId, username, userLevel;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();


}

class _LoginScreenState extends State<LoginScreen> {

  // form key
  final _formKey = GlobalKey<FormState>();
  // initialize database
  var db = new Mysql();
  var mail = '';

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  // final _auth = FirebaseAuth.instance;

  // string for displaying the error message
  String? errorMessage;

  // keep user logged in
  // late SharedPreferences prefdata;
  late bool newuser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //userLoginCheck();
  }

  // keep user logged in
  void userLoginCheck() async {
    // prefdata = await SharedPreferences.getInstance();
    // newuser = (prefdata.getBool('login') ?? true);
    // print(newuser);
    //
    // if (newuser == false) {
    //   Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomeScreen()));
    // }
  }

  @override
  void dispose() {
    // clean up the controller when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // email field
    final buildEmail = TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value!;
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
      style: hoverStyle,
    );

    // password field
    final buildPassword = TextFormField(
      autofocus: false,
      controller: passwordController,
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
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
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
      style: hoverStyle,
    );

    // login button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green.shade900,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          getSql();
          //print('mail: $mail');

          String useremail = emailController.text;
          String userpassword = passwordController.text;

          if (useremail != '' && userpassword != '') {
            // print('Successful.');
            // prefdata.setBool('login', false);
            // prefdata.setString('email', useremail);
            signIn(emailController.text, passwordController.text);
          } else {
            Fluttertoast.showToast(msg: "Enter missing login credentials.");
          }
        },
        child: const Text(
          "Sign In",
          textAlign: TextAlign.center,
          style: signInStyle,
        ),
      ),
    );

    // ui
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
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
                          'assets/samplelogo.png',
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 45),
                    buildEmail,
                    const SizedBox(height: 25),
                    buildPassword,
                    const SizedBox(height: 35),
                    loginButton,
                    const SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account? ",
                            style: accountStyle,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      SignupScreen()));
                            },
                            child: Text(
                              "Create one",
                              style: createStyle,
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

  // login function
  void signIn(String email, String password) async {
    db.getConnection().then((conn){
      String sql = 'SELECT * FROM Guidance_system.users WHERE username="$email";';
      conn.query(sql).then((results){
        var users = results.toList();
        // 0 - id ; 1 - username ; 2 - password ; 3 - userlevel
        if (users.isNotEmpty){
          //userId = users[0];
          if(email==users[0][1] && password==users[0][2]){
            userId = users[0][0];
            username = users[0][1];
            userLevel = users[0][3];
            print('Login Success');
            Fluttertoast.showToast(msg: "Login successful.");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
          } else{
            print('Incorrect username/password');
            Fluttertoast.showToast(msg: "Incorrect username/password.");
          }
        } else {
          print('User does not exist');
          Fluttertoast.showToast(msg: "User does not exist.");
        }
      });
    });
  }

  void getSql() async {
    // db.getConnection().then((conn){
    //   String sql = 'SELECT * FROM Guidance_system.users WHERE username="jkashdka";';
    //   conn.query(sql).then((results){
    //
    //     var users = results.toList(); // [Fields: {id: 100000, username: admin, password: admin, user_level: admin}, Fields: {id: 100001, username: user, password: user, user_level: user}]
    //     // var x = users[0][0]; // id
    //     // var y = users[0][1]; // username
    //
    //
    //     if (users.isNotEmpty){
    //       print(users);
    //     } else {
    //       print('No data available');
    //     }

        // print('id= $x');
        // print('username= $y');
        //print('row: $results[0]');
        // for(var row in results){
        //   setState(() {
        //     mail = row[1];
        //     //print('mail: $mail');
        //   });
        // }
    //   });
    // });

  }
}