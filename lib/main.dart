import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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

  /// Method to send email to remote server
  Future<String> saveEmail() async {
    emailController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          "images/tellusmore.png",
          height: 200.0,
          width: 250.0,
          fit: BoxFit.fill,
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Text(
        "LEARN MORE ABOUT TELLUSMORE",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue, fontSize: 78.0),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        child: Text(
          "TellusMore is a new community-powered initiative that will empower the University of Oulu community to create science together! Sign up below for a short 3-part email series on how you can help and what’s in it for you.",
          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 35.0),
          textAlign: TextAlign.center,
        ),
      ),

      SizedBox(
        height: 10.0,
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
            onPressed: () async {
              await saveEmail();
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
