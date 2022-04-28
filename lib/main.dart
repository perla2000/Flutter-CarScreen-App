import 'dart:async';
import 'package:drip/pages/searchresultwidgets/main_settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import'variables.dart' ;
import 'mqtt_publish.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:drip/homepage.dart';
import 'music.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'ac_page.dart';


void main() {
  mqtt_start();
  runApp(MaterialApp(
    initialRoute:'/home',
    routes: {
      '/dashboard': (context) => MyApp(),
      '/home':(context)=>HomePage(),
      '/homemusic': (context) => const MyHomePage(),
      '/settings':(context)=>  MainSettings(),
      '/ac':(context) => AcPage(),

    },
  ));

}



class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();

}

class _State extends State<MyApp> {

  double _speed=0;
  double _battery=0;
  double _rpm=0;
  double _tmp=0;
  late Timer _timer1;
  late Timer _timer2;
  late Timer _timer3;
  late Timer _timer4;

  // final Email send_email = Email(
  //   body: 'The driver of your car exceeded the speed limit',
  //   subject: 'SPEED LIMIT',
  //   recipients: ['perla.abdallah@net.uj.edu.lb'],
  //   cc: ['radwan.afiouni@net.usj.edu.lb'],
  //   isHTML: false,
  // );



  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // Start listening to changes.

    _timer1 = Timer.periodic(const Duration(milliseconds: 3000), (_timer) {
      setState(()  {
        //print(readCounter());
        _speed = (Random().nextDouble() * 40) + 60;
        _speed = double.parse(_speed.toStringAsFixed(1));
        // if(_speed>90){
        //    FlutterEmailSender.send(send_email);
        // }
        args[2]=_speed;
        if (client.connectionStatus!.state == MqttConnectionState.connected) {
          publish('DashBoard');
        }
      });
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 8000), (_timer) {
      setState(()  {

        // _battery=(Random().nextDouble()*147);
        // _battery = double.parse(_battery.toStringAsFixed(1));
        _battery=96;

        args[0]=_battery;
        if (client.connectionStatus!.state == MqttConnectionState.connected) {
          //publish('DashBoard');
        }
      });
    });
    _timer3 = Timer.periodic(const Duration(milliseconds: 5000), (_timer) {
      setState(()  {


        _rpm=(Random().nextDouble()*80);
        _rpm = double.parse(_rpm.toStringAsFixed(1));
        args[1]=_rpm;
        if (client.connectionStatus!.state == MqttConnectionState.connected) {
          //publish('DashBoard');
        }
      });
    });
    _timer4 = Timer.periodic(const Duration(milliseconds: 8000), (_timer) {
      setState(()  {
        _tmp=(Random().nextDouble()*100);
        _tmp = double.parse(_tmp.toStringAsFixed(1));
        args[3]=_tmp;
        if (client.connectionStatus!.state == MqttConnectionState.connected) {
          //publish('DashBoard');
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    return Scaffold(
        primary: !isLandscape,
        backgroundColor:Color(0xFF0F0F11),
        appBar: AppBar(
          title: Text('Juice Mobility'),
          backgroundColor:Color(0xff0032b2),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,

          ),
        ),
        body:
        Padding(
            padding: EdgeInsets.all(15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox( height:350,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SfRadialGauge(
                              axes: <RadialAxis>[

                                RadialAxis(minimum: 0,
                                    maximum: 200,
                                    labelOffset: 30,
                                    axisLineStyle: AxisLineStyle(
                                        thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),


                                    axisLabelStyle: GaugeTextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    ranges: <GaugeRange>[
                                      GaugeRange(startValue: 0,
                                          endValue: 200,
                                          sizeUnit: GaugeSizeUnit.factor,
                                          startWidth: 0.03,
                                          endWidth: 0.03,
                                          gradient: const SweepGradient(
                                              colors: <Color>[
                                                Color(0xff95d7ff),
                                                Color(0xff1213b7),
                                                Color(0xffd70007),
                                              ],
                                              stops: <double>[0.0, 0.5, 1]))
                                    ],
                                    pointers: <GaugePointer>[
                                      NeedlePointer(value: _speed,
                                          needleLength: 1,
                                          enableAnimation: true,
                                          animationType: AnimationType.ease,
                                          needleStartWidth: 0.5,
                                          needleEndWidth: 4,
                                          needleColor: Color(0xff1213b7),
                                          knobStyle: KnobStyle(knobRadius: 0.09,sizeUnit: GaugeSizeUnit.factor))
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(widget:
                                      Column(
                                          children: <Widget>[
                                            SizedBox(height: 80),

                                            Text(_speed.toString(),
                                                style: const TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.white )),

                                            SizedBox(height: 10),
                                            Text('km/h',

                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.white)),

                                          ]
                                      ), angle: 90, positionFactor: 0.75)
                                    ]
                                )
                              ]
                          ),
                          SfRadialGauge(axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              showLabels: false,
                              showTicks: false,
                              startAngle: 270,
                              endAngle: 270,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.2,

                                color: Color.fromARGB(44, 18, 19, 183),
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(widget:
                                Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(_rpm.toString(),
                                            style: const TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                color:Colors.white )),
                                      ),
                                      SizedBox(height: 10),
                                      const Center(
                                        child: Text('rpm',

                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color:Colors.white)),
                                      )
                                    ]
                                ), angle: 90, positionFactor: 0.75)
                              ],
                              pointers: <GaugePointer>[
                                RangePointer(
                                    value: _rpm,
                                    width: 0.1,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    cornerStyle: CornerStyle.startCurve,
                                    gradient: const SweepGradient(colors: <Color>[
                                      Color(0xdf0059ff),
                                      Color(0xff95d7ff)
                                    ], stops: <double>[
                                      0.25,
                                      0.75
                                    ])),
                                MarkerPointer(
                                  value: _rpm,
                                  markerType: MarkerType.circle,
                                  color: const Color(0xff1213b7),
                                )
                              ],
                            )
                          ]),
                        ]
                    ),
                  ),
                  Divider(
                    height:50.0,
                    color:Colors.blueAccent[700],
                  ),

                  SizedBox(
                    height:300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SfRadialGauge(
                            axes: <RadialAxis>[
                              // Create primary radial axis
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                showLabels: false,
                                showTicks: false,
                                startAngle: 270,
                                endAngle: 270,
                                radiusFactor: 0.7,
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.2,
                                  color: const Color.fromARGB(63, 0, 89, 255),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                    value: _battery,
                                    width: 0.05,
                                    pointerOffset: 0.07,
                                    sizeUnit: GaugeSizeUnit.factor,
                                  )
                                ],
                              ),
                              // Create secondary radial axis for segmented line
                              RadialAxis(
                                minimum: 0,
                                interval: 1,
                                maximum: 4,
                                showLabels: false,
                                showTicks: true,
                                showAxisLine: false,
                                tickOffset: -0.05,
                                offsetUnit: GaugeSizeUnit.factor,
                                minorTicksPerInterval: 0,
                                startAngle: 270,
                                endAngle: 270,
                                radiusFactor: 0.7,
                                majorTickStyle: MajorTickStyle(
                                    length: 0.3,
                                    thickness: 0.5,
                                    lengthUnit: GaugeSizeUnit.factor,
                                    color: Colors.white),

                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(widget:
                                  Column(
                                      children: <Widget>[
                                        SizedBox(height:50),
                                        Center(
                                          child: Text(_battery.toString(),
                                              style: const TextStyle(
                                                  fontSize:40,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white )),
                                        ),
                                        SizedBox(height: 10),
                                        const Center(
                                          child: Text('KWh',

                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white)),
                                        )
                                      ]
                                  ), angle: 90, positionFactor: 0.75)
                                ],
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.2,
                                  color: const Color.fromARGB(255, 0, 89, 255),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                              )
                            ]
                        ),
                        SfRadialGauge(
                            axes: <RadialAxis>[
                              // Create primary radial axis
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                showLabels: false,
                                showTicks: false,
                                startAngle: 270,
                                endAngle: 270,
                                radiusFactor: 0.7,
                                ranges: <GaugeRange>[
                                  GaugeRange(startValue: 0,
                                      endValue: 200,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      startWidth: 0.03,
                                      endWidth: 0.03,
                                      gradient: const SweepGradient(
                                          colors: <Color>[
                                            Color(0xff95d7ff),
                                            Color(0xff1213b7),
                                            Color(0xffd70007),
                                          ],
                                          stops: <double>[0.0, 0.5, 1]))
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(widget:
                                  Column(
                                      children: <Widget>[
                                        SizedBox(height:50),
                                        Center(
                                          child: Text(_tmp.toString(),
                                              style: const TextStyle(
                                                  fontSize:40,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white )),
                                        ),
                                        SizedBox(height: 10),
                                        const Center(
                                          child: Text('°C',

                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white)),
                                        )
                                      ]
                                  ), angle: 90, positionFactor: 0.75)
                                ],
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.2,
                                  color: const Color.fromARGB(63, 0, 89, 255),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                    value: _tmp,
                                    width: 0.05,
                                    pointerOffset: 0.07,
                                    color:const Color.fromARGB(63, 0, 89, 255),
                                    sizeUnit: GaugeSizeUnit.factor,
                                  )
                                ],
                              ),
                              // Create secondary radial axis for segmented line
                              RadialAxis(
                                minimum: 0,
                                interval: 1,
                                maximum: 4,
                                showLabels: false,
                                showTicks: true,
                                showAxisLine: false,
                                tickOffset: -0.05,
                                offsetUnit: GaugeSizeUnit.factor,
                                minorTicksPerInterval: 0,
                                startAngle: 270,
                                endAngle: 270,
                                radiusFactor: 0.7,
                                majorTickStyle: MajorTickStyle(
                                    length: 0.3,
                                    thickness: 0.5,
                                    lengthUnit: GaugeSizeUnit.factor,
                                    color: Colors.white),

                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.2,

                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                              )
                            ]
                        ),

                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      FloatingActionButton(
                        onPressed: () {  Navigator.pushNamed(context, '/home');},
                        backgroundColor: Color(0xFF0F0F11),
                        child:const Icon(Icons.home,color:Color(0xff0032b2),size:60),

                      ),
                    ],
                  )
                ])
        )
    );
  }
}