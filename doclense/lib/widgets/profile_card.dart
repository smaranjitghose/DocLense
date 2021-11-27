import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCard extends StatelessWidget {
  final String image;
  final String name;
  String? website;
  String? linkedin;
  String? github;
  ProfileCard({Key? key , required this.image, required this.name, this.github = '', this.linkedin = '', this.website = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 55 , horizontal: 50),
        decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xff57EBDE),
                Color(0xffAEFB2A),
              ],
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image , scale: 5,),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: SelectableText(
                  name,
                style: const TextStyle(
                  color: Color(0xff1E243C),
                  fontSize: 32
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(website != '')  IconButton(onPressed: () async {
                  if (!await launch(website!)) throw 'Count not launch $website';
                }, icon: Image.asset('assets/images/link.png') , iconSize: 30,),
                if(linkedin != '') IconButton(onPressed: () async {
                  if (!await launch(linkedin!)) throw 'Count not launch $linkedin';
                }, icon: Image.asset('assets/images/linkedin.png') , iconSize: 30,),
                if(github != '') IconButton(onPressed: () async {
                  if (!await launch(github!)) throw 'Count not launch $github';
                }, icon: Image.asset('assets/images/github_logo_blue.png') , iconSize: 30,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
