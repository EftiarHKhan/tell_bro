import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:tell_bro/controller/task_controller.dart';
import 'package:tell_bro/model/button.dart';
import 'package:tell_bro/model/notification_services.dart';
import 'package:tell_bro/model/theme_services.dart';
import 'package:tell_bro/view/add_task.dart';

import '../model/task.dart';
import '../model/task_tile.dart';
import '../model/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
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
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          //_addDateBar(),
          const SizedBox(height:15),
          _showTasks(),

        ],
      ),
    );
  }

  _addDateBar(){
    return Container(
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
        onDateChange: (date){
          setState(() {
            _selectedDate=date;
          });
        },
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
          MyButton(label: "+ Add Task", onTap: () async {
            await Get.to(()=>AddTaskPage());
            _taskController.getTasks();
          },
          ),
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

          //notifyHelper.scheduledNotification();
        },
        child: Icon(Get.isDarkMode ? Icons.wb_sunny_rounded:Icons.nightlight_round,
          size: 20,
            color:Get.isDarkMode ? Colors.white:Colors.black
        ),
      ),
      actions: [
        
        IconButton(
            onPressed: (){
              Share.share('https://play.google.com/store/apps/dev?id=5551015295329500291',subject: 'Share');
              },
            icon: Icon(Icons.share, color: Get.isDarkMode ? Colors.white:Colors.black,),
        ),

        PopupMenuButton(
          icon: Icon(Icons.menu, color: Get.isDarkMode ? Colors.white:Colors.black,),
          color: Get.isDarkMode ? Colors.white:Colors.grey[600],
          itemBuilder: (context) => [
            // PopupMenuItem<int>(
            //   value: 0,
            //   child: Text(
            //     "More App",
            //     style: TextStyle(color: Get.isDarkMode ? Colors.black:Colors.white),
            //   ),
            // ),
            PopupMenuItem<int>(
              value: 0,
                child: Text(
                  "About Us",
                  style: TextStyle(color: Get.isDarkMode ? Colors.black:Colors.white),
                ),
            ),
            // PopupMenuItem(child: child)
          ],
          onSelected: (item) => {Get.snackbar("Developer:", "Md Eftiar Haider Khan",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: const Icon(Icons.person,
          color: Colors.red,
          ),

          )},
        ),

      ],
    );
  }
  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1?
          MediaQuery.of(context).size.height*0.28:
          MediaQuery.of(context).size.height*0.36,
          color: Get.isDarkMode?darkGreyClr:Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
              ),
            ),
            Spacer(),
            task.isCompleted ==1
            ?Container()
                :_bottomSheetButton(
              label:"Task Completed",
              onTap: (){
                _taskController.markTaskCompleted(task.id!);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),

            _bottomSheetButton(
              label:"Delete Task",
              onTap: (){
                _taskController.delete(task);

                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            const SizedBox(height: 20,),
            _bottomSheetButton(
              label:"Close",
              onTap: (){
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose:true,
              context: context,
            ),
            const SizedBox(height: 10,)
          ],
        ),

      )
    );
  }
  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,

        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ),

        child: Center(
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,

            itemBuilder: (_, index) {


              Task task = _taskController.taskList[index];

              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSheet(context, _taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]),
                          )
                        ],
                      ),
                    ),
                  ));


              // if(task.repeat =='Daily') {
              //   DateTime date = DateFormat.jm().parse(task.startTime.toString());
              //   var myTime = DateFormat("HH:mm").format(date);
              //   notifyHelper.scheduledNotification(
              //     int.parse(myTime.toString().split(":")[0]),
              //     int.parse(myTime.toString().split(":")[1]),
              //     task
              //   );
              //   return AnimationConfiguration.staggeredList(
              //       position: index,
              //       child: SlideAnimation(
              //         child: FadeInAnimation(
              //           child: Row(
              //             children: [
              //               GestureDetector(
              //                 onTap: (){
              //                   _showBottomSheet(context, _taskController.taskList[index]);
              //                 },
              //                 child: TaskTile(_taskController.taskList[index]),
              //               )
              //             ],
              //           ),
              //         ),
              //       ));
              // }
              //
              // if(task.date == DateFormat.yMd().format(_selectedDate)){
              //   return AnimationConfiguration.staggeredList(
              //       position: index,
              //       child: SlideAnimation(
              //         child: FadeInAnimation(
              //           child: Row(
              //             children: [
              //               GestureDetector(
              //                 onTap: (){
              //                   _showBottomSheet(context, _taskController.taskList[index]);
              //                 },
              //                 child: TaskTile(_taskController.taskList[index]),
              //               )
              //             ],
              //           ),
              //         ),
              //       ));
              // }else{
              //   return Container();
              // }




          });
        })
      );

  }
}



