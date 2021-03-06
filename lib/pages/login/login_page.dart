import 'dart:async';

import 'package:flutter/material.dart';
import 'package:touristguide/pages/login/userprofile.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:touristguide/component/getImage.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // var _unctrl = new TextEditingController();
  var _username;
  String tid;
  var _password;
  bool _loginStatus;
  int count;

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _fetchData() async {
    setState(() {
      _loginStatus = null;
    });

    String username = _username;
    String password = _password;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    //print(basicAuth);

    final url = "http://192.168.13.168:8090/login";
    try {
      final response = await http.get(url, headers: {
        HttpHeaders.AUTHORIZATION: basicAuth,
        HttpHeaders.CONTENT_TYPE: 'application/json'
      });

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        //final user = responseJson['id'];

        setState(() {
          tid = responseJson.toString();

          //this._loginStatus = "Successfully Logged In";
          this._loginStatus = true;
        });

        //print(_tst);
        print(responseJson);
      } else {
        print(response.body);
        setState(() {
          /* this._loginStatus =
              'Error getting response:\nHttp status ${response.body}'; */
          this._loginStatus = false;
        });
      }

      //print(map["List"]);

    } catch (exception) {
      setState(() {
        // this._loginStatus = "Failed parsing response because of: $exception";
        this._loginStatus = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: getImage("https://bit.ly/2OR2OhK"),
      ),
    );

    final email = new TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (String string) {
        _username = string;
      },
    );

    final password = new TextField(
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (String string) {
        _password = string;
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            _fetchData();

            if (_loginStatus == true) {
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new UserProfile(uname: tid),
              );
              Navigator.of(context).push(route);
            }
          },
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
