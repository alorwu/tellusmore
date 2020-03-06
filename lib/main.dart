import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

import ".env.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TellusMore Mailer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TellusMore Mailer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String email = "";
  final emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isBtnDisabled = false;

  /// Method to send email to remote server
  Future<String> saveEmail() async {
    var res = await http.post(
      environment['baseUrl'],
      body: {
        'email': email
      }
    );
    return res.body;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "THANK YOU",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 50.0, color: Colors.black),
            ),
            titlePadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            content: new RichText(
              text: new TextSpan(
                  children: <TextSpan> [
                    new TextSpan(text: "We’re currently sending you an important welcome email. Please check your "),
                    new TextSpan(text: "SPAM", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red)),
                    new TextSpan(text: " folder, too!"),
                ],
                style: new TextStyle(fontWeight: FontWeight.w400, fontSize: 35.0, color: Colors.black),
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close", style: TextStyle(fontSize: 25.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isBtnDisabled = false;
                  });
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: formBody(),
      ),
    );
  }

  formBody() => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[formHeader(), emailField()],
    ),
  );

  formHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      SizedBox(
        height: 60.0,
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          "images/tellusmorelogo.png",
          fit: BoxFit.fill,
        ),
      ),
      SizedBox(
        height: 50.0,
      ),
      Text(
        "LEARN MORE ABOUT TELLUSMORE",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue, fontSize: 75.0),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        child: Text(
          "TellusMore is a new community-powered initiative that will empower the University of Oulu community to create science together! Sign up below for a short email on how you can help and what’s in it for you.",
          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 35.0),
          textAlign: TextAlign.center,
        ),
      ),

      SizedBox(
        height: 20.0,
      )
    ],
  );

  emailField() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
          child: TextField(
            controller: emailController,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter your email",
              labelText: "Email",
              hintStyle: TextStyle(fontSize: 30.0),
              labelStyle: TextStyle(fontSize: 30.0),
            ),
            onChanged: (String str) {
              setState(() {
                email = str;
              });
            },
            style: TextStyle(fontSize: 50.0),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
            shape: StadiumBorder(),
            child: Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
            color: Colors.blue,
            onPressed: _isBtnDisabled ? null : () async {
              try {
                setState(() {
                  _isBtnDisabled = true;
                });
                final result = await InternetAddress.lookup('example.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  String res = await saveEmail();
                  if (res == "success") {
                    emailController.clear();
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text("Email received. Thank you!"),
                        duration: new Duration(seconds: 5),
                        backgroundColor: Colors.green,
                      )
                    );
                    _showDialog();
                  } else {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text("Error saving email. Try again."),
                        duration: new Duration(seconds: 5),
                        backgroundColor: Colors.red,
                      )
                    );
                  }
                }
              } on SocketException catch (_) {
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: new Text("No internet access. Try again."),
                      duration: new Duration(seconds: 5),
                      backgroundColor: Colors.black,
                    )
                );
              }
            },
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
          child: Text(
            "We will not share your email address with anyone. No SPAM.",
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 15.0),
          ),
        ),
      ],
    ),
  );
}
