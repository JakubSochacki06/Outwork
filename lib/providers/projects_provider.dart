import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';

class ProjectsProvider extends ChangeNotifier {
  List<Project> _projectsList = [];
  Project _newProject = Project();

  List<Project> get projectsList => _projectsList;
  Project get newProject => _newProject;

  void setDueDate(DateTime? dueDate){
    _newProject.dueDate = dueDate;
    notifyListeners();
  }

  void setTaskType(String type){
    _newProject.taskType = type;
    notifyListeners();
  }
}