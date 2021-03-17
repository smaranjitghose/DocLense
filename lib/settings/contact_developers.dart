import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

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
                Center(
                  child: Wrap(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      _buildProfile(
                        imagePath: 'assets/images/doclense.png',
                        name: 'Smaranjit Ghose',
                        githubUrl: 'smaranjitghose',
                        linkedInUrl: 'smaranjitghose',
                      ),
                      _buildProfile(
                        imagePath: 'assets/images/doclense.png',
                        name: 'Anush Bhatia',
                        githubUrl: 'anushbhatia',
                        linkedInUrl: 'anushbhatia',
                      ),
                    ],
                  ),
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
    const double textSize = 16;

    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: height),
        Text(
          name,
          style: const TextStyle(fontSize: textSize),
        ),
        const SizedBox(height: height),
        _profileLinks('Github', 'https://github.com/$githubUrl'),
        const SizedBox(height: height),
        _profileLinks('LinkedIn', 'https://www.linkedin.com/in/$linkedInUrl'),
      ],
    );
  }

  Widget _profileLinks(String text, String link) {
    return InkWell(
      onTap: () {
        _launchURL(link);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }
}
