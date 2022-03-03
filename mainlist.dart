import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:trails_pool_go/pages/setup/sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'main.dart';

class CreateList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RequestListPage(),
    );
  }
}

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  Future _data;
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection(reqCollection).getDocuments();
    return qn.documents;
  }

  navigateToRequestDetails(DocumentSnapshot requests) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestDetailsPage(
          requests: requests,
        ),
      ),
    );
  }

  DateTime yesterday() {
    var now = DateTime.now();
    DateTime yesterday = now.subtract(
      const Duration(days: 1),
    );
    return yesterday;
  }

  bool checkExpiredDate(String date) {
    if (date != "") {
      return yesterday().isAfter(
        DateTime.parse(date),
      )
          ? true
          : false;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _data = getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _data,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitDoubleBounce(
                color: Colors.teal,
                size: 50.0,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: double.maxFinite,
                  child: Flexible(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.teal[100],
                        onTap: () =>
                            navigateToRequestDetails(snapshot.data[index]),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                snapshot.data[index]
                                    .data()["username"]
                                    .toUpperCase(),
                                style:
                                    TextStyle(fontSize: 12, letterSpacing: 1.5),
                              ),
                              SizedBox(height: 6),
                              Flexible(
                                child: Text(
                                  "Ride To " +
                                      snapshot.data[index].data()["location"],
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 1),
                              SizedBox(height: 12),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time_outlined,
                                        color: checkExpiredDate(snapshot
                                                .data[index]
                                                .data()['date'])
                                            ? Colors.red
                                            : Colors.grey),
                                    Text(
                                      "   " +
                                          snapshot.data[index].data()["time"] +
                                          ", " +
                                          snapshot.data[index].data()['date'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: checkExpiredDate(snapshot
                                                  .data[index]
                                                  .data()['date'])
                                              ? Colors.red
                                              : Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.home_outlined,
                                        color: Colors.grey),
                                    Text(
                                      "   " +
                                          snapshot.data[index]
                                              .data()["pickupSpot"],
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.short_text_outlined,
                                        color: Colors.grey),
                                    Flexible(
                                      child: Text(
                                        "   " +
                                            snapshot.data[index]
                                                .data()["notes"],
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              if (snapshot.data[index].data()["usermail"] ==
                                  LoginPage.emailAddress)
                                OutlinedButton(
                                  onPressed: () {
                                    print(
                                      "deleting document" +
                                          snapshot.data[index].reference
                                              .toString(),
                                    );
                                    Firestore.instance.runTransaction(
                                      (Transaction myTransaction) {
                                        myTransaction.delete(
                                            snapshot.data[index].reference);
                                      },
                                    );
                                  },
                                  child: Text("Delete Offer"),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class RequestDetailsPage extends StatefulWidget {
  final DocumentSnapshot requests;
  RequestDetailsPage({this.requests});
  @override
  _RequestDetailsPageState createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Offer'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 32, 8, 32),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Flexible(
                child: Text(
                  'Ride to ' + widget.requests.data()['location'],
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Ride Details:",
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Date & Time: " +
                    widget.requests.data()['time'] +
                    " on " +
                    widget.requests.data()['date'],
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Pickup Spot: " + widget.requests.data()['pickupSpot'],
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Requested by: " + widget.requests.data()['username'],
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.requests.data()['username'] +
                    "'s Phone Number: " +
                    widget.requests.data()['usernumber'].toString(),
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.requests.data()['username'] +
                    "'s Notes (If provided): " +
                    widget.requests.data()['notes'],
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        splashColor: Colors.green[200],
                        onPressed: () {
                          final number = widget.requests
                                  .data()['usernumber']
                                  .toString(),
                              url = 'https://wa.me//+91' + number;
                          launch(url);
                        },
                        child: Expanded(
                          child: Text(
                            'Contact via WhatsApp',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                            color: Color(0xff25D366),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: FlatButton(
                        onPressed: () {
                          final mail = widget.requests.data()['usermail'],
                              url = 'mailto:' + mail;
                          launch(url);
                        },
                        child: Icon(Icons.mail_outline),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: FlatButton(
                        onPressed: () {
                          final number = widget.requests
                                  .data()['usernumber']
                                  .toString(),
                              url = 'tel:' + number;
                          launch(url);
                        },
                        child: Icon(Icons.phone_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              FlatButton(
                onPressed: () {
                  final Event event = Event(
                    title: 'Ride to ' + widget.requests.data()['location'],
                    description: 'Ride to ' +
                        widget.requests.data()['location'] +
                        "Date & Time: " +
                        widget.requests.data()['time'] +
                        " on " +
                        widget.requests.data()['date'] +
                        "\n\n" +
                        widget.requests.data()['notes'],
                    location: widget.requests.data()['pickupSpot'],
                    timeZone: 'IST',
                    startDate: DateTime.parse(widget.requests.data()['date'])
                        .toLocal(),
                    endDate: DateTime.parse(widget.requests.data()['date'])
                        .toLocal(),
                  );
                  Add2Calendar.addEvent2Cal(event);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Add to Calandar',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfferListPage extends StatefulWidget {
  @override
  _OfferListPageState createState() => _OfferListPageState();
}

class _OfferListPageState extends State<OfferListPage> {
  Future _data;
  Future getOfferPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection(offCollection).getDocuments();
    return qn.documents;
  }

  navigateToOfferDetails(DocumentSnapshot offers) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferDetailsPage(
          offers: offers,
        ),
      ),
    );
  }

  DateTime yesterday() {
    var now = DateTime.now();
    DateTime yesterday = now.subtract(
      const Duration(days: 1),
    );
    return yesterday;
  }

  bool checkExpiredDate(String date) {
    if (date != "") {
      return yesterday().isAfter(
        DateTime.parse(date),
      )
          ? true
          : false;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _data = getOfferPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _data,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitPulse(
                color: Colors.teal,
                size: 50.0,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: double.maxFinite,
                  child: Flexible(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.teal[100],
                        onTap: () =>
                            navigateToOfferDetails(snapshot.data[index]),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                snapshot.data[index]
                                    .data()["username"]
                                    .toUpperCase(),
                                style:
                                    TextStyle(fontSize: 12, letterSpacing: 1.5),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Ride To " +
                                    snapshot.data[index].data()["location"],
                                style: TextStyle(fontSize: 24),
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 1),
                              SizedBox(height: 12),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time_outlined,
                                        color: checkExpiredDate(snapshot
                                                .data[index]
                                                .data()['date'])
                                            ? Colors.red
                                            : Colors.grey),
                                    Text(
                                      "   " +
                                          snapshot.data[index].data()["time"] +
                                          ", " +
                                          snapshot.data[index].data()['date'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: checkExpiredDate(snapshot
                                                  .data[index]
                                                  .data()['date'])
                                              ? Colors.red
                                              : Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.directions_car_outlined,
                                        color: Colors.grey),
                                    Text(
                                      "   " +
                                          snapshot.data[index].data()["car"],
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Flexible(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.event_seat_outlined,
                                          color: Colors.grey),
                                      Text(
                                        "   " +
                                            snapshot.data[index]
                                                .data()["seats"] +
                                            " seats available",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              if (snapshot.data[index].data()["usermail"] ==
                                  LoginPage.emailAddress)
                                OutlinedButton(
                                  onPressed: () {
                                    print(
                                      "deleting document" +
                                          snapshot.data[index].reference
                                              .toString(),
                                    );
                                    Firestore.instance.runTransaction(
                                      (Transaction myTransaction) {
                                        myTransaction.delete(
                                            snapshot.data[index].reference);
                                      },
                                    );
                                  },
                                  child: Text("Delete Request"),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class OfferDetailsPage extends StatefulWidget {
  final DocumentSnapshot offers;
  OfferDetailsPage({this.offers});
  @override
  _OfferDetailsPageState createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Offer'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 52, 8, 32),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Text(
                'Ride to ' + widget.offers.data()['location'],
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Ride Details:",
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Date & Time: " +
                  widget.offers.data()['time'] +
                  " on " +
                  widget.offers.data()['date'],
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Car Model: " + widget.offers.data()['car'],
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Seats Available: " + widget.offers.data()['seats'],
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Offered by: " + widget.offers.data()['username'],
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.offers.data()['username'] +
                  "'s Phone Number: " +
                  widget.offers.data()['usernumber'].toString(),
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.offers.data()['username'] +
                  "'s Notes (If provided): " +
                  widget.offers.data()['notes'],
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      splashColor: Colors.green[100],
                      onPressed: () {
                        final number =
                                widget.offers.data()['usernumber'].toString(),
                            url = 'https://wa.me//+91' + number;
                        launch(url);
                      },
                      child: Expanded(
                        child: Text(
                          'Contact via WhatsApp',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Color(0xff25D366),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: FlatButton(
                      onPressed: () {
                        final mail = widget.offers.data()['usermail'],
                            url = 'mailto:' + mail;
                        launch(url);
                      },
                      child: Icon(Icons.mail_outlined),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: FlatButton(
                      onPressed: () {
                        final number =
                                widget.offers.data()['usernumber'].toString(),
                            url = 'tel:' + number;
                        launch(url);
                      },
                      child: Icon(Icons.phone_outlined),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            FlatButton(
              onPressed: () {
                final date = DateTime.parse(
                  widget.offers.data()['date'],
                );
                print(date);
                final Event event = Event(
                  title: 'Ride to ' + widget.offers.data()['location'],
                  description: 'Ride to ' +
                      widget.offers.data()['location'] +
                      "Date & Time: " +
                      widget.offers.data()['time'] +
                      " on " +
                      widget.offers.data()['date'] +
                      "\n\n" +
                      widget.offers.data()['notes'],
                  location: widget.offers.data()['location'],
                  startDate: DateTime.parse(widget.offers.data()['date']),
                  endDate: DateTime.parse(widget.offers.data()['date']),
                );
                Add2Calendar.addEvent2Cal(event);
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Add to Calandar',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(
                  color: Colors.blue[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateOfferList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: OfferListPage(),
    );
  }
}
