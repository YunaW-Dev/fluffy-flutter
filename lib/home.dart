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
  Future<void> verifyVibration() async{
    if (await Vibration.hasVibrator()) {
      print("1 ontapped");
      Vibration.vibrate();
      // if (await Vibration.hasAmplitudeControl()) {
      //   print("2 ontapped");
      //   Vibration.vibrate(amplitude: 128);
      //   if (await Vibration.hasCustomVibrationsSupport()) {
      //     print("3 ontapped");
      //     Vibration.vibrate(duration: 1000);
      //   } else {
      //     Vibration.vibrate();
      //     await Future.delayed(Duration(milliseconds: 500));
      //     Vibration.vibrate();
      //   }
      // }
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

void changeColorWithoutVibration(){
  _color = new Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0
  );
}

class __HomeScreenState extends State<HomeScreen> {
    final fireDb = FirebaseDatabase.instance;
    bool flag = false;
    var counter = 0;
  @override
  Widget build(BuildContext context) {
    final ref = fireDb.reference();
    final _heartbeat = ref.child('heartbeat');
    _heartbeat.onValue.listen((event) {
      var snapshot = event.snapshot;
      print(snapshot.value.toString());
      if (snapshot.value.toString().contains('panda')){
        changeColor();
      }
    });
    return Scaffold(
      body: Container(
        // color: Colors.pink,
        child: GestureDetector(
        onTap: (){
          // ref.child('heartbeat')
          //   .push()
          //   .set('a')
          //   .asStream();
          // print(_heartbeat.once().toString().contains('juju'));



          if (_heartbeat.equalTo('panda') != null || _heartbeat.equalTo('intermediate')!=null){
            if (counter%2==0){
              _heartbeat.set('juju');
              counter++;
            }
            else {
              _heartbeat.set('intermediate');
              counter++;
            }
          }
            setState(() {
              changeColorWithoutVibration();
            });


          //
          // _heartbeat.once()..listen((event) {
          //   var snapshot = event.snapshot;
          //   print(snapshot.value.toString());
          //   if (snapshot.value.toString().contains('panda')){
          //     ref.child('heartbeat').set('juju');
          //   }
          //   setState(() {
          //     changeColorWithoutVibration();
          //   });
          //
          // });

        },

          // log("in ontapped");
            // print("in ontapped");
            // changeColor(selected);

          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: _color,
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
