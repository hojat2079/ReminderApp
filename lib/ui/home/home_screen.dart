import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/controller/task_controller.dart';
import 'package:reminder_app/data/entity/task.dart';
import 'package:reminder_app/service/notify_service.dart';
import 'package:reminder_app/service/theme_service.dart';
import 'package:reminder_app/ui/add_task/add_task_screen.dart';
import 'package:reminder_app/ui/colors.dart';
import 'package:reminder_app/ui/text_theme.dart';
import 'package:reminder_app/ui/widget/button.dart';
import 'package:reminder_app/ui/widget/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotifyService notifyService;
  DateTime currentDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyService = NotifyService();
    notifyService.initializeNotification();
    notifyService.requestIOSPermissions();
    _taskController.getAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: homeAppbar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDataBar(),
          const SizedBox(
            height: 12,
          ),
          _allTask()
        ],
      ),
    );
  }

  Widget _addDataBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: ColorPalette.primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
          fontSize: 20,
          fontFamily: GoogleFonts.lato().fontFamily,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: TextStyle(
          fontSize: 14,
          fontFamily: GoogleFonts.lato().fontFamily,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: GoogleFonts.lato().fontFamily,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        daysCount: 10,
        onDateChange: (newDate) {
          setState(() {
            currentDate = newDate;
          });
        },
      ),
    );
  }

  Widget _addTaskBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: CustomTextTheme().subHeading1Style,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Today',
                style: CustomTextTheme().heading4Style,
              )
            ],
          ),
          CustomButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskScreen());
              _taskController.getAllTask();
            },
          )
        ],
      ),
    );
  }

  AppBar homeAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: InkWell(
          onTap: () {
            ThemeService().switchTheme();
            notifyService.displayNotification(
                title: "Theme Changed",
                body: Get.isDarkMode
                    ? 'Activated Light Theme'
                    : 'Activated Dark Theme');
          },
          customBorder: const CircleBorder(),
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 24,
          )),
      actions: [
        InkWell(
          onTap: () {},
          customBorder: const CircleBorder(),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/img/person.svg',
                width: 36,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              )),
        ),
      ],
    );
  }

  Widget _allTask() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            print(_taskController.taskList.length);
            Task task = _taskController.taskList[index];
            if (task.repeat!.toLowerCase() == 'daily' ||
                task.date == DateFormat.yMd().format(currentDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: TaskItem(
                      task: task,
                      onTap: () {
                        _showBottomSheet(context, task);
                      },
                    ),
                  ),
                ),
              );
            }
            return Container();
          });
    }));
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ColorPalette.darkGrayClr : Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            if (task.isCompleted == 0) _completedButtonBottomSheet(task),
            _deleteButtonBottomSheet(task),
            const SizedBox(
              height: 20,
            ),
            _closeButtonBottomSheet(),
          ],
        ),
      ),
    );
  }

  _completedButtonBottomSheet(Task task) {
    return _buttonBottomSheet(
        color: ColorPalette.primaryClr,
        label: 'Task Completed',
        onTap: () async {
          await _taskController.completedTask(id: task.id!);
          Get.back();
        });
  }

  _deleteButtonBottomSheet(Task task) {
    return _buttonBottomSheet(
        color: Colors.red[300]!,
        label: 'Delete Task',
        onTap: () async {
          await _taskController.deleteTask(task: task);
          Get.back();
        });
  }

  _closeButtonBottomSheet() {
    return _buttonBottomSheet(
        color: Colors.transparent,
        label: 'Close',
        isClosed: true,
        borderColor: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
        onTap: () {
          Get.back();
        });
  }

  _buttonBottomSheet(
      {required Color color,
      required String label,
      Function()? onTap,
      Color? borderColor,
      bool isClosed = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 2, color: borderColor ?? color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: CustomTextTheme().body2Style.copyWith(
                color: !isClosed
                    ? Colors.white
                    : Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
