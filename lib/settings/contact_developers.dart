import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactDeveloperScreen extends StatelessWidget {
  final double spacing = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing),
                const Text(
                  'CONTACT US',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProfile(
                      imagePath: 'assets/images/team/smaranjit_ghose.png',
                      name: 'Smaranjit Ghose',
                      githubUrl: 'smaranjitghose',
                      linkedInUrl: 'smaranjitghose',
                    ),
                    _buildProfile(
                      imagePath: 'assets/images/team/anush_bhatia.png',
                      name: 'Anush Bhatia',
                      githubUrl: 'anushbhatia',
                      linkedInUrl: 'anushbhatia',
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                const Text(
                  'CONTRIBUTORS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile({
    @required String imagePath,
    @required String name,
    @required String githubUrl,
    @required String linkedInUrl,
  }) {
    const double height = 12;
    const double textSize = 18;

    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              )),
        ),
        const SizedBox(height: height),
        Text(
          name,
          style: const TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: height),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _profileLinks(
              'Github',
              'https://github.com/$githubUrl',
              FontAwesomeIcons.githubSquare,
            ),
            const SizedBox(width: 40),
            _profileLinks(
              'LinkedIn',
              'https://www.linkedin.com/in/$linkedInUrl',
              FontAwesomeIcons.linkedin,
            ),
          ],
        ),
      ],
    );
  }

  Widget _profileLinks(String text, String link, IconData icon) => InkWell(
      onTap: () => _launchURL(link),
      child: FaIcon(
        icon,
        size: 40,
      ));

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }
}
