import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controller/task_controller.dart';
import 'package:todo/ui/themes.dart';
import 'package:todo/widgets/button.dart';

import '../model/task.dart';
import '../widgets/taskTile.dart';
import 'addTaskbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  get index => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.nightlight_outlined,
          size: 30,
          color: Colors.redAccent,
        ),
        centerTitle: true,
        title: Text("ToDo"),
        actions: [
          Icon(Icons.verified_user_rounded),
        ],
      ),
      body: Column(
        children: [
          _addTaskBar(),
          SizedBox(
            height: 7,
          ),
          _addDateBar(),
          _showTask(),
        ],
      ),
    );
  }

  _showTask() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, context) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context,_taskController.taskList[index]);
                          },
                          child: TaskTile(_taskController.taskList[index]),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context,Task? task){
    

  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: Colors.blue,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Today",
                  style: Heading,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const AddTask()),
                );
                _taskController.getTask();
              }),
        ],
      ),
    );
  }
}
