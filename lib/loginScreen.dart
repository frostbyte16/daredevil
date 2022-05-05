import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'adminScreen.dart';
import 'mysql.dart';
import 'signupScreen.dart';
import 'homeScreen.dart';
import 'styles.dart';

var userId, username, userLevel;
// logged in variable
bool loggedIn = false;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // double press back button to exit app
  DateTime backButtonTimePressed = DateTime.now();

  // form key
  final _formKey = GlobalKey<FormState>();

  // initialize database
  var db = new Mysql();

  // editing controller
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  // connectivity result variables
  bool hasInternet = false;

  // firebase
  // final _auth = FirebaseAuth.instance;

  // string for displaying the error message
  String? errorMessage;

  // keep user logged in
  late SharedPreferences prefdata;
  late bool newuser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLoginCheck();

    // check internet connectivity
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;

      setState(() => this.hasInternet = hasInternet);
    });
  }

  // keep user logged in
  void userLoginCheck() async {
    prefdata = await SharedPreferences.getInstance();
    newuser = (prefdata.getBool('login') ?? true);

    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  void dispose() {
    // clean up the controller when the widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // username field
    final buildUsername = TextFormField(
      autofocus: false,
      controller: usernameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        // if (value!.isEmpty) {
        //   return ("Please enter your username.");
        // }
        // // reg expression for username validation
        // if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        //     .hasMatch(value)) {
        //   return ("Username already taken.");
        // }
        // return null;
      },
      onSaved: (value) {
        usernameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        prefixIcon: Icon(
          Icons.account_circle,
          color: Colors.green.shade900,
        ),
        hintText: 'Username',
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
          // getSql();
          String username = usernameController.text;
          String userpassword = passwordController.text;

          if (username != '' && userpassword != '') {
            print('Successful.');
            prefdata.setBool('login', false);
            prefdata.setString('username', username);

            signIn(usernameController.text, passwordController.text);
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
    return WillPopScope(
      onWillPop: () async {
        final timediff = DateTime.now().difference(backButtonTimePressed);
        final isExitWarning = timediff >= Duration(seconds: 2);
        backButtonTimePressed = DateTime.now();

        if (isExitWarning) {
          Fluttertoast.showToast(msg: 'Press back again to exit.');
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
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
                          height: 150,
                          child: Image.asset(
                            'assets/komori.png',
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(height: 45),
                      buildUsername,
                      const SizedBox(height: 25),
                      buildPassword,
                      const SizedBox(height: 35),
                      loginButton,
                      const SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Don't have an account? ",
                              style: accountStyle,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              child: Text(
                                "Create one",
                                style: createStyle,
                              ),
                            )
                          ]),
                      const SizedBox(height: 20),
                      if (hasInternet == false) ...[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Don't have internet? ",
                                style: accountStyle,
                              ),
                              GestureDetector(
                                onTap: () {
                                  loggedIn = false;
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                },
                                child: Text(
                                  "Use offline",
                                  style: createStyle,
                                ),
                              )
                            ])
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String username, String password) async {
    db.getConnection().then((conn) {
      String sql =
          'SELECT * FROM Guidance_system.users WHERE username="$username";';
      conn.query(sql).then((results) {
        var users = results.toList();
        // 0 - id ; 1 - username ; 2 - password ; 3 - userlevel
        if (users.isNotEmpty) {
          //userId = users[0];
          if (username == users[0][1] && password == users[0][2]) {
            userId = users[0][0];
            username = users[0][1];
            userLevel = users[0][3];
            print('Login Success');
            Fluttertoast.showToast(msg: "Login successful.");
            if (userLevel == "user") {
              loggedIn = true;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            } else {
              loggedIn = true;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminScreen()));
            }
          } else {
            loggedIn = false;
            print('Incorrect username/password');
            Fluttertoast.showToast(msg: "Incorrect username/password.");
          }
        } else {
          print('User does not exist');
          Fluttertoast.showToast(msg: "User does not exist.");
        }
      });
      conn.close();
    });
  }

  // void getSql() async {
  //   db.getConnection().then((conn){
  //     String sql = 'SELECT * FROM Guidance_system.users;';
  //     conn.query(sql).then((results){
  //
  //       var users = results.toList(); // [Fields: {id: 100000, username: admin, password: admin, user_level: admin}, Fields: {id: 100001, username: user, password: user, user_level: user}]
  //       var x = users[0][0]; // id
  //       var y = users[0][1]; // username
  //
  //
  //       if (users.isNotEmpty){
  //         print(users);
  //       } else {
  //         print('No data available');
  //       }
  //
  //   // print('id= $x');
  //   // print('username= $y');
  //   // print('row: $results[0]');
  //   for(var row in results){
  //     var id = row[0];
  //     var username = row[1];
  //     print('$id = $username');
  //     setState(() {
  //       //mail = row[1];
  //       //print('mail: $mail');
  //     });
  //   }
  //     });
  //   });
  //
  // }

}
