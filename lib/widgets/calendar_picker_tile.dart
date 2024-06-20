import 'package:flutter/material.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarPickerTile extends StatelessWidget {
  final dynamic calendarSubject;
  // final bool hasError;
  CalendarPickerTile({required this.calendarSubject});
  // projectProvider.newProject

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height*0.01),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final projectProvider = Provider.of<ProjectsProvider>(
                  context, listen: true);
              return AlertDialog(
                title: Center(
                  child: Text(
                    AppLocalizations.of(context)!.selectDate,
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
                          backgroundColor: Theme.of(context).colorScheme.background,
                          headerStyle: DateRangePickerHeaderStyle(
                            backgroundColor: Theme.of(context).colorScheme.background,
                          ),
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
                            if(calendarSubject == projectProvider.newProject){
                              projectProvider.setNewProjectDueDate(arg.value);
                            } else if(calendarSubject == projectProvider.newTask){
                              projectProvider.setNewTaskDueDate(arg.value);
                            } else {
                              projectProvider.editProjectDueDate(arg.value);
                            }

                          },
                          // selectionShape: DateRangePickerSelectionShape.rectangle,
                          showNavigationArrow: true,
                          monthViewSettings:
                          const DateRangePickerMonthViewSettings(
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
                                AppLocalizations.of(context)!.cancel,
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
                                AppLocalizations.of(context)!.submit,
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
        child: Row(
          children: [
            Text(
              calendarSubject.dueDate==null?AppLocalizations.of(context)!.inputDueDate:'${AppLocalizations.of(context)!.due} ${calendarSubject.dueDate!.day} ${DateFormat('MMMM', themeProvider.selectedLocale!.languageCode).format(calendarSubject.dueDate!)} ${calendarSubject.dueDate!.year}',
              style: Theme.of(context).primaryTextTheme.labelLarge,
            ),
            const Spacer(),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}