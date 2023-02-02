import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tell_bro/controller/input_field.dart';
import 'package:tell_bro/model/theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Text",
                style: HeadingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your title"),
              MyInputField(title: "Note", hint: "Tell Bro"),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                    color: Colors.grey
                ),
                onPressed: () {
                    _getDateFromUser();
              },

              ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start date",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime:true);
                          },
                          icon: Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(
                        title: "End date",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime:false);
                          },
                          icon: Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                ],
              )


            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
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

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015), 
        lastDate: DateTime(2123)
    );

    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    }else{
      print("Something went wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}){
    var pickedTime = _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime == null){
      print("Time canceled");
    }else if(isStartTime == true){
      _startTime = _formatedTime;
    }else if(isStartTime == false){
      _endTime = _formatedTime;
    }
  }

  _showTimePicker(){
    var _pickedTime = showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(hour: 9, minute: 10));
  }
}
