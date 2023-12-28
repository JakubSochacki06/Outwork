import 'package:flutter/material.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
class CalendarPickerTile extends StatelessWidget {
  const CalendarPickerTile({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final projectProvider = Provider.of<ProjectsProvider>(
        context, listen: true);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Text(
            projectProvider.newProject.dueDate==null?'Input due date ->':'Due ${projectProvider.newProject.dueDate!.day} ${DateFormat('MMMM').format(projectProvider.newProject.dueDate!)} ${projectProvider.newProject.dueDate!.year}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final projectProvider = Provider.of<ProjectsProvider>(
                      context, listen: true);
                  return AlertDialog(
                    title: Center(
                      child: Text(
                        'Select date',
                        style:
                        Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    content: Container(
                      height: height * 0.4,
                      width: width * 0.8,
                      child: Column(
                        children: [
                          Container(
                            height: height*0.33,
                            width: width*0.8,
                            child: SfDateRangePicker(
                              selectableDayPredicate: (DateTime dateTime) {
                                if (dateTime.isBefore(DateTime.now())) {
                                  return false;
                                }
                                return true;
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              selectionColor: Theme.of(context)
                                  .colorScheme
                                  .secondary,
                              onSelectionChanged: (arg) {
                                projectProvider.setDueDate(arg.value);
                              },
                              // selectionShape: DateRangePickerSelectionShape.rectangle,
                              showNavigationArrow: true,
                              monthViewSettings:
                              DateRangePickerMonthViewSettings(
                                  firstDayOfWeek: 1),
                              // onSelectionChanged: ,
                              selectionMode:
                              DateRangePickerSelectionMode.single,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  )),
                              TextButton(
                                  onPressed:
                                  projectProvider.newProject.dueDate !=
                                      null
                                      ? () {
                                    Navigator.pop(context);
                                  }
                                      : null,
                                  child: Text(
                                    'Submit',
                                    style: projectProvider
                                        .newProject.dueDate !=
                                        null
                                        ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color:
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary)
                                        : Theme.of(context)
                                        .textTheme
                                        .labelLarge!,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }
}
