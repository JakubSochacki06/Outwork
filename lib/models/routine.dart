import 'package:flutter/material.dart';

class Routine {
  String? name;
  bool? completed;
  Map<String, dynamic>? scheduledTime;
  int? id;

  Routine({required this.name, required this.completed, required this.scheduledTime, required this.id});

  factory Routine.fromMap(Map<String, dynamic> data){
    return Routine(
      name: data['name'],
      completed: data['completed'],
      scheduledTime: data['scheduledTime'],
      id: data['id'],
    );
  }

  bool isLate() {
    if (scheduledTime == null || scheduledTime!['hour'] == null || scheduledTime!['minute'] == null) {
      return false; // Return false if scheduledTime or its components are missing
    }

    DateTime currentTime = DateTime.now();
    int scheduledHour = scheduledTime!['hour'];
    int scheduledMinute = scheduledTime!['minute'];

    DateTime scheduledDateTime = DateTime(currentTime.year, currentTime.month, currentTime.day, scheduledHour, scheduledMinute);

    return currentTime.isAfter(scheduledDateTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'completed': completed,
      'id': id,
      'scheduledTime': scheduledTime,
    };
  }
}

