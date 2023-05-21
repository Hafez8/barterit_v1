import 'dart:async';
import 'package:barterlt_v1/models/user.dart';
import 'package:barterlt_v1/views/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_v1/views/screens/loginscreen.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State <SplashScreen>createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

@override
  Widget build (BuildContext context){
  return Scaffold(
    body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/shake.jpg'),
              fit: BoxFit.cover
              )
          ),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "BARTERIT",
              style: TextStyle(
                fontSize:48,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            CircularProgressIndicator(),
            Text(
              "Version 0.1",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ],
         ),
         )
      ],
    ),
  );
}
@override
  void initState(){
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (content) =>  MainScreen(user: User())))
    );
  }
}
