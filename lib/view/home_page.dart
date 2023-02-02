import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tell_bro/model/button.dart';
import 'package:tell_bro/model/notification_services.dart';
import 'package:tell_bro/model/theme_services.dart';

import '../model/theme.dart';

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
          _addTaskBar(),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryClr,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today",
                  style: HeadingStyle,
                ),
              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap: ()=>null)
        ],
      ),
    );
  }
  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeServices().switchTheme();

          notifyHelper.displayNotification(
              title: "Theme changed",
              body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
          );

          notifyHelper.scheduledNotification();
        },
        child: Icon(Get.isDarkMode ? Icons.wb_sunny_rounded:Icons.nightlight_round,
          size: 20,
            color:Get.isDarkMode ? Colors.white:Colors.black
        ),
      ),
      actions: [
        //Icon(Icons.person, size: 20,),
        CircleAvatar(
          backgroundImage: AssetImage(
            "images/profile.png"
          ),
        )
      ],
    );
  }
}


