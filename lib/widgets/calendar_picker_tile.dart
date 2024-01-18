import 'package:flutter/material.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
class CalendarPickerTile extends StatelessWidget {
  final dynamic calendarSubject;
  CalendarPickerTile({required this.calendarSubject});
  // projectProvider.newProject

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
            calendarSubject.dueDate==null?'Input due date ->':'Due ${calendarSubject.dueDate!.day} ${DateFormat('MMMM').format(calendarSubject.dueDate!)} ${calendarSubject.dueDate!.year}',
            style: Theme.of(context).primaryTextTheme.labelLarge,
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
                        Theme.of(context).textTheme.bodyLarge,
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
                              todayHighlightColor: Theme.of(context).colorScheme.secondary,
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
                              onSelectionChanged: (arg) async{
                                if(calendarSubject == projectProvider.newProject){
                                  projectProvider.setNewProjectDueDate(arg.value);
                                } else if(calendarSubject == projectProvider.newTask){
                                  projectProvider.setNewTaskDueDate(arg.value);
                                } else {
                                  await projectProvider.changeProjectDueDate(arg.value, calendarSubject);
                                }

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
                                    style: Theme.of(context).primaryTextTheme.labelLarge,
                                  )),
                              TextButton(
                                  onPressed:
                                  calendarSubject.dueDate !=
                                      null
                                      ? () {
                                    Navigator.pop(context);
                                  }
                                      : null,
                                  child: Text(
                                    'Submit',
                                    style: calendarSubject.dueDate !=
                                        null
                                        ? Theme.of(context).primaryTextTheme.labelLarge!
                                        .copyWith(
                                        color:
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary)
                                        : Theme.of(context)
                                        .primaryTextTheme
                                        .labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
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