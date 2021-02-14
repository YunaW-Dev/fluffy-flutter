import 'dart:developer';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

final Random _random = new Random();
List<int> a = [1000];
Color _color = Colors.orange;

class HomeScreen extends StatefulWidget {
  HomeScreen({this.app});
  final FirebaseApp app;


  @override
  __HomeScreenState createState() => __HomeScreenState();
}
  bool selected = false;
  Future<void> verifyVibration() async{
    if (await Vibration.hasVibrator()) {
      print("1 ontapped");
      Vibration.vibrate(intensities: a);
      if (await Vibration.hasAmplitudeControl()) {
        print("2 ontapped");
        Vibration.vibrate(amplitude: 128);
        if (await Vibration.hasCustomVibrationsSupport()) {
          print("3 ontapped");
          Vibration.vibrate(duration: 1000);
        } else {
          Vibration.vibrate();
          await Future.delayed(Duration(milliseconds: 500));
          Vibration.vibrate();
        }
      }
    }
  }

  void vibrateingLove(){
    Vibration.vibrate(duration: 1000);

  }

void changeColor(){
  _color = new Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0
  );
  verifyVibration();
}

class __HomeScreenState extends State<HomeScreen> {
    final fireDb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final ref = fireDb.reference();
    return Scaffold(
      body: Container(
        color: selected ? Colors.pink: Colors.greenAccent,
        // color: Colors.pink,
        child: GestureDetector(
        onTap: (){
          ref.child('heartbeat')
            .push()
            .set('a')
            .asStream();
          setState(() {
            changeColor();
          });
        },

          // log("in ontapped");
            // print("in ontapped");
            // changeColor(selected);

          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: _color,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors:[
            //     Colors.pink,Colors.pinkAccent,Colors.greenAccent,Colors.green,Colors.yellowAccent,
            //   ],
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight),
            // ),
            child: Center(
              child: Text(
                'Love You, no matter what color the sky is <3'
              ),
            ),
          ),
        ),
      ),
    );
  }
}
