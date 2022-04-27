// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:todo_using_sqlite/controllers/task_controller.dart';
import 'package:todo_using_sqlite/models/task.dart';
import 'package:todo_using_sqlite/screens/add_task_bar.dart';
import 'package:todo_using_sqlite/services/notification_service.dart';
import 'package:todo_using_sqlite/services/theme_services.dart';
import 'package:todo_using_sqlite/ui/theme.dart';
import 'package:todo_using_sqlite/ui/widgets/task_tile.dart';
import 'package:todo_using_sqlite/ui/widgets/button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  var notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          _addTask(),
          _dateTimePicker(),
          SizedBox(height:10),
          _showTasks(),

        ],
      ),
    );
  }

  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
          itemCount: _taskController.taskList.length,

            itemBuilder: (_, index){
              Task task = _taskController.taskList[index];
              print(task.toJson());


              if(task.repeat=='Daily')
                {
                  return
                    AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap:(){
                                      _showBottomSheet(context, task);
                                    },
                                    child:TaskTile(
                                        task
                                    )
                                )
                              ],
                            ),
                          ),
                        )
                    );

                }
              if(task.date==DateFormat.yMd().format(_selectedDate))
              {
                return
                  AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap:(){
                                    _showBottomSheet(context, task);
                                  },
                                  child:TaskTile(
                                      task
                                  )
                              )
                            ],
                          ),
                        ),
                      )
                  );
              }else{
                return Container();
              }

            });

      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task){
Get.bottomSheet(
  Container(
    padding: EdgeInsets.only(top:4),
    height: task.isCompleted==1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32,
    color: Get.isDarkMode?darkGreyColor:Colors.white,
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
        task.isCompleted==1
        ?Container():_bottomSheetButton(
            label: "Task Completed",
            onTap: (){
              _taskController.markTaskComplete(task.id!);
              Get.back();
            },
            clr: primaryClr,
        context:context
        ),
        SizedBox(height: 20),
        _bottomSheetButton(
            label: "Delete Task",
            onTap: (){
              _taskController.delete(task);
              Get.back();
            },
            clr: Colors.red[200]!,
            context:context
        ),
        SizedBox(height: 20,),
        _bottomSheetButton(
            label: "Close Task",
            onTap: (){
              Get.back();
            },
            clr: Colors.red[200]!,
            isClose:true,
            context:context
        ),
        SizedBox(height: 10,),
      ],
    ),
  )
);

  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context
}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border:Border.all(
            width: 2,
            color:isClose==true?Colors.red:clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.red:clr,
        ),

        child: Center(
            child: Text(label,
              style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
            )),
      ),
    );

  }

  _addTask(){
    return Container(
      margin: EdgeInsets.only(left:20, right: 20, top:10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                    'Today',
                    style: headingStyle
                )
              ],
            ),
            MyButton(
                label:"+ Add Task",
                onTap: () async{
                await Get.to(() => AddTaskScreen());
                _taskController.getTasks();
                }
                )
          ]
      ),
    );
  }

  _dateTimePicker()
  {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize:20,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize:16,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize:14,
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

  _appBar() {
    return AppBar(
      elevation: 3,
        leading: GestureDetector(
          onTap: () {
            ThemeService().switchTheme();
            notifyHelper.displayNotification(
                  body: Get.isDarkMode
                    ? "Activated Dark Theme"
                    : "Activated Light Theme",
              title: "Theme Changed",);
            // notifyHelper.sche
          },
          child: Icon(Icons.nightlight_round, size: 20),
        ),
        actions: [
          Icon(
            Icons.person,
            size: 20,
          ),
          SizedBox(
            width: 20,
          )
        ]);
  }
}
