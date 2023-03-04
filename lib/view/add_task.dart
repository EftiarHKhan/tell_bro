import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tell_bro/controller/input_field.dart';
import 'package:tell_bro/controller/task_controller.dart';
import 'package:tell_bro/model/button.dart';
import 'package:tell_bro/model/theme.dart';
import 'package:tell_bro/model/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  int _selectedColor = 0;
  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

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
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Tell Bro", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: const Icon(Icons.calendar_today_outlined,
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
                        title: "Start time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime:true);
                          },
                          icon: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  const SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(
                        title: "End time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime:false);
                          },
                          icon: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  style: subTitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }
                  ).toList(),
                ),
              ),
              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  style: subTitleStyle,
                  items: repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!, style:TextStyle(color: Colors.grey)),
                    );
                  }
                  ).toList(),
                ),
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: ()=>_validateDate(),)
                ],
              ),
              SizedBox(height: 20,),


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
      actions: const [
        //Icon(Icons.person, size: 20,),
        // CircleAvatar(
        //   backgroundImage: AssetImage(
        //       "images/profile.png"
        //   ),
        // )
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

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime == null){
      print("Time canceled");
    }else if(isStartTime == true){
      setState(() {
        _startTime = _formatedTime;
      });
    }else if(isStartTime == false){
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ),
        );

  }

  _validateDate(){
    if(_titleController.text.isNotEmpty&& _noteController.text.isNotEmpty){
      //add to database
      _addTaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: primaryClr,
        icon: const Icon(Icons.warning_amber_rounded,
          color: Colors.red,
        ),

      );
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );

  }
  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(height: 8,),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedColor = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 0?primaryClr:index ==1?pinkClr:darkGreyClr,
                      child: _selectedColor == index?Icon(Icons.done,
                        color: Colors.white,
                        size: 16,
                      ):Container(),
                    ),
                  ),
                );
              }
          ),
        )
      ],
    );
  }
}
