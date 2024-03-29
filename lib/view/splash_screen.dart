import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tell_bro/view/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    Timer(Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomePage(),
      ));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell Bro'),
      ),
      body: Container(
        //color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('images/profile.png',
              width: 400,
              height: 400,
              fit: BoxFit.fill,
            ),
            Text("Loading",
              style: TextStyle(color: Colors.orange, fontSize: 30,),
            ),
          ],
        ),

      ),
    );
  }
}
