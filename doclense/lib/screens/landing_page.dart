import 'package:doclense/widgets/footer.dart';
import 'package:doclense/widgets/introduction_section.dart';
import 'package:doclense/widgets/maintainers_section.dart';
import 'package:doclense/widgets/navigation_bar.dart';
import 'package:doclense/widgets/section_template.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
   LandingPage({Key? key}) : super(key: key);
  List<Widget> pageSections = [
    const IntroductionSection(),
    const SectionTemplate(
      color: Color(0xffF1EADC),
      bodyText: 'Scan a variety of documents!',
      image: 'assets/images/splash_screen_mk.png',
      titlePartOne: 'Digitize ',
      titlePartTwo: 'your Documents',
      titleOneColor: Color(0xff1F9FFF),
      titleTwoColor: Color(0xff080F35),
    ),
    const SectionTemplate(
      color: Color(0xffF1E3DC),
      bodyText: 'Choose from a variety of filters to apply to your documents',
      image: 'assets/images/filter_screen_mk.png',
      titlePartOne: 'Apply ',
      titlePartTwo: 'Filters',
      titleTwoColor: Color(0xff1F9FFF),
      titleOneColor: Color(0xff080F35),
    ),
    const SectionTemplate(
      color: Color(0xffF1EADC),
      bodyText: 'Crop your documents as per need!',
      image: 'assets/images/crop_screen_mk.png',
      titlePartOne: 'Edit ',
      titlePartTwo: 'Documents',
      titleOneColor: Color(0xff1F9FFF),
      titleTwoColor: Color(0xff080F35),
    ),
    const SectionTemplate(
      color: Color(0xffF1DCEB),
      bodyText: 'Share as consolidated documents across multiple formats!',
      image: 'assets/images/share_screen_mk.png',
      titlePartOne: 'Share ',
      titlePartTwo: 'with everybody',
      titleOneColor: Color(0xff1F9FFF),
      titleTwoColor: Color(0xff080F35),
    ),
    const MaintainersSection(),
    const Footer(),
  ];

  @override
  Widget build(BuildContext context) {
    List<bool> hoverWidgets = [false,false];
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          CustomNavigationBar(),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => pageSections[index],
                childCount: pageSections.length
              )
          )
        ],
      ),
    );
  }
}
