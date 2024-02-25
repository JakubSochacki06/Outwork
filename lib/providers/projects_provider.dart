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
  Project editableDummyProject = Project();
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

  void setNewProjectType(String type) {
    _newProject.projectType = type;
    notifyListeners();
  }

  void editProjectDueDate(DateTime? dueDate){
    editableDummyProject.dueDate = dueDate;
    notifyListeners();
  }

  void editProjectType(String type){
    editableDummyProject.projectType = type;
    notifyListeners();
  }

  Future<void> saveEditedChanges() async{
    int indexOfEditedProject = _projectsList.indexWhere((project) => project.id == editableDummyProject.id);
    _projectsList[indexOfEditedProject].title = editableDummyProject.title;
    _projectsList[indexOfEditedProject].description = editableDummyProject.description;
    _projectsList[indexOfEditedProject].dueDate = editableDummyProject.dueDate;
    _projectsList[indexOfEditedProject].projectType = editableDummyProject.projectType;
    await _db.collection('projects').doc(editableDummyProject.id).set(_projectsList[indexOfEditedProject].toMap());
    notifyListeners();
  }

  // Future<void> changeProjectDueDate(DateTime dueDate, Project project) async{
  //   int indexOfEditedProject = _projectsList.indexWhere((element) => element == project);
  //   _projectsList[indexOfEditedProject].dueDate = dueDate;
  //   await _db.collection('projects').doc(project.id).set(_projectsList[indexOfEditedProject].toMap());
  //   notifyListeners();
  // }
  //
  // Future<void> changeProjectType(String type, Project project) async{
  //   int indexOfEditedProject = _projectsList.indexWhere((element) => element == project);
  //   _projectsList[indexOfEditedProject].projectType = type;
  //   await _db.collection('projects').doc(project.id).set(_projectsList[indexOfEditedProject].toMap());
  //   notifyListeners();
  // }
  //
  // Future<void> changeTitleAndDescription(String title, String description, Project project) async{
  //   int indexOfEditedProject = _projectsList.indexWhere((element) => element == project);
  //   _projectsList[indexOfEditedProject].title = title;
  //   _projectsList[indexOfEditedProject].description = description;
  //   await _db.collection('projects').doc(project.id).set(_projectsList[indexOfEditedProject].toMap());
  //   notifyListeners();
  // }

  Future<Project?> getProjectById(String id) async {
    final QuerySnapshot querySnapshot =
        await _db.collection('projects').where('id', isEqualTo: id).get();
    if (querySnapshot.docs.isNotEmpty) {
      dynamic projectData = querySnapshot.docs.first.data();
      List<FirebaseUser> projectMembers = await getProjectMembersData(projectData['membersEmails']);
      Project project = Project.fromMap(projectData, projectMembers);
      return project;
    }
    return null;
  }

  Future<List<FirebaseUser>> getProjectMembersData(List<dynamic> userEmails) async{
    List<FirebaseUser> projectMembers = [];
    for (var userEmail in userEmails) {
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

  // Future<void> editProjectAndSave(FirebaseUser user) async {
  //   int indexToEdit = _projectsList.indexWhere((project) => project.id == editedProject.id);
  //   _projectsList[indexToEdit].title = editedProject.title;
  //   _projectsList[indexToEdit].description = editedProject.description;
  //   _projectsList[indexToEdit].dueDate = editedProject.dueDate;
  //   _projectsList[indexToEdit].projectType = editedProject.projectType;
  //
  //   await _db.collection('projects').doc(editedProject.id).set(_projectsList[indexToEdit].toMap());
  //   notifyListeners();
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
        if(task.completed == false && task.dueDate!.isAfter(DateTime.now())) {
          task.projectColor = project.color;
          allTasks.add(task);
        }
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
      'membersEmails': FieldValue.arrayUnion([addedUser.email]),
      'requests': FieldValue.arrayRemove([addedUser.email])
    });
    await _db.collection('users_data').doc(addedUser.email).update({
      'projectsIDList': FieldValue.arrayUnion([projectID])
    });
    _projectsIDList.remove(projectID);
    notifyListeners();
  }

  Future<void> deleteUserFromProject(FirebaseUser deletedUser, String projectID) async{
    int indexToUpdate = _projectsList.indexWhere((project) => project.id == projectID);
    _projectsIDList.remove(projectID);
    _projectsList[indexToUpdate].membersEmails!.remove(deletedUser.email);
    _projectsList[indexToUpdate].membersData!.remove(deletedUser);
    await _db.collection('projects').doc(projectID).update({
      'membersEmails': FieldValue.arrayRemove([deletedUser.email]),
    });
    await _db.collection('users_data').doc(deletedUser.email).update({
      'projectsIDList': FieldValue.arrayRemove([projectID])
    });
    notifyListeners();
  }

  Future<void> deleteProject(Project project, String userEmail) async{
    _projectsList.remove(project);
    for (var email in project.membersEmails!) {
      await _db.collection('users_data').doc(email).update({
        'projectsIDList': FieldValue.arrayRemove([project.id])
      });
    }
    await _db.collection('projects').doc(project.id).delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
    notifyListeners();
  }

  Future<void> deleteTask(int taskIndex, String projectID, String userEmail) async{
    int indexOfTheProject = _projectsList.indexWhere((project) => project.id == projectID);
    ProjectTask taskToRemove = _projectsList[indexOfTheProject].tasks![taskIndex];
    _projectsList[indexOfTheProject].tasks!.remove(taskToRemove);
    await _db.collection('projects').doc(projectID).update({
      'tasks': FieldValue.arrayRemove([taskToRemove.toMap()])
    });
    notifyListeners();
  }

}
