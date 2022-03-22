import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signupScreen.dart';
import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isRememberMe = false;

  Widget buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 17
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.name,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Tahoma'
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.text_fields,
                  color: Colors.green.shade900,
                ),
                hintText: 'Enter your username...'
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 17
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          child: TextField(
            obscureText: true,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Tahoma'
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.green.shade900,
                ),
                hintText: 'Enter your password...'
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print("Forgot Password pressed"),
        padding: EdgeInsets.only(right: 0),
        child: Text(
          'Forgot Password?',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tahoma'
          ),
        ),
      ),
    );
  }

  Widget buildRememberBtn() {
    return Container(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
                value: isRememberMe,
                checkColor: Colors.black,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    isRememberMe = value!;
                  });
                }
            ),
          ),
          Text(
            'Remember Me',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Tahoma'
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.green.shade900,
        child: Text(
          'LOGIN',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tahoma'
          ),
        ),
      ),
    );
  }

  Widget buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Tahoma'
              ),
            ),
            TextSpan(
              text: 'Create one',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontFamily: 'Tahoma',
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'SIGN IN',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Bebas Neue',
                        letterSpacing: 5,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildUsername(),
                    SizedBox(
                      height: 10,
                    ),
                    buildPassword(),
                    SizedBox(
                      height: 10,
                    ),
                    buildForgotPassword(),
                    buildRememberBtn(),
                    buildLoginBtn(),
                    buildSignupBtn(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}