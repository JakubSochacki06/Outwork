import 'package:flutter/material.dart';

class DailyCheckin{
  String? name;
  String? emojiName;
  String? unit;
  int? goal;
  int? step;
  int? value;
  Color? color;
  String? id;

  DailyCheckin({this.name, this.emojiName, this.unit, this.goal, this.step, this.value, this.color, this.id});

  factory DailyCheckin.fromMap(Map<String, dynamic> data) {
    DailyCheckin dailyCheckin = DailyCheckin(
      name: data['name'],
        emojiName: data['emojiName'],
        unit: data['unit'],
        goal: data['goal'],
        step: data['step'],
        value: data['value'],
        id:data['id'],
        color: Color(int.parse(data['color'], radix: 16)),
    );

    return dailyCheckin;
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'emojiName': emojiName,
      'unit':unit,
      'goal':goal,
      'step':step,
      'id':id,
      'value':value,
      'color':color!.value.toRadixString(16).padLeft(8, '0').toUpperCase(),
    };
  }
}