import 'package:flutter/material.dart';

class ProjectTask {
  String? title;
  String? description;
  DateTime? dueDate;
  String? addedBy;
  bool? completed;
  Color? projectColor;

  ProjectTask({
    this.title,
    this.description,
    this.dueDate,
    this.addedBy,
    this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'addedBy': addedBy,
      'completed': completed
    };
  }

  factory ProjectTask.fromMap(Map<String, dynamic> data) {
    ProjectTask task = ProjectTask(
      title: data['title'],
      description: data['description'],
      dueDate: data['dueDate'].toDate(),
      addedBy: data['addedBy'],
      completed: data['completed'],
    );
    return task;
  }

  String countTimeLeft() {
    if(dueDate!.difference(DateTime.now()).inDays > 0){
      return '${dueDate!.difference(DateTime.now()).inDays} days left';
    } else if(dueDate!.difference(DateTime.now()).inHours > 0){
      return '${dueDate!.difference(DateTime.now()).inHours} hours left!!';
    } else {
      if(dueDate!.difference(DateTime.now()).inHours.abs() < 24){
        return 'Late ${dueDate!.difference(DateTime.now()).inHours.abs()} hours';
      } else {
        return 'Late ${dueDate!.difference(DateTime.now()).inDays.abs()} days';
      }
    }
  }

  Color colorOfDaysLeft(BuildContext context) {
    int daysLeft = dueDate!.difference(DateTime.now()).inDays;

    if (daysLeft > 10) {
      return Theme.of(context).colorScheme.onSurface;
    } else if (daysLeft > 5) {
      return Theme.of(context).colorScheme.onErrorContainer; // or any color you prefer
    } else {
      return Theme.of(context).colorScheme.error; // or any color you prefer
    }
  }
}
