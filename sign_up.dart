import 'package:firebase_auth/firebase_auth.dart';
import 'package:trails_pool_go/pages/setup/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username, _email, _password;
  int _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an Name';
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: 'Name'),
                onSaved: (input) => _username = input,
              ),
              SizedBox(
                width: 0.0,
                height: 20.0,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide your Phone Number';
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number'),
                onSaved: (input) => _phoneNumber = int.parse(input),
              ),
              SizedBox(
                width: 0.0,
                height: 20.0,
              ),
              TextFormField(
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
                height: 20.0,
              ),
              TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    return 'Longer password please';
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
                height: 30.0,
              ),
              RaisedButton(
                padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                onPressed: signUp,
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.teal.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.teal),
                ),
              ),
              SizedBox(height: 15),
              FlatButton(
                padding: EdgeInsets.all(15),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(),
                        fullscreenDialog: true),
                  );
                },
                child: Text(
                  'Have an account? Sign In',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        UserCredential uCred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        String userId = uCred.user.uid;
        print("user created with id = " + userId);
        // add phone number to user_profile
        Firestore.instance.collection("user_profile").doc(userId).set({
          "phone_number": _phoneNumber.toString(),
          "email": _email,
          "username": _username
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } catch (e) {
        print(e.message);
      }
    }
  }
}

class UserData {
  String displayName;
  String email;
  String uid;
  String password;

  UserData({this.displayName, this.email, this.uid, this.password});
}
