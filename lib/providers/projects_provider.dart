import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/project_task.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';
import 'package:uuid/uuid.dart';

class ProjectsProvider extends ChangeNotifier {
  List<Project> _projectsList = [];
  List<dynamic> _projectsIDList = [];
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Project _newProject = Project();
  ProjectTask _newTask = ProjectTask();

  List<Project> get projectsList => _projectsList;

  Project get newProject => _newProject;

  ProjectTask get newTask => _newTask;

  Future<void> setProjectsList(FirebaseUser user) async {
    _projectsIDList = user.projectsIDList!;
    _projectsList = [];
    for (int i = 0; i < _projectsIDList.length; i++) {
      Project? project = await getProjectById(_projectsIDList[i]);
      _projectsList.add(project!);
    }
  }

  void setNewProjectDueDate(DateTime? dueDate) {
    _newProject.dueDate = dueDate;
    notifyListeners();
  }

  void setNewTaskDueDate(DateTime? dueDate) {
    _newTask.dueDate = dueDate;
    notifyListeners();
  }

  void setProjectType(String type) {
    _newProject.projectType = type;
    notifyListeners();
  }

  Future<Project?> getProjectById(String id) async {
    final QuerySnapshot querySnapshot =
        await _db.collection('projects').where('id', isEqualTo: id).get();
    if (querySnapshot.docs.isNotEmpty) {
      dynamic projectData = querySnapshot.docs.first.data();
      print(projectData['membersEmails'].runtimeType);
      List<FirebaseUser> projectMembers = await getProjectMembersData(projectData['membersEmails']);
      Project project = Project.fromMap(projectData, projectMembers);
      return project;
    }
    return null;
  }

  Future<List<FirebaseUser>> getProjectMembersData(List<dynamic> userEmails) async{
    List<FirebaseUser> projectMembers = [];
    for (var userEmail in userEmails) {
      print('yes');
      FirebaseUser? projectMember = await FirebaseUser.getUserByMail(userEmail);
      projectMembers.add(projectMember!);
    }
    return projectMembers;
  }

  Color generateRandomPastelColor() {
    List<Color> colors = [
      Color(0xFF80BCBD),
      Color(0xFFD5F0C1),
      Color(0xFF756AB6),
      Color(0xFFAC87C5),
      Color(0xFF71C9CE),
      Color(0xFFA6E3E9),
      Color(0xFF8785A2),
      Color(0xFFFFC7C7),
      Color(0xFF95E1D3),
      Color(0xFFF38181),
      Color(0xFF424874),
      Color(0xFFDCD6F7),
      Color(0xFFA6B1E1),
      Color(0xFF0F4C75),
      Color(0xFF3282B8),
      Color(0xFFB1B2FF),
      Color(0xFFAAC4FF),
      Color(0xFF798777),
      Color(0xFFBDD2B6)
    ];
    return colors[Random().nextInt(colors.length)];
  }

  Future<void> addProjectToDatabase(FirebaseUser user) async {
    var uuid = const Uuid();
    String projectID = uuid.v4().substring(0, 6);
    _newProject.id = projectID;
    _newProject.tasks = [];
    _newProject.requests = [];
    _newProject.color = generateRandomPastelColor();
    await _db.collection('projects').doc(projectID).set(_newProject.toMap());
    _projectsIDList.add(projectID);
    _newProject.membersData = await getProjectMembersData(_newProject.membersEmails!);
    _projectsList.add(_newProject);
    await _db
        .collection('users_data')
        .doc(user.email)
        .set({'projectsIDList': _projectsIDList}, SetOptions(merge: true));
    _newProject = Project();
    notifyListeners();
  }

  // Future<void> addProjectIDToUserDatabase(FirebaseUser user, Project project) async{
  //   _projectsIDList.add(project.id);
  //   await _db
  //       .collection('users_data')
  //       .doc(user.email)
  //       .set({'projectsIDList': _projectsIDList}, SetOptions(merge: true));
  //   project.members!.add(user.email);
  //   await _db
  //       .collection('projects')
  //       .doc(project.id)
  //       .set({'members': project.members}, SetOptions(merge: true));
  // }

  Future<void> addTaskToDatabase(Project project) async {
    project.tasks!.add(_newTask);
    project.tasks!.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    await _db
        .collection('projects')
        .doc(project.id)
        .set({'tasks': project.tasksToMap()}, SetOptions(merge: true));
    _newTask = ProjectTask();
    notifyListeners();
  }

  Future<void> updateTaskCompletionStatus(
      Project project, int taskIndex) async {
    project.tasks![taskIndex].completed = !project.tasks![taskIndex].completed!;
    await _db
        .collection('projects')
        .doc(project.id)
        .update({'tasks': project.tasksToMap()});
    notifyListeners();
  }

  List<ProjectTask> upcomingTasks() {
    List<ProjectTask> allTasks = [];
    for (var project in _projectsList) {
      project.tasks!.forEach((task) {
        task.projectColor = project.color;
        allTasks.add(task);
      });
    }
    allTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return allTasks;
  }

  Future<void> sendRequestToJoinProject(
      String projectID, FirebaseUser user) async {
    await _db.collection('projects').doc(projectID).update({
      'requests': FieldValue.arrayUnion([user.email])
    });
  }

  Future<bool> projectIDValid(String projectID, FirebaseUser user) async {
    final QuerySnapshot querySnapshot = await _db
        .collection('projects')
        .where('id', isEqualTo: projectID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      await sendRequestToJoinProject(projectID, user);
      return true;
    }
    return false;
  }

  Future<void> addUserToProject(
      FirebaseUser addedUser, String projectID) async {
    await _db.collection('projects').doc(projectID).update({
      'members': FieldValue.arrayUnion([addedUser.email]),
      'requests': FieldValue.arrayRemove([addedUser.email])
    });
    await _db.collection('users_data').doc(addedUser.email).update({
      'projectsIDList': FieldValue.arrayUnion([projectID])
    });
    _projectsIDList.remove(projectID);
    notifyListeners();
  }

// int countDoneTasksInProject(int index){
//   _projectsIDList[index]
// }
}
