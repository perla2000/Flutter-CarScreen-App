

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';
List<double> args=[0,0,0,0];
const IconData home = IconData(0xe318, fontFamily: 'MaterialIcons');
// File get _localFile  {
//  final path =  getApplicationDocumentsDirectory();
//  return File('$path/assets/serial.txt');
// }
// Future<String> readCounter() async {
//  try {
//   final file = await _localFile;
//
//   // Read the file
//   final contents = await file.readAsString();
//
//   return contents;
//  } catch (e) {
//   // If encountering an error, return 0
//   return "0";
//  }
// }
//

