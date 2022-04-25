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
import 'package:system_theme/system_theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as acrylic;
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'music.dart';
class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // void y_music(bool choice) async {
  //   if(choice){
  //
  //     WidgetsFlutterBinding.ensureInitialized();
  //     if (Platform.isWindows) {
  //       doWhenWindowReady(() {
  //         appWindow.minSize = const Size(540, 540);
  //         appWindow.size = const Size(900, 640);
  //         appWindow.alignment = Alignment.center;
  //         appWindow.show();
  //         appWindow.title = 'Drip';
  //       });
  //
  //       // SystemTheme.accentInstance;
  //     }
  //
  //     setPathUrlStrategy();
  //
  //     if (Platform.isWindows) {
  //       await Hive.initFlutter('Drip');
  //     } else {
  //       await Hive.initFlutter();
  //     }
  //
  //     await openHiveBox('settings');
  //
  //     await openHiveBox('Favorite Songs');
  //     await openHiveBox('cache', limit: true);
  //     DartVLC.initialize();
  //
  //     if (Platform.isWindows) {
  //       await acrylic.Window.initialize();
  //       hotKeyManager.unregisterAll();
  //       await HotKeys.initialize();
  //     }
  //     //await Window.initialize();
  //     //WidgetsFlutterBinding.ensureInitialized();
  //
  //     runApp(const Music());
  //
  //     if (defaultTargetPlatform == TargetPlatform.windows ||
  //         defaultTargetPlatform == TargetPlatform.android ||
  //         kIsWeb) {
  //       darkMode = await SystemTheme.darkMode;
  //       await SystemTheme.accentInstance.load();
  //     } else {
  //       darkMode = true;
  //     }
  //     if (!kIsWeb &&
  //         [TargetPlatform.windows, TargetPlatform.linux]
  //             .contains(defaultTargetPlatform)) {
  //       //await flutter_acrylic.Window.initialize();
  //     }
  //
  //     runApp(const Music());
  //   }else{
  //     return;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
      final Orientation orientation = MediaQuery.of(context).orientation;
      final bool isLandscape = orientation == Orientation.landscape;


      return Scaffold(
        primary: !isLandscape,
        // backgroundColor:Color(0xFF0F0F11),
        backgroundColor:  Colors.black,
        appBar: AppBar(
          title: const Text('Juice Mobility'),
          actions: <Widget>[
            DigitalClock(
              areaDecoration: const BoxDecoration(color: Colors.transparent),
              areaAligment: AlignmentDirectional.center,
              hourMinuteDigitDecoration:
              const BoxDecoration(color: Colors.transparent),
              hourMinuteDigitTextStyle: const TextStyle(fontSize: 15),
              showSecondsDigit: false,

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
          child: DigitalClock(
            areaDecoration: const BoxDecoration(color: Colors.transparent),

            hourMinuteDigitTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
            hourMinuteDigitDecoration:
            const BoxDecoration(color: Colors.transparent),
            secondDigitTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              ),
            secondDigitDecoration:
            const BoxDecoration(color: Colors.transparent),
          ),

        ),git

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
                    onTap: (){},
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
                    onTap: (){},


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
