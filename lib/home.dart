import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';


class HomeScreen extends StatefulWidget {
  @override
  __HomeScreenState createState() => __HomeScreenState();
}

  Future<bool> verifyVibration() async{
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
      if (await Vibration.hasAmplitudeControl()) {
        Vibration.vibrate(amplitude: 128);
        if (await Vibration.hasCustomVibrationsSupport()) {
          Vibration.vibrate(duration: 1000);
        } else {
          Vibration.vibrate();
          await Future.delayed(Duration(milliseconds: 500));
          Vibration.vibrate();
        }
      }
    }
  }

class __HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onTap: verifyVibration,
          child: Container(
            width: 160,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:[
                Color(0xff8b5a2b),Color(0xffffa54f),Color(0xffa0522d),Color(0xffcd8500),Color(0xff8b4513),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Center(
              child: Text(
                'Love You <3'
              ),
            ),
          ),
        ),
      ),
    );
  }
}
