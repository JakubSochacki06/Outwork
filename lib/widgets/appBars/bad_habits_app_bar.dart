import 'package:flutter/material.dart';
import 'package:outwork/constants/constants.dart';
import 'package:outwork/screens/progress_page/bad_habits_page/manage_habits_page.dart';
import 'package:provider/provider.dart';

import '../../providers/progress_provider.dart';
class BadHabitsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BadHabitsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text('Bad Habits', style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.navigate_before)),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageHabitsPage(startingHabits:Map.from(progressProvider.badHabits))),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ]
    );
  }

  @override
  Size get preferredSize =>  const Size.fromHeight(kToolbarHeight);
}