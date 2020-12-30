import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        title: Text(
          "About App",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      leading: IconButton(icon: Image.asset('assets/images/scanlogo.png'),
                onPressed: () {},), 
      backgroundColor: Colors.blue[50],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: Text(
              "DocLense is the one place for all your documents. \nYou can now click, upload, crop, rotate and do so much more!\n\nSo whether it is your college assignment or the office document you want to digitalize, stop worrying and just use DocLense!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 200,
          ),
          Row(
            
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text(
                  "Made with ❤ by Open Source",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
