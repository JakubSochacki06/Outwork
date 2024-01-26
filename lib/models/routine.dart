import 'package:flutter/material.dart';

class Routine {
  String? name;
  bool? completed;
  Map<String, int>? scheduledTime;
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
}