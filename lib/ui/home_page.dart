import 'package:dailyflow_prototype_2/controllers/task_controller.dart';
import 'package:dailyflow_prototype_2/models/task.dart';
import 'package:dailyflow_prototype_2/services/notification_service.dart';
import 'package:dailyflow_prototype_2/ui/add_task_page.dart';
import 'package:dailyflow_prototype_2/ui/themes.dart';
import 'package:dailyflow_prototype_2/ui/widgets/button.dart';
import 'package:dailyflow_prototype_2/ui/widgets/taks_tile.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  DatePickerController dp = DatePickerController();

  var testText = """
    Lorem ipsum odor amet, consectetuer adipiscing elit. Habitant pellentesque erat, vestibulum luctus interdum felis. Suscipit class morbi eros proin mollis senectus enim. Senectus hendrerit felis primis fringilla at tortor fames porta erat. Est faucibus molestie hendrerit, orci suspendisse vestibulum. Amet magna quisque etiam fusce duis? Laoreet aliquet condimentum primis orci phasellus metus facilisi nostra ac. Dignissim per dictum vulputate class facilisi augue eu. In laoreet vehicula molestie eget maximus?

Aliquam tellus non magna finibus condimentum id ligula. Nibh etiam vivamus dolor dignissim mi; erat per tincidunt. Duis nec laoreet habitant ac aenean, in molestie natoque. Dolor dignissim augue parturient, consectetur adipiscing adipiscing ad. Aenean semper lobortis, felis nisl commodo mattis elementum. Aper suscipit pharetra euismod ante id. Velit ex pulvinar sodales vitae auctor eleifend. Quam laoreet accumsan vehicula donec malesuada suscipit commodo. Lobortis conubia ultrices quis inceptos vitae amet curae sagittis.

Ullamcorper nibh dapibus purus consequat; leo pharetra velit. Litora porttitor congue accumsan facilisi congue. Volutpat potenti luctus velit nulla, finibus leo mauris tortor felis. Dapibus nec porttitor mus; tempus rutrum bibendum. Convallis eros amet venenatis facilisi sed porttitor id. Sit mattis ipsum lobortis, mattis suscipit nulla maecenas inceptos. Nascetur libero rutrum donec vel platea vivamus fermentum. Inceptos vehicula fringilla id aenean netus facilisis. At quam posuere; primis ornare congue mauris eros. Luctus ridiculus integer pulvinar facilisi, viverra nec feugiat mauris.
  """;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumpToToday();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            SizedBox(height: 11),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  Expanded _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.defaultDialog(
      title: task.title!,
      titleStyle: headingStyle,
      barrierDismissible: true,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 13),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 25),
                      SizedBox(width: 5),
                      Text(
                        "${task.startTime!} - ${task.endTime!}",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(height: 13),
                  Container(
                    height: 250,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.event_note_rounded, size: 25),
                            SizedBox(width: 5),
                            Text("Note", style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        SizedBox(height: 7,),
                        Expanded(child: SingleChildScrollView(child: Text(task.note!,style: TextStyle(fontSize: 17),))),
                      ],
                    ),
                  ),
                  SizedBox(height: 13,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      task.isCompleted==0?Icon(Icons.pending_outlined, size: 25):Icon(Icons.done_all, size: 25),
                      SizedBox(width: 5),
                      Text(
                        task.isCompleted==0?"Pending":"Completed",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            task.isCompleted == 0
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomSheetButton(
                      label: "Completed",
                      onTap: () {
                        _taskController.markTaskCompleted(task.id!);
                        NotifyHelper().cancelNotifications(task.id!);
                        Get.back();
                      },
                      clr: Colors.indigo,
                      context: context,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                    _bottomSheetButton(
                      label: "Delete",
                      onTap: () {
                        _taskController.delete(task);
                        NotifyHelper().cancelNotifications(task.id!);
                        Get.back();
                      },
                      clr: Colors.red,
                      context: context,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                  ],
                )
                : _bottomSheetButton(
                  label: "Delete Task",
                  onTap: () {
                    _taskController.delete(task);
                    NotifyHelper().cancelNotifications(task.id!);
                    Get.back();
                  },
                  clr: Colors.red,
                  context: context,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
            SizedBox(height: 17),
            // _bottomSheetButton(
            //   label: "Close",
            //   onTap: () {
            //     Get.back();
            //   },
            //   clr: Colors.indigo,
            //   context: context,
            //   isClose: true,
            //   width: MediaQuery.of(context).size.width * 0.9,
            // ),
          ],
        ),
      ),
    );
  }

  GestureDetector _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 55,
        width: width,
        margin: isClose == true ? EdgeInsets.only(bottom: 11) : null,
        decoration: BoxDecoration(
          color: isClose == true ? Colors.white : clr,
          borderRadius: BorderRadius.circular(13),
          border: isClose == true ? Border.all(width: 1) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: isClose == true ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19),
      child: DatePicker(
        DateTime(DateTime.now().year, DateTime.now().month, 1),
        controller: dp,
        height: 120,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        selectedTextColor: whiteTextColor,

        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: greyTextColor,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: greyTextColor,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
            dp.animateToDate(_selectedDate);
          });
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text('Today', style: headingStyle),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  void jumpToToday() {
    dp.animateToDate(_selectedDate);
  }
}
