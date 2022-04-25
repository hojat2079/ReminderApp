import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/controller/task_controller.dart';
import 'package:reminder_app/data/entity/color_task_type.dart';
import 'package:reminder_app/data/entity/task.dart';
import 'package:reminder_app/data/entity/time_mode.dart';
import 'package:reminder_app/ui/colors.dart';
import 'package:reminder_app/ui/text_theme.dart';
import 'package:reminder_app/ui/widget/button.dart';
import 'package:reminder_app/ui/widget/input_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _selectDate = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = '12:00 AM';
  List<String> reminders = ['5', '10', '15', '30'];
  String _selectReminder = '5';
  List<String> repeats = ['None', 'Daily', 'Weekly', 'Monthly'];
  String _selectRepeats = 'None';
  ColorTaskType _selectColor = ColorTaskType.blue;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: addTaskAppbar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: CustomTextTheme().heading6Style,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomInputField(
                title: 'Title',
                hint: 'Enter Title Here.',
                controller: titleController,
              ),
              CustomInputField(
                title: 'Note',
                hint: 'Enter Note Here.',
                controller: noteController,
              ),
              CustomInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectDate),
                widget: _customIcon(
                    iconData: Icons.calendar_today_outlined,
                    onTap: () {
                      _getDateFromUser();
                    }),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      title: 'Start Time',
                      hint: startTime,
                      widget: _customIcon(
                        iconData: Icons.access_time_rounded,
                        onTap: () {
                          _getTimeFromUser(
                            hour: int.parse(startTime.split(':')[0]),
                            minute: int.parse(
                                startTime.split(':')[1].split(' ')[0]),
                            timeMode: TimeMode.startTime,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: CustomInputField(
                      title: 'End Time',
                      hint: endTime,
                      widget: _customIcon(
                        iconData: Icons.access_time_rounded,
                        onTap: () {
                          _getTimeFromUser(
                            hour: int.parse(endTime.split(':')[0]),
                            minute:
                                int.parse(endTime.split(':')[1].split(' ')[0]),
                            timeMode: TimeMode.entTime,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              CustomInputField(
                title: 'Reminder',
                hint: '$_selectReminder minutes early',
                widget: _customDropDown(
                    list: reminders,
                    iconData: Icons.keyboard_arrow_down_outlined,
                    isReminder: true),
              ),
              CustomInputField(
                title: 'Repeats',
                hint: _selectRepeats,
                widget: _customDropDown(
                    list: repeats,
                    iconData: Icons.keyboard_arrow_down_outlined,
                    isReminder: false),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _colorSection(),
                  CustomButton(
                      label: 'Create Task',
                      onTap: () {
                        _validateInput();
                      })
                ],
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> _customDropDown(
      {required List<String> list,
      required IconData iconData,
      required bool isReminder}) {
    return DropdownButton(
      underline: const SizedBox(
        height: 0,
      ),
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          iconData,
          color: Colors.grey,
        ),
      ),
      iconSize: 28.0,
      onChanged: (String? value) {
        setState(() {
          isReminder
              ? _selectReminder = value ?? _selectReminder
              : _selectRepeats = value ?? _selectRepeats;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          child: Text(
            value,
            style: CustomTextTheme().body2Style,
          ),
          value: value,
        );
      }).toList(),
    );
  }

  InkWell _customIcon({required IconData iconData, required Function() onTap}) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Icon(
        iconData,
      ),
    );
  }

  AppBar addTaskAppbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: InkWell(
          onTap: () {
            Get.back();
          },
          customBorder: const CircleBorder(),
          child: const Icon(
            CupertinoIcons.back,
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
            ),
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2023),
    );
    setState(() {
      _selectDate = pickerDate ?? _selectDate;
    });
  }

  Future<TimeOfDay?> _showTimePicker(
      {required int hour, required int minute}) async {
    return await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
      ),
    );
  }

  _getTimeFromUser(
      {required int hour, required int minute, required TimeMode timeMode}) {
    _showTimePicker(hour: hour, minute: minute).then((value) => {
          if (value != null)
            {
              if (timeMode == TimeMode.startTime)
                {
                  setState(() {
                    startTime = value.format(context);
                  })
                }
              else
                {
                  setState(() {
                    endTime = value.format(context);
                  })
                }
            }
        });
  }

  _colorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: CustomTextTheme().body1Style,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List<Widget>.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectColor = ColorTaskType.values[index];
                });
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: index == 0
                    ? ColorPalette.bluishClr
                    : index == 1
                        ? ColorPalette.pinkClr
                        : ColorPalette.yellowClr,
                child: index == _selectColor.index
                    ? const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          );
        }))
      ],
    );
  }

  _validateInput() {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else {
      Get.snackbar('Required', 'All Fields are required !',
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: ColorPalette.pinkClr,
          snackPosition: SnackPosition.TOP);
    }
  }

  void _addTaskToDb() async {
    int finalTask = await taskController.addTask(
      task: Task(
        title: titleController.text,
        note: noteController.text,
        startTime: startTime,
        endTime: endTime,
        isCompleted: 0,
        color: _selectColor.name,
        reminder: int.parse(_selectReminder),
        repeat: _selectRepeats,
        date: DateFormat.yMd().format(_selectDate),
      ),
    );
    if (kDebugMode) {
      print('task ${finalTask.toString()} created!!');
    }
  }
}
