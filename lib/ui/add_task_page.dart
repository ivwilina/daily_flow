import 'package:dailyflow_prototype_2/controllers/task_controller.dart';
import 'package:dailyflow_prototype_2/models/task.dart';
import 'package:dailyflow_prototype_2/services/notification_service.dart';
import 'package:dailyflow_prototype_2/ui/themes.dart';
import 'package:dailyflow_prototype_2/ui/widgets/button.dart';
import 'package:dailyflow_prototype_2/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "12:00 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  DateTime subSelected = DateTime.now();
  DateTime subNow = DateTime.now();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 30];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task", style: headingStyle),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: Icon(Icons.calendar_month),
                  color: greyTextColor,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(Icons.access_time),
                        color: greyTextColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 19),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(Icons.access_time),
                        color: greyTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Remid",
                hint: "$_selectedRemind minute early",
                widget: DropdownButton(
                  underline: Container(height: 0),
                  items:
                      remindList.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_down, color: greyTextColor),
                  elevation: 4,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: () => _validateDate()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty && _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
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
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("My id is $value");
    await scheduledNotificationGenerate(value);
  }

  Future<void> scheduledNotificationGenerate(int id) async {

    var sRemind = _selectedRemind;

    var reFormattedTime = subSelected.subtract(Duration(minutes: _selectedRemind));
    var scheduledTime = DateFormat("HH:mm").format(reFormattedTime);
    var sTitle = _titleController.text; 
    var sBody = "$sRemind minutes left to the appointment";
    var sYear = _selectedDate.year;
    var sMonth = _selectedDate.month;
    var sDay = _selectedDate.day;
    var sHour = int.parse(scheduledTime.split(":")[0]);
    var sMinute = int.parse(scheduledTime.split(":")[1]);
    var sId = id;

    await NotifyHelper().scheduledNotification(id: sId, title: sTitle, body: sBody, year: sYear, month: sMonth, day: sDay, hour: sHour, minute: sMinute);
  }

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 9, top: 3),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      index == 0
                          ? richBlackColor
                          : index == 1
                          ? darkSpringGreenColor
                          : carmineColor,
                  child:
                      _selectedColor == index
                          ? Icon(Icons.done, color: Colors.white, size: 17)
                          : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print("something wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    // String formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      String formattedTime = pickedTime.format(context);
      setState(() {
        var ssHour = pickedTime.hour;
        var ssMin = pickedTime.minute;
        subSelected = DateTime(subNow.year,subNow.month,subNow.day, ssHour, ssMin);
        _startTime = formattedTime;
      });
    } else if (isStartTime == false) {
      String formattedTime = pickedTime.format(context);
      setState(() {
        _endTime = formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
