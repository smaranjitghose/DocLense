import 'package:doclense/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintainersSection extends StatefulWidget {
  const MaintainersSection({Key? key}) : super(key: key);

  @override
  State<MaintainersSection> createState() => _MaintainersSectionState();
}

class _MaintainersSectionState extends State<MaintainersSection> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: const ScreenBreakpoints(
          tablet: 768,
          desktop: 1020,
          watch: 300
      ),
      builder: (context, sizingInformation){
        if(sizingInformation.deviceScreenType == DeviceScreenType.desktop){
          return Container(
              padding: MediaQuery.of(context).size.width <= 1024 ? const EdgeInsets.symmetric(horizontal: 10) : EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1445),
              height: MediaQuery.of(context).size.height ,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffFDB36E),
                      Color(0xffF68080),
                    ],
                  )
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: const SelectableText(
                      'Get the App!',
                      style: TextStyle(
                          color: Color(0xff080F35),
                          fontSize: 38
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: Image.asset('assets/images/google-play-badge.png' , scale: 2,),
                          onTap: () async {
                            if (!await launch('https://play.google.com/store/apps/details?id=com.anushbhatia.doclense&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1')) {
                              throw 'Count not launch https://play.google.com/store/apps/details?id=com.anushbhatia.doclense&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1';
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xffFCF0D0)),
                          ),
                          onPressed: () async {
                            if (!await launch('https://github.com/smaranjitghose/DocLense')) throw 'Count not launch https://github.com/smaranjitghose/DocLense';
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                            child: Row(
                              children: [
                                Image.asset('assets/images/github_logo_black.png' , scale: 4,),
                                const SizedBox(width: 20,),
                                const Text(
                                  'Repository',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 36
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 3,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 45),
                    child: const SelectableText(
                      'Project Maintainers',
                      style: TextStyle(
                          color: Color(0xff080F35),
                          fontSize: 38
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:  [
                        ProfileCard(
                          image: 'assets/images/smaranjit_ghose.png',
                          name: 'Smaranjit Ghose',
                          website: 'https://smaranjitghose.com/',
                          linkedin: 'https://www.linkedin.com/in/smaranjitghose/',
                          github: 'https://github.com/smaranjitghose',
                        ),
                        ProfileCard(
                          image: 'assets/images/anush_bhatia.png',
                          name: 'Anush Bhatia',
                          linkedin: 'https://www.linkedin.com/in/anushbhatia/',
                          github: 'https://github.com/anushbhatia',
                        ),
                      ],
                    ),
                  ),
                ],
              )
          );
        }
        return Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffFDB36E),
                    Color(0xffF68080),
                  ],
                )
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: const SelectableText(
                    'Get the App!',
                    style: TextStyle(
                        color: Color(0xff080F35),
                        fontSize: 30
                    ),
                  ),
                ),
                InkWell(
                  child: Image.asset('assets/images/google-play-badge.png' , scale: 3,),
                  onTap: () async {
                    if (!await launch('https://play.google.com/store/apps/details?id=com.anushbhatia.doclense&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1')) {
                      throw 'Count not launch https://play.google.com/store/apps/details?id=com.anushbhatia.doclense&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1';
                    }
                  },
                ),
                SizedBox(
                  width: 192,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color(0xffFCF0D0)),
                    ),
                    onPressed: () async {
                      if (!await launch('https://github.com/smaranjitghose/DocLense')) throw 'Count not launch https://github.com/smaranjitghose/DocLense';
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/github_logo_black.png' , scale: 5,),
                          const SizedBox(width: 10,),
                          const Text(
                            'Repository',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Divider(
                    color: Colors.white,
                    thickness: 3,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: const SelectableText(
                    'Project Maintainers',
                    style: TextStyle(
                        color: Color(0xff080F35),
                        fontSize: 30
                    ),
                  ),
                ),
                Container(
                  margin:   EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.3, 40, MediaQuery.of(context).size.width * 0.3, 0),
                  child: Column(
                    children:  [
                      ProfileCard(
                        image: 'assets/images/smaranjit_ghose.png',
                        name: 'Smaranjit Ghose',
                        website: 'https://smaranjitghose.com/',
                        linkedin: 'https://www.linkedin.com/in/smaranjitghose/',
                        github: 'https://github.com/smaranjitghose',
                      ),
                      ProfileCard(
                        image: 'assets/images/anush_bhatia.png',
                        name: 'Anush Bhatia',
                        linkedin: 'https://www.linkedin.com/in/anushbhatia/',
                        github: 'https://github.com/anushbhatia',
                      ),
                    ],
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}
