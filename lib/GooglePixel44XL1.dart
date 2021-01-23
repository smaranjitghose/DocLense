import 'package:doclense/MainDrawer.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/blend_mask.dart';

class GooglePixel44XL1 extends StatefulWidget {
  GooglePixel44XL1({
    Key key,
  }) : super(key: key);
  @override
  _GooglePixel44XL1State createState() => _GooglePixel44XL1State();
}

class _GooglePixel44XL1State extends State<GooglePixel44XL1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset('assets/images/logos.png', width:200 ,),),
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(329.0, 0.0),
            child: Container(
              width: 1.0,
              height: 11.0,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, 250.0),
            child: Container(
              
              decoration: BoxDecoration(
                image: DecorationImage(
                  
                  image: const AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(39.0, 290.0),
            child: SizedBox(
              width: 328.0,
              height: 286.0,
              child: Text(
                'DocLense is the one place for all your documents..It has some amazing features like you can now click, upload, crop, rotate and do so much more!  \nSo whether it is your college assignment or the office document you want to digitalize we can do it in just one click ',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 20,
                  color: const Color(0xff0c0101),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(-32.9, 430.5),
            child: SizedBox(
              width: 413.0,
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 22,
                    color: const Color(0xff0c0101),
                  ),
                  children: [
                    TextSpan(
                      text: '              \n\n\n\n\n\n\n\n\n                ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'Made with ❤ by Open Source',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(182.0, 535.0),
            child: BlendMask(
              blendMode: BlendMode.multiply,
              child: Container(
                width: 49.0,
                height: 49.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: const AssetImage('assets/images/book.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(-2.0, 30.0),
            child:
                // Adobe XD layer: '1' (shape)
                Container(
              width: 400.0,
              height: 230.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(78.0),
                image: DecorationImage(
                  image: const AssetImage('assets/images/1.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

      
  



    