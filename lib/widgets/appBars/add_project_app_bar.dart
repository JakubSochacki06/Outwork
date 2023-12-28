import 'package:flutter/material.dart';

class AddProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddProjectAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      // backgroundColor: ,
      automaticallyImplyLeading: false,
      // backgroundColor: Colors.white,
      centerTitle: true,
      title: Text('Add new project'),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.navigate_before, size: width * 0.08),
      ),
      actions: [
        // IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
      ],
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}
