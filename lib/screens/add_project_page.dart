import 'package:flutter/material.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/widgets/appBars/add_project_app_bar.dart';
import 'package:outwork/widgets/calendar_picker_tile.dart';
import 'package:provider/provider.dart';

class AddProjectPage extends StatelessWidget {
  const AddProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // _titleController.text = 'Enter your title here';
    final projectProvider =
        Provider.of<ProjectsProvider>(context, listen: true);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.02, horizontal: width * 0.04),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              // controller: _titleController,
              decoration: InputDecoration(
                  // alignLabelWithHint: true,
                  labelText: 'Title',
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  hintText: 'Enter your title here'),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15)),
            height: height * 0.15,
            child: TextField(
              maxLines: 3,
              // expands: true,
              // controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  hintText: 'Enter description here'),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Due Date',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          CalendarPickerTile(),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Task type',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  projectProvider.setTaskType('Basic');
                },
                child: Text('Basic',
                    style: projectProvider.newProject.taskType == 'Basic'
                        ? Theme.of(context).textTheme.labelMedium
                        : Theme.of(context).textTheme.bodySmall),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor:
                      projectProvider.newProject.taskType == 'Basic'
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  projectProvider.setTaskType('Urgent');
                },
                child: Text('Urgent',
                    style: projectProvider.newProject.taskType == 'Urgent'
                        ? Theme.of(context).textTheme.labelMedium
                        : Theme.of(context).textTheme.bodySmall),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor:
                      projectProvider.newProject.taskType == 'Urgent'
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  projectProvider.setTaskType('Important');
                },
                child: Text('Important',
                    style: projectProvider.newProject.taskType == 'Important'
                        ? Theme.of(context).textTheme.labelMedium
                        : Theme.of(context).textTheme.bodySmall),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor:
                      projectProvider.newProject.taskType == 'Important'
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ElevatedButton(
            onPressed: () async{
              Navigator.pop(context);
            },
            child: Text(
              'Submit',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              minimumSize: Size(width*0.8, height*0.05),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
