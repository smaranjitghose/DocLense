import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SectionTemplate extends StatelessWidget {
  final Color color;
  final String titlePartOne;
  final String titlePartTwo;
  final Color titleOneColor;
  final Color titleTwoColor;
  final String bodyText;
  final String image;
  const SectionTemplate({
    Key? key, required this.color,
    required this.bodyText,
    required this.titleOneColor,
    required this.titleTwoColor,
    required this.image,
    required this.titlePartOne,
    required this.titlePartTwo
  }) : super(key: key);

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
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              // height: MediaQuery.of(context).size.height,
              color: color,
              child: Row(
                children: [
                  Flexible(child: Image.asset(image,)),
                  Container(
                    margin: const EdgeInsets.only(top: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RichText(
                            maxLines: 4,
                            text: TextSpan(
                                text: titlePartOne,
                                style: TextStyle(
                                    fontSize: 100,
                                    color: titleOneColor,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 6.0,
                                        color: Color(0xff787878),
                                        offset: Offset(5.0, 3.0),
                                      ),
                                    ]
                                ),
                                children: [
                                  TextSpan(
                                    text: titlePartTwo,
                                    style: TextStyle(
                                        fontSize: 100,
                                        color: titleTwoColor,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 6.0,
                                            color: Color(0xff787878),
                                            offset: Offset(5.0, 3.0),
                                          ),
                                        ]
                                    ),

                                  ),
                                ]
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 46),
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: SelectableText(
                            bodyText,
                            style: const TextStyle(
                                fontSize: 34,
                                color: Color(0xff080F35)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          color: color,
          child: Column(
            children: [
              Image.asset(image, scale: 2,),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RichText(
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        text: TextSpan(
                            text: titlePartOne,
                            style: TextStyle(
                                fontSize: 40,
                                color: titleOneColor,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 6.0,
                                    color: Color(0xff787878),
                                    offset: Offset(5.0, 3.0),
                                  ),
                                ]
                            ),
                            children: [
                              TextSpan(
                                text: titlePartTwo,
                                style: TextStyle(
                                    fontSize: 40,
                                    color: titleTwoColor,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 6.0,
                                        color: Color(0xff787878),
                                        offset: Offset(5.0, 3.0),
                                      ),
                                    ]
                                ),

                              ),
                            ]
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: SelectableText(
                        bodyText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xff080F35)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
