import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slide_digital_clock/slide_digital_clock.dart';

class AcPage extends StatefulWidget {


  @override
  State<AcPage> createState() => _AcPageState();
}

class _AcPageState extends State<AcPage> {
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);}

  @override
  Widget build(BuildContext context) {

    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    return Scaffold(
      primary: !isLandscape,
      backgroundColor:  Colors.black,
      // backgroundColor:Color(0xFF0F0F11),

      appBar: AppBar(
        title: const Text('Juice Mobility'),
        actions: <Widget>[
          SizedBox(
            height:40,
            child: DigitalClock(
              areaDecoration: const BoxDecoration(color: Colors.transparent),
              areaAligment: AlignmentDirectional.center,
              hourMinuteDigitDecoration:
              const BoxDecoration(color: Colors.transparent),
              hourMinuteDigitTextStyle: const TextStyle(fontSize: 15),
              showSecondsDigit: false,

            ),
          )
        ],
        backgroundColor:Color(0xff1213b7),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.black,

        ),
      ),
      body:Center(
        child: Container(
            child:Image.asset("assets/images/acpage.png")),
      ));





  }
}
