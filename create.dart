import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trails_pool_go/pages/setup/sign_in.dart';
import 'main.dart';

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text("Create"),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_car),
                  child: Text('Request'),
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  child: Text('Offer'),
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[CreateRequest(), CreateOffer()]),
        ),
      ),
    );
  }
}

class RequestObj {
  String location;
  String time;
  String date;
  String pickupSpot;
  String notes;
  String usermail;
  int usernumber;
  String username;

  DocumentReference reference;

  RequestObj(
      {this.location,
      this.time,
      this.date,
      this.pickupSpot,
      this.notes,
      this.usermail,
      this.usernumber,
      this.username});

  toJson() {
    return {
      'location': location,
      'time': time,
      'date': date,
      'pickupSpot': pickupSpot,
      'notes': notes,
      'usermail': usermail,
      'usernumber': usernumber,
      'username': username,
    };
  }
}

class CreateRequest extends StatelessWidget {
  TextEditingController locController = TextEditingController();
  TextEditingController pickupController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  // date and time widgets
  BasicTimeField btm = BasicTimeField();
  BasicDateField bdm = BasicDateField();

  addUser() {
    RequestObj req = RequestObj(
      location: locController.text,
      time: btm.getController().text,
      date: bdm.getController().text,
      pickupSpot: pickupController.text,
      notes: notesController.text,
      usermail: LoginPage.emailAddress,
      usernumber: LoginPage.phoneNumber,
      username: LoginPage.userName,
    );
    try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance.collection(reqCollection).document().setData(
                req.toJson(),
              );
        },
      );
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'Provide a location';
                }
              },
              controller: locController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                labelText: 'Location',
              ),
            ),
            SizedBox(height: 16),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: btm),
                  SizedBox(width: 16),
                  Expanded(child: bdm)
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: pickupController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
                labelText: 'Pickup Spot',
              ),
/*              onChanged: (value) {
               this.pickupSpot = value;
             },*/
            ),
            SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.short_text),
                border: OutlineInputBorder(),
                labelText: 'Notes',
              ),
/*              onChanged: (value) {
               this.notes = value;
             },*/
            ),
            //add slider for flexiblity
            SizedBox(height: 16),
            RaisedButton(
              child: Text('SUBMIT'),
              color: Colors.teal,
              textColor: Colors.white,
              onPressed: () {
                addUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyStatefulWidget(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OfferObj {
  String location;
  String car;
  String time;
  String date;
  String numberOfSeats;
  String notes;
  String usermail;
  int usernumber;
  String username;

  DocumentReference reference;

  OfferObj(
      {this.location,
      this.car,
      this.time,
      this.date,
      this.numberOfSeats,
      this.notes,
      this.usermail,
      this.usernumber,
      this.username});

  /* RequestObj.fromMap(Map<String, dynamic> map, {this.reference}) {
   name = map["name"];
 }

 RequestObj.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);*/

  toJson() {
    return {
      'location': location,
      'car': car,
      'time': time,
      'date': date,
      'seats': numberOfSeats,
      'notes': notes,
      'usermail': usermail,
      'usernumber': usernumber,
      'username': username,
    };
  }
}

class CreateOffer extends StatelessWidget {
  TextEditingController locController = TextEditingController();
  TextEditingController carController = TextEditingController();
  TextEditingController seatsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  // date and time widgets
  BasicTimeField btm = BasicTimeField();
  BasicDateField bdm = BasicDateField();

  addOfferUser() {
    OfferObj off = OfferObj(
      location: locController.text,
      car: carController.text,
      time: btm.getController().text,
      date: bdm.getController().text,
      numberOfSeats: seatsController.text,
      notes: notesController.text,
      usermail: LoginPage.emailAddress,
      usernumber: LoginPage.phoneNumber,
      username: LoginPage.userName,
    );
    try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance.collection(offCollection).document().setData(
                off.toJson(),
              );
        },
      );
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'Provide an location';
                }
              },
              controller: locController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                labelText: 'Location',
              ),
            ),
            SizedBox(height: 16),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: btm),
                  SizedBox(width: 16),
                  Expanded(child: bdm)
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: carController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.directions_car),
                border: OutlineInputBorder(),
                labelText: 'Car Model (Optional)',
              ),
            ),
            SizedBox(height: 16),
            TextField(
                controller: seatsController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.event_seat),
                  border: OutlineInputBorder(),
                  labelText: 'Number Of Seats',
                ),
                keyboardType: TextInputType.number),
            SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.short_text),
                border: OutlineInputBorder(),
                labelText: 'Notes',
              ),
            ),
            SizedBox(height: 16),
            RaisedButton(
              child: Text('SUBMIT'),
              color: Colors.teal,
              textColor: Colors.white,
              onPressed: () {
                addOfferUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyStatefulWidget(),
                  ),
                );
              },
              onLongPress: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BasicTimeField extends StatelessWidget {
  TextEditingController tec = TextEditingController();
  final format = DateFormat("hh:mm a");
  TextEditingController getController() {
    return tec;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        controller: tec,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.access_time),
          border: OutlineInputBorder(),
          labelText: 'Time',
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
              currentValue ?? DateTime.now(),
            ),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController tec = TextEditingController();
  TextEditingController getController() {
    return tec;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DateTimeField(
          controller: tec,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.date_range),
            border: OutlineInputBorder(),
            labelText: 'Date',
          ),
          format: format,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100),
            );
          },
        ),
      ],
    );
  }
}
