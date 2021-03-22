import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactDeveloperScreen extends StatelessWidget {
  final double spacing = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      "TEAM",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: const Text(
                        "2021",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          // color: Colors.orange[900],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                alignment: Alignment.topCenter,
                child: const Text(
                  "Presenting The Team",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              _buildTeamTitle('DEVELOPERS'),
              Container(
                height: 170,
                margin: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: devTeam.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        _buildprofileImage(devTeam[index]["imgPath"]),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                devTeam[index]["name"],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 5)),
                              Row(
                                children: <Widget>[
                                  _buildProfileIcon(devTeam[index]["linkedin"],
                                      'https://img.icons8.com/fluent/48/000000/linkedin-circled.png'),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  _buildProfileIcon(devTeam[index]["github"],
                                      'https://img.icons8.com/fluent/50/000000/github.png'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildTeamTitle('CONTIBUTORS'),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildprofileImage(String imagePath) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        boxShadow: _buildBoxShadow,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 100,
        height: 100,
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: _buildBoxShadow,
            color: Colors.black,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildProfileIcon(String link, String iconUrl) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        boxShadow: _buildBoxShadow,
        shape: BoxShape.circle,
      ),
      child: RawMaterialButton(
        shape: const CircleBorder(),
        elevation: 10,
        onPressed: () async {
          await _launchURL(link);
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(iconUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> get _buildBoxShadow => [
        BoxShadow(
          offset: const Offset(0.00, 3.00),
          color: const Color(0xff000000).withOpacity(0.16),
          blurRadius: 6,
        ),
      ];

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }
}

List<Map<String, String>> devTeam = [
  {
    "imgPath": 'assets/images/team/smaranjit_ghose.png',
    "name": "Smaranjit Ghose",
    "linkedin": "https://www.linkedin.com/in/smaranjitghose/",
    "github": "https://github.com/smaranjitghose",
  },
  {
    "imgPath": "assets/images/team/anush_bhatia.png",
    "name": "Anush Bhatia",
    "linkedin": "https://www.linkedin.com/in/anush-bhatia-aa500a158/",
    "github": "https://github.com/anushbhatia",
  },
];
