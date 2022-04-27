import 'package:flutter/material.dart';
import 'package:todo_using_sqlite/controllers/task_controller.dart';
import 'package:todo_using_sqlite/models/task.dart';
import 'package:todo_using_sqlite/ui/theme.dart';
import 'package:todo_using_sqlite/ui/widgets/button.dart';
import 'package:todo_using_sqlite/ui/widgets/input_field_dart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 APM";
  String _startTime = DateFormat("hh:mm A").format(DateTime.now()).toString();
  int _selectedReminder = 5;
  List<int> reminderList=[
    5,10,15,20
  ];

  String _selectedRepeat = "None";
  List<String> repeatList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly"
  ];

  int _selectedColor=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(title: 'Title', hint: 'Enter your title here', controller: _titleController),
              InputField(title: 'Note', hint: 'Enter your notes here', controller: _noteController,),
              InputField(
                title: 'Date', hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start",
                      hint: _startTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded),
                        onPressed: () {
                          _getTimeFromUser(isStartTime:true);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: InputField(
                      title: "End",
                      hint: _endTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded),
                        onPressed: () {
                          _getTimeFromUser(isStartTime:false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedReminder minutes early",
                widget: DropdownButton(
                  icon:const Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedReminder = int.parse(newValue!);
                    });
                  },
                  items: reminderList.map<DropdownMenuItem<String>>((int value ){
                    return DropdownMenuItem<String>(
                      value:value.toString(),
                      child: Text(value.toString()),
                    );
                  },
                  ).toList(),
                ),
              ),
              InputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon:const Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String? value ){
                    return DropdownMenuItem<String>(
                      value:value,
                      child: Text(value!, style: TextStyle(color:Colors.grey),),
                    );
                  },
                  ).toList(),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label:"Create Task", onTap:()=>_validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
              Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        actions: const [
          Icon(
              Icons.person,
              size: 20, color: Colors.black
          ),
          SizedBox(
            width: 20,
          )
        ]);
  }

  _validateDate(){
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty)
      {
        _addTaskToDB();
        Get.back();
      }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkColor,
        icon: const Icon(Icons.warning_amber_rounded,
        color:Colors.red),
      );
    }
  }

  _addTaskToDB() async{
  await _taskController.addTask(
        task:Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedReminder,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0
        )
    );
  }
  _getDateFromUser() async
  {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2122)
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("it's null or something went wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async
  {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime==null)
      {
        print("Time canceled");
      }else if(isStartTime==true){
      setState(() {
        _startTime=_formatedTime;
      });
    }else if(isStartTime==false)
      {
        setState(() {
          _endTime = _formatedTime;
        });

      }
  }

  _showTimePicker() {
    return showTimePicker(
      context:context,
    initialEntryMode: TimePickerEntryMode.input,
    initialTime: TimeOfDay(
      hour: int.parse(_startTime.split(":")[0]),
      minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
    ),
    );
  }

  _colorPallete()
  {
return  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "Color",
      style: titleStyle,
    ),
    const SizedBox(height: 8.0),
    Wrap(
      children: List<Widget>.generate(
          3,
              (int index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  _selectedColor=index;
                  print("$index");
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index==0?primaryClr:index==1?pinkColor:yellowColor,
                    child: _selectedColor==index?Icon(Icons.done,
                      color: Colors.white,
                      size:16,
                    ):Container()
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