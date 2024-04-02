import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/project_task.dart';

class Project {
  String? title;
  String? description;
  String? projectType;
  DateTime? dueDate;
  List<ProjectTask>? tasks;
  List<FirebaseUser>? membersData;
  List<dynamic>? membersEmails;
  Color? color;
  List<dynamic>? requests;
  String? id;

  Project(
      {this.title,
      this.description,
      this.dueDate,
      this.membersEmails,
      this.membersData,
      this.projectType,
      this.tasks,
      this.color,
        this.requests,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'projectType': projectType,
      'dueDate': dueDate,
      'membersEmails': membersEmails,
      'tasks': tasksToMap(),
      'color':color!.value.toRadixString(16),
      'requests':requests,
      'id': id,
    };
  }

  factory Project.fromMap(Map<String, dynamic> data, List<FirebaseUser> membersData) {
    List<ProjectTask> tasks = [];
    data['tasks'].forEach((element) => tasks.add(ProjectTask.fromMap(element)));
    Project project = Project(
        title: data['title'],
        description: data['description'],
        projectType: data['projectType'],
        dueDate: data['dueDate'].toDate(),
        membersEmails: data['membersEmails'],
        membersData: membersData,
        color: Color(int.parse(data['color'], radix: 16)),
        id: data['id'],
        requests: data['requests'],
        tasks: tasks);

    return project;
  }

  List<dynamic> tasksToMap() {
    List<dynamic> tasksAsMap = [];
    tasks!.forEach((element) {
      tasksAsMap.add(element.toMap());
    });
    return tasksAsMap;
  }

  double countTaskDonePercent() {
    int done = 0;
    tasks!.forEach((element) {
      element.completed == true ? done++ : null;
    });
    return done != 0 ? done / tasks!.length : 0;
  }

  String countTaskDonePercentText(){
    // TODO: CHECK IF IT IS NOT 100%, CUZ IT LEAVES 100.%
    return countTaskDonePercent() != 0? (countTaskDonePercent() * 100).toString().substring(0,4): (countTaskDonePercent() * 100).toString().substring(0,3);
  }

  int countTaskDoneAmount() {
    int done = 0;
    tasks!.forEach((element) {
      element.completed == true ? done++ : null;
    });
    return done;
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
      return Theme.of(context)
          .colorScheme
          .onErrorContainer; // or any color you prefer
    } else {
      return Theme.of(context).colorScheme.error; // or any color you prefer
    }
  }
}
