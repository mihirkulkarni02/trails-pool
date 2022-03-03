import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:trails_pool_go/pages/setup/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trails_pool_go/pages/setup/sign_in.dart';
import 'package:trails_pool_go/pages/setup/ForgotPassword.dart';
import 'package:trails_pool_go/pages/setup/ConfirmEmail.dart';

import 'create.dart';
import 'mainlist.dart';

const String reqCollection = "requests";
const String offCollection = "offers";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  static const String _title = 'Trails Pool';
  static bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData.light(),
      home: loggedIn ? MyStatefulWidget() : new WelcomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        ConfirmEmail.id: (context) => ConfirmEmail(),
        ForgotPassword.id: (context) => ForgotPassword(),
      },
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    CreateOfferList(),
    CreateList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyStatefulWidget(),
                ),
              );
            },
          ),
        ],
        title: Text("Trails Pool"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondRoute(),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(LoginPage.userName),
              accountEmail: Text(LoginPage.emailAddress),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  '${LoginPage.userName[0]}',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outlined),
              title: Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Trails Pool",
                  applicationVersion: "1.0",
                  applicationIcon:
                      Image.asset('assets/images/web_hi_res_512.png'),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_outlined),
              title: Text('Sign Out and Exit'),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              title: Text('Request'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outlined),
              title: Text('Offer'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
