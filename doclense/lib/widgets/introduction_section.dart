import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1445),
      color: const Color(0xff080F35),
      child: Column(
        children:  [
          // const CustomNavigationBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 145, 0, 50),
                    child: const SelectableText(
                        'doclense',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: RichText(
                        text: const TextSpan(
                          text: 'The',
                          style: TextStyle(
                            color: Colors.white,
                                fontSize: 40,
                          ),
                          children: [
                            TextSpan(
                              text: ' Open Source ',
                              style: TextStyle(
                                color: Color(0xff1F9FFF),
                                  fontSize: 40
                              ),
                            ),
                            TextSpan(
                              text: 'Document Scanner made in India for the world',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40
                              ),
                            ),
                          ]
                    )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 85),
                    child: const SelectableText(
                        'Scan your documents with ease!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28
                      ),
                    ),
                  ),
                  InkWell(
                    child: Image.asset('assets/images/google-play-badge.png' , scale: 2,),
                    onTap: () async {
                      if (!await launch('https://play.google.com/store/apps/details?id=com.anushbhatia.doclense&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1')) {
                        throw 'Count not launch https://play.google.com/store/apps/details?id=com.anushbhatia.doclense&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1';
                      }
                    },
                  ),
                ],
              ),
              Image.asset('assets/images/logo_blue.png' ,scale: 4,)
            ],
          ),

        ],
      ),
    );
  }
}
