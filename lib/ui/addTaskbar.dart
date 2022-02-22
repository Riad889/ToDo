import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controller/task_controller.dart';
import 'package:todo/model/task.dart';
import 'package:todo/ui/themes.dart';

import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime selectedDate = DateTime.now();
  String _endtime = 'null';
  int selectRemind = 5;
  int selectedColor = 0;
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  List<int> remindList = [5, 10, 15, 20];
  String selectRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: Heading,
              ),
              InputField(
                controller: title,
                Hint: 'Enter your title',
                title: 'Title',
                widget: null,
              ),
              InputField(
                controller: note,
                Hint: 'Enter your Note',
                title: 'Note',
                widget: null,
              ),
              InputField(
                controller: null,
                Hint: DateFormat.yMd().format(selectedDate),
                title: 'Date',
                widget: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start time',
                      Hint: _startTime,
                      controller: null,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      Hint: _endtime,
                      controller: null,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                Hint: "$selectRemind minutes early",
                controller: null,
                widget: DropdownButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 5,
                  underline: Container(height: 0),
                  style: SubtitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              InputField(
                title: "Repeat",
                Hint: "$selectRepeat",
                controller: null,
                widget: DropdownButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 5,
                  underline: Container(height: 0),
                  style: SubtitleStyle,
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectRepeat = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Color",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Wrap(
                            children: List<Widget>.generate(3, (int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColor = index;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: index == 0
                                        ? Colors.blue
                                        : index == 1
                                            ? Colors.pinkAccent
                                            : Color.fromARGB(255, 163, 149, 24),
                                    child: selectedColor == index
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 10,
                                          )
                                        : Container(),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MyButton(
                    label: 'Create Task',
                    onTap: () {
                      _validedData();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validedData() {
    if (title.text.isNotEmpty && note.text.isNotEmpty) {
      // add to database

      _addTaskToDB();
    } else if (title.text.isEmpty || note.text.isEmpty) {
      Flushbar(
        title: "Error",
        message: "Required : All fields are required",
        backgroundGradient: LinearGradient(colors: [
          Color.fromARGB(255, 224, 19, 19),
          Color.fromARGB(255, 218, 7, 7)
        ]),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        boxShadows: [
          BoxShadow(
            color: Colors.blueAccent,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
        isDismissible: true,
      ).show(context);
    }
  }

  _addTaskToDB() async {
    int value = await _taskController.addTask(Task(
      note: note.text,
      title: title.text,
      date: DateFormat.yMd().format(selectedDate),
      startTime: _startTime,
      endTime: _endtime,
      remind: selectRemind,
      repeat: selectRepeat,
      color: selectedColor,
      isCompleted: 0,
    ));
    print("My id is $value");
  }

  _getDateFromUser() async {
    DateTime? _pickerdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(3000),
    );
    if (_pickerdate != null) {
      setState(() {
        selectedDate = _pickerdate;
      });
    }
  }

  _getTimeFromUser(bool isStartTime) async {
    var _pickTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(hour: 9, minute: 10));
    String? _formatedTime = _pickTime?.format(context);

    if (_pickTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime!;
      });

      //print(_startTime);
    } else if (isStartTime == false) {
      setState(() {
        _endtime = _formatedTime!;
      });
    }
  }
}
