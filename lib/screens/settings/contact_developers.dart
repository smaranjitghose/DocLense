// ignore_for_file: avoid_dynamic_calls

import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/constants/assets.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:http/http.dart" as http;
import "package:url_launcher/url_launcher.dart";

class ContactDeveloperScreen extends StatefulWidget {
  const ContactDeveloperScreen({super.key});

  @override
  ContactDeveloperScreenState createState() => ContactDeveloperScreenState();
}

class ContactDeveloperScreenState extends State<ContactDeveloperScreen> {
  List<dynamic> jsonContributors = <dynamic>[];

  int year = 2021;

  Future<void> _fetchContributors() async {
    try {
      const String contributorsAPIUrl =
          "https://api.github.com/repos/smaranjitghose/DocLense/contributors";
      final http.Response response =
          await http.get(Uri.parse(contributorsAPIUrl));

      if (response.statusCode == 200) {
        setState(() {
          jsonContributors = json.decode(response.body) as List<dynamic>;
        });
      } else {
        await Fluttertoast.showToast(
          msg: "Failed to load Contributors from API",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_fetchContributors());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _isLoading
            ? const SpinKitRotatingCircle(
                color: Colors.blue,
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Space.y2!,
                      Text(
                        "${S.team.toUpperCase()} $year",
                        style: AppText.h4b,
                      ),
                      Space.y!,
                      Text(
                        S.presentingTeam,
                        style: AppText.b2,
                      ),
                      const _TeanTitle(title: S.developers),
                      Container(
                        height: AppDimensions.normalize(75),
                        margin: EdgeInsets.only(top: AppDimensions.height(3)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: devTeam.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                            margin: Space.h1,
                            child: Column(
                              children: <Widget>[
                                _buildprofileImage(devTeam[index]["imgPath"]!),
                                Space.y1!,
                                Text(
                                  devTeam[index]["name"]!,
                                  style: AppText.l1,
                                ),
                                Space.y1!,
                                Row(
                                  children: <Widget>[
                                    _buildProfileIcon(
                                      devTeam[index]["linkedin"]!,
                                      Assets.linkedinIcon,
                                    ),
                                    Space.x!,
                                    _buildProfileIcon(
                                      devTeam[index]["github"]!,
                                      Assets.githubIcon,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const _TeanTitle(title: S.contributors),
                      if (jsonContributors.isNotEmpty)
                        Container(
                          height: AppDimensions.normalize(75),
                          margin: EdgeInsets.only(top: AppDimensions.height(3)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: jsonContributors.length,
                            itemBuilder: (BuildContext context, int index) =>
                                (jsonContributors[index]["login"].toString() ==
                                            "smaranjitghose" ||
                                        jsonContributors[index]["login"]
                                                .toString() ==
                                            "anushbhatia")
                                    ? Container()
                                    : Container(
                                        margin: Space.h1,
                                        child: Column(
                                          children: <Widget>[
                                            _buildNetworkprofileImage(
                                              jsonContributors[index]
                                                      ["avatar_url"]
                                                  .toString(),
                                            ),
                                            Space.y1!,
                                            Text(
                                              jsonContributors[index]["login"]
                                                  .toString(),
                                              style: AppText.l1,
                                            ),
                                            Space.y1!,
                                            Row(
                                              children: <Widget>[
                                                if (jsonContributors[index]
                                                            ["login"]
                                                        .toString() ==
                                                    "Saransh-cpp")
                                                  _buildProfileIcon(
                                                    "https://www.linkedin.com/in/saransh-chopra-3a6ab11bb",
                                                    "https://img.icons8.com/fluent/48/000000/linkedin-circled.png",
                                                  )
                                                else if (jsonContributors[index]
                                                            ["login"]
                                                        .toString() ==
                                                    "nicks101")
                                                  _buildProfileIcon(
                                                    "https://www.linkedin.com/in/nikki-goel-449563159/",
                                                    "https://img.icons8.com/fluent/48/000000/linkedin-circled.png",
                                                  )
                                                else
                                                  Container(),
                                                Space.x!,
                                                _buildProfileIcon(
                                                  jsonContributors[index]
                                                          ["html_url"]
                                                      .toString(),
                                                  "https://img.icons8.com/fluent/50/000000/github.png",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                          ),
                        )
                      else
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
      );

  Widget _buildprofileImage(String imagePath) => Container(
        width: AppDimensions.normalize(40),
        height: AppDimensions.normalize(40),
        decoration: BoxDecoration(
          boxShadow: _buildBoxShadow,
          shape: BoxShape.circle,
        ),
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
      );

  Widget _buildNetworkprofileImage(String imagePath) => Container(
        width: AppDimensions.normalize(40),
        height: AppDimensions.normalize(40),
        decoration: BoxDecoration(
          boxShadow: _buildBoxShadow,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: AppDimensions.normalize(40),
          height: AppDimensions.normalize(40),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: _buildBoxShadow,
              color: Colors.black,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );

  Widget _buildProfileIcon(String link, String iconUrl) => Container(
        width: AppDimensions.normalize(15),
        height: AppDimensions.normalize(15),
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
            width: AppDimensions.normalize(40),
            height: AppDimensions.normalize(40),
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

  List<BoxShadow> get _buildBoxShadow => <BoxShadow>[
        BoxShadow(
          offset: const Offset(0, 3),
          color: const Color(0xff000000).withOpacity(0.16),
          blurRadius: 6,
        ),
      ];

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Could not launch $url");
      // throw "Could not launch $url";
    }
  }
}

class _TeanTitle extends StatelessWidget {
  const _TeanTitle({
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.zero.t(AppDimensions.font(0.4)),
        alignment: Alignment.center,
        child: Text(
          title.toUpperCase(),
          style: AppText.b2b,
        ),
      );
}

List<Map<String, String>> devTeam = <Map<String, String>>[
  <String, String>{
    "imgPath": "assets/images/team/smaranjit_ghose.png",
    "name": "Smaranjit Ghose",
    "linkedin": "https://www.linkedin.com/in/smaranjitghose/",
    "github": "https://github.com/smaranjitghose",
  },
  <String, String>{
    "imgPath": "assets/images/team/anush_bhatia.png",
    "name": "Anush Bhatia",
    "linkedin": "https://www.linkedin.com/in/anush-bhatia-aa500a158/",
    "github": "https://github.com/anushbhatia",
  },
];
