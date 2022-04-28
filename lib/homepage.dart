import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:drip/pages/common/hot_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:intl/intl.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as acrylic;
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'music.dart';
import 'package:intl/intl.dart';
class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String date = DateFormat('EEEE, d MMM, yyyy').format(DateTime.now());
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
              child: Column(
                children: [
                  DigitalClock(
                    areaDecoration: const BoxDecoration(color: Colors.transparent),
                    areaAligment: AlignmentDirectional.center,
                    hourMinuteDigitDecoration:
                    const BoxDecoration(color: Colors.transparent),
                    hourMinuteDigitTextStyle: const TextStyle(fontSize: 15),
                    showSecondsDigit: false,

                  ),
                ],
              ),
            )
          ],
          backgroundColor:Color(0xff1213b7),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,

          ),
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        SizedBox(
            //ClockCustomizer((ClockModel model) => DigitalClock(model))
          child: Column(
            children: [
              DigitalClock(
                areaDecoration: const BoxDecoration(color: Colors.transparent),

                hourMinuteDigitTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                ),
                hourMinuteDigitDecoration:
                const BoxDecoration(color: Colors.transparent),
                secondDigitTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  ),
                showSecondsDigit: false,
                // secondDigitDecoration:
                // const BoxDecoration(color: Colors.transparent),
              ),
              Text(
                date,
                style: TextStyle(color:Colors.white,fontSize: 20),
              ),
            ],
          ),

        ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                    color: Colors.black,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(28),
                    child: InkWell(
                    onTap: (){
                      start(true);
                      },
                    child: Ink.image(
                                    image:const AssetImage (
                                      'assets/images/music.png'
                                      ),
                                    height: 200,
                                    width: 200,
                                    fit :BoxFit.cover,

                                  ),


                    ),

        ),
                Material(
                  color: Colors.black,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/dashboard');
                    },
                    child: Container(
                      alignment: Alignment.center,// use aligment
                      child: Image.asset(
                        'assets/images/das.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.black,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      alignment: Alignment.center,// use aligment
                      child: Image.asset(
                        'assets/images/location.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ]
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Colors.black,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    onTap: (){

                      Navigator.pushNamed(context, '/settings');
                    },
                    child: Column(
                      children: [
                        Ink.image(
                          image:const AssetImage (
                              'assets/images/settings.png'
                          ),
                          height: 200,
                          width: 200,
                          fit: BoxFit.fitWidth,

                        ),
                        // Text(
                        //   'Settings',
                        //   style:TextStyle(fontSize: 32, color: Colors.white),
                        // ),
                      ],
                    ),
                  ),
                ),
                Material(
                  color: Colors.black,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    onTap: (){},


                    child: Column(
                      children: [
                        Ink.image(
                          image:const AssetImage (
                              'assets/images/phone.png'
                          ),
                          height: 200,
                          width: 200,
                          fit :BoxFit.cover,

                        ),
                        // Text(
                        //   'Music Player',
                        //   style:TextStyle(fontSize: 32, color: Colors.white),
                        // ),
                      ],
                    ),
                  ),
                ),
                Material(
                  color: Colors.black,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/ac');
                    },


                    child: Column(
                      children: [
                        Ink.image(
                          image:const AssetImage (
                              'assets/images/ac.png'
                          ),
                          height: 200,
                          width: 200,


                        ),
                        // Text(
                        //   'Music Player',
                        //   style:TextStyle(fontSize: 32, color: Colors.white),
                        // ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

          ],
        ),
      );
  }
}
