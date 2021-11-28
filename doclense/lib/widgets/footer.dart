import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        color: const Color(0xff1E243C),
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width <= 375 ? 0 : MediaQuery.of(context).size.width * 0.1445),
        child: Row(
          children: [
            Image.asset('assets/images/logo_white.png' , scale: 3,),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Made with ',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white
                    ),
                  ),
                  Icon(CupertinoIcons.heart_fill ,color: Colors.red,)
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                if (!await launch('https://github.com/smaranjitghose/DocLense')) throw 'Count not launch https://github.com/smaranjitghose/DocLense';
              },
              icon: Image.asset('assets/images/github_logo_white.png',), iconSize: 40,)
          ],
        ),
      ),
    );
  }
}
