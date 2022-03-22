import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

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

  Widget buildConfirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
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
                hintText: 'Re-enter your password...'
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitBtn() {
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
          'SUBMIT',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tahoma'
          ),
        ),
      ),
    );
  }

  Widget buildSigninBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Tahoma'
              ),
            ),
            TextSpan(
              text: 'Sign In',
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
                      'SIGN UP',
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
                    SizedBox(height: 10),
                    buildUsername(),
                    SizedBox(height: 10),
                    buildPassword(),
                    SizedBox(height: 10),
                    buildConfirmPassword(),
                    buildSubmitBtn(),
                    buildSigninBtn(),
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