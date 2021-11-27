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
        padding:  EdgeInsets.symmetric(vertical: 40 , horizontal: MediaQuery.of(context).size.width <= 768 ? 0 : 50),
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
                textAlign: TextAlign.center,
                style:  TextStyle(
                  color: const Color(0xff1E243C),
                  fontSize: MediaQuery.of(context).size.width <= 768 ? 20 : 32
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(website != '')  IconButton(onPressed: () async {
                  if (!await launch(website!)) throw 'Count not launch $website';
                }, icon: Image.asset('assets/images/link.png') , ),
                if(linkedin != '') IconButton(onPressed: () async {
                  if (!await launch(linkedin!)) throw 'Count not launch $linkedin';
                }, icon: Image.asset('assets/images/linkedin.png') ,),
                if(github != '') IconButton(onPressed: () async {
                  if (!await launch(github!)) throw 'Count not launch $github';
                }, icon: Image.asset('assets/images/github_logo_blue.png') ,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
