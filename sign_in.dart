import 'package:firebase_auth/firebase_auth.dart';
import 'package:trails_pool_go/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:trails_pool_go/pages/setup/sign_up.dart';
import 'package:trails_pool_go/main.dart';
import 'ForgotPassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static String emailAddress;
  static String userId;
  static int phoneNumber;
  static String userName;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.teal,
        title: (Text('Sign In')),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an email';
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(),
                    labelText: 'Email'),
                onSaved: (input) => _email = input,
              ),
              SizedBox(
                width: 0.0,
                height: 15.0,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                validator: (input) {
                  if (input.length < 6) {
                    return 'Incorrect Password';
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    labelText: 'Password'),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
              SizedBox(
                width: 0.0,
                height: 20.0,
              ),
              RaisedButton(
                padding: EdgeInsets.all(10),
                onPressed: signIn,
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.teal.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.teal),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ForgotPassword.id,
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        UserCredential userCred = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password));
        User user = userCred.user;
        Firestore.instance
            .collection("user_profile")
            .doc(user.uid)
            .get()
            .then((value) {
          print(value.data());
          LoginPage.phoneNumber = int.parse(value.data()["phone_number"]);
          LoginPage.userName = value.data()["username"];
          LoginPage.emailAddress = value.data()["email"];
          print("phone_number = " + LoginPage.phoneNumber.toString());
          print("userName = " + LoginPage.userName);
          print("emailAddress = " + LoginPage.emailAddress);
        });
        MyApp.loggedIn = true;
        LoginPage.emailAddress = _email;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home(user: user)));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
