import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slide_digital_clock/slide_digital_clock.dart';

class MainSettings extends StatefulWidget {


  @override
  State<MainSettings> createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
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
              child: SettingsList(
                    sections: [
                    SettingsSection(
                    title: Text('Common'),
                    tiles: <SettingsTile>[
                    SettingsTile.navigation(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    value: Text('English'),
                    ),
                    SettingsTile.switchTile(
                    onToggle: (value) {},
                    initialValue: true,
                    leading: Icon(Icons.format_paint),
                    title: Text('Enable custom theme'),
                    ),
                    ],
                    ),
                    ],
                    ),
        ));





  }
}
