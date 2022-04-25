import 'package:flutter/material.dart';
import 'package:reminder_app/data/entity/color_task_type.dart';
import 'package:reminder_app/data/entity/task.dart';
import 'package:reminder_app/ui/text_theme.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function() onTap;
  const TaskItem({Key? key, required this.task, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        decoration: BoxDecoration(
            color: task.color!.toColor(),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: CustomTextTheme().body2Style.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${task.startTime!} - ${task.endTime!}',
                          style: CustomTextTheme().body2Style.copyWith(
                                color: Colors.grey[100],
                                fontSize: 13,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      task.note!,
                      style: CustomTextTheme().body2Style.copyWith(
                            color: Colors.grey[100],
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 0.5,
                height: 65,
                color: Colors.grey[200]!.withOpacity(0.7),
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  task.isCompleted == 1 ? 'COMPLETED' : 'TODO',
                  style: CustomTextTheme()
                      .body2Style
                      .copyWith(color: Colors.white, fontSize: 11),
                ),
              )
              // RotatedBox(quarterTurns: quarterTurns)
            ],
          ),
        ),
      ),
    );
  }
}
