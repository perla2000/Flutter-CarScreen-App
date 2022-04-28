/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 27/09/2018
 * Copyright :  S.Hamblett
 */
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'variables.dart';
/// A QOS1 publishing example, two QOS one topics are subscribed to and published in quick succession,
/// tests QOS1 protocol handling.
///


final client = MqttServerClient.withPort('broker.emqx.io','flutter_client',1883);

void mqtt_start() async {

  /// Set the correct MQTT protocol for mosquito
  client.setProtocolV311();
  client.logging(on: false);
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onSubscribed = onSubscribed;
  final connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueIdQ1')
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atLeastOnce);
  print('EXAMPLE::Mosquitto client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on Exception catch (e) {
    print('EXAMPLE::client exception - $e');
    await client.connect();
  }

  /// Check we are connected
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('EXAMPLE::Mosquitto client connected');
  } else {
    print(
        'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
    client.connect();
    exit(-1);
  }

  /// Lets try our subscriptions
  print('EXAMPLE:: <<<< SUBSCRIBE >>>>');
  const topic1 = 'DashBoard'; // Not a wildcard topic
  client.subscribe(topic1, MqttQos.atLeastOnce);

  client.updates!.listen((dynamic c) {
    final MqttPublishMessage recMess = c[0].payload;
    final pt =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is  $pt ');
    print('');
  });


  client.published!.listen((MqttPublishMessage message) {
    print(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');

  });






}


/// The subscribed callback
void onSubscribed(String topic) {
  print('EXAMPLE::Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('EXAMPLE::OnDisconnected client callback - Client disconnection');
}
void publish(String topic1){

  final builder1 = MqttClientPayloadBuilder();
  String datetime = DateTime.now().millisecondsSinceEpoch.toString();
  builder1.addString(json.encode({
    "vehicle_id":1,
    "battery": args[0],
    "rpm": args[1],
    "speed":args[2],
    "temperature":args[3],
    "timestamp":int.parse(datetime),
  }));
  print('EXAMPLE:: <<<< PUBLISH >>>>');
  client.publishMessage(topic1, MqttQos.atLeastOnce, builder1.payload!);

}