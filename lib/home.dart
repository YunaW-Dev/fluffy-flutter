import 'dart:developer';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluffy_flutter/utils/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'utils/time.dart';

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

    DateTime now = DateTime.now();
    TimeOfDay timeOfDay = TimeOfDay.now();

    String _time = 'abc' ;

    Future<String> getTimeOfTheDay() async{
      timeOfDay = await TimeOfDay.now();
      return timeOfDay.toString();
    }




  @override
  Widget build(BuildContext context) {
    final ref = fireDb.reference();
    final _heartbeat = ref.child('heartbeat');
    final _jujuTimeOfDay = ref.child('jujuTimeOfDay');
    final _pandaTimeOfDay = ref.child('pandaTimeOfDay');
    _heartbeat.onValue.listen((event) {
      var snapshot = event.snapshot;
      print(snapshot.value.toString());
      if (snapshot.value.toString().contains('panda')){
        changeColor();
      }
    });

    Future <void> sendingLove() async{
      if (_heartbeat.equalTo('panda') != null || _heartbeat.equalTo('intermediate')!=null){
        if (counter%2==0){
          await _heartbeat.set('juju');
          // print(TimeOfDay.now().toString());
          counter++;
        }
        else if (_heartbeat.equalTo('juju')!=null){
          await _heartbeat.set('intermediate');
          await _jujuTimeOfDay.set(getTimeOfTheDay());
          counter++;
        }
      }
    }

    void retriveTime() async{
      await _pandaTimeOfDay.onValue.listen((event) {
        var snapshot = event.snapshot;
        print(snapshot.value);
        setState(() {
          _time =  snapshot.value;
          print(_time);
        });
        // return snapshot.value;
      });
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                // ref.child('heartbeat')
                //   .push()
                //   .set('a')
                //   .asStream();
                // print(_heartbeat.once().toString().contains('juju'));
                retriveTime();
                sendingLove();
                // setState(() {
                //   changeColorWithoutVibration();
                // });


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
                height: 300,
                color: _color,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Text(
                          'Love You, no matter what color the sky is <3'
                      ),
                      Text(
                        'Panda has sent You a Love Vibration at: $_time'
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),


            ),



          ],
        )






      ),
    );
  }
}
