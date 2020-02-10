import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TellUsMore'),
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
    http.Response response = await http.post('https://tellusmore.fi/api/sendinfoemail.php', body:{'email', email});
    return response.body;
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
          "images/tellus.png",
          height: 200.0,
          width: 200.0,
          fit: BoxFit.fill,
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        "Welcome to TellusMore",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue, fontSize: 90.0),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        "Volunteer to promote University of Oulu research",
        style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 50.0),
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
            "Your privacy is our policy.",
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 15.0),
          ),
        ),
      ],
    ),
  );
}
