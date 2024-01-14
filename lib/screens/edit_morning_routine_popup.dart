import 'package:flutter/material.dart';
import 'package:outwork/screens/add_morning_routine_popup.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditMorningRoutinePopup extends StatelessWidget {
  const EditMorningRoutinePopup({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddMorningRoutinePopup()),
                  ),
                );
              },
              child: Text(
                'Add new routine',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                minimumSize: Size(width * 0.8, height * 0.05),
                backgroundColor: Color(0xFF2A6049),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
