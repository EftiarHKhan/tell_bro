import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tell_bro/model/notification_services.dart';
import 'package:tell_bro/model/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var notifyHelper;
  @override
  void initState(){
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Text('Tell Bro, Hi',
          style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
  _appBar(){
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          ThemeServices().switchTheme();

          notifyHelper.displayNotification(
              title: "Theme changed",
              body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
          );

          notifyHelper.scheduledNotification();
        },
        child: Icon(Icons.nightlight_round,
          size: 20,),
      ),
      actions: [
        Icon(Icons.person, size: 20,),
      ],
    );
  }
}



