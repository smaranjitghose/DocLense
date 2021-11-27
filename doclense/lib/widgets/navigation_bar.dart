import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  List<bool> hoverWidgets = [false,false];
  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
      backgroundColor: const Color(0xff080F35),
      // pinned: true,
      floating: true,
      // snap: true,
      // stretch: true,
      title: Container(
        margin:  EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1445, 15, 0, 15),
        child: InkWell(
          child: Image.asset('assets/images/big_logo_white.png', scale: 12,),
          onTap: (){
          },
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15 , vertical: 15),
          child: InkWell(
            onTap: (){},
            overlayColor: MaterialStateProperty.all(Colors.white10),
            onHover: (value){
              setState(() {
                hoverWidgets[0] = value;
              });
            },
            child: Text(
              'Home',
              style: TextStyle(
                color: hoverWidgets[0] ? const Color(0xff2EFFD2) : Colors.white ,
                  fontSize: 20
              ),
            ),
          ),
        ),
        Container(
          margin:  EdgeInsets.fromLTRB(15, 15, MediaQuery.of(context).size.width * 0.1445, 15),
          child: InkWell(
            overlayColor: MaterialStateProperty.all(Colors.white10),
            onTap: (){
            },
            onHover: (value){
              setState(() {
                hoverWidgets[1] = value;
              });
            },
            child: Text(
              'Download',
              style: TextStyle(
                color: hoverWidgets[1] ? const Color(0xff2EFFD2) : Colors.white ,
                  fontSize: 20
              ),
            ),
          ),
        ),
      ],
    );
  }
}
