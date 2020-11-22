import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'Home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blue[600]),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   radius: 60,
                //   child: Icon(
                //     Icons.description,
                //     color: Colors.teal,
                //     size: 70,
                //   ),
                // ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/logo scanning.gif'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Text(
                  "DocLense",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              "MADE IN INDIA",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
