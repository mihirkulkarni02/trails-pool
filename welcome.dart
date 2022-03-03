import 'package:trails_pool_go/pages/setup/sign_in.dart';
import 'package:trails_pool_go/pages/setup/sign_up.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trails Pool'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Welcome to Trails Pool",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 26,
            ),
            SizedBox(
              width: 0.0,
              height: 20.0,
            ),
            RaisedButton(
              padding: EdgeInsets.all(15),
              onPressed: navigateToSignIn,
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
            SizedBox(
              width: 0.0,
              height: 15.0,
            ),
            RaisedButton(
              padding: EdgeInsets.all(15),
              onPressed: navigateToSignUp,
              child: Text('New Here? Sign up!'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(), fullscreenDialog: true),
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SignUpPage(), fullscreenDialog: true),
    );
  }
}
