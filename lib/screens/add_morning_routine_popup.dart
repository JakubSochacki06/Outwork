import 'package:flutter/material.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/text_styles.dart';
import 'package:outwork/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class AddMorningRoutinePopup extends StatefulWidget {
  const AddMorningRoutinePopup({super.key});

  @override
  State<AddMorningRoutinePopup> createState() => _AddMorningRoutinePopupState();
}

class _AddMorningRoutinePopupState extends State<AddMorningRoutinePopup> {
  final _morningRoutineController = TextEditingController();

  @override
  void dispose() {
    _morningRoutineController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(15),
      width: width * 0.9,
      child: Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Morning Routine name',
            style: kRegular20,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            width: width * 0.8,
            height: height * 0.05,
            child: TextField(
              controller: _morningRoutineController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: width * 0.02,
                  bottom: height * 0.05 / 2,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ElevatedButton(
            onPressed: () {
              final morningRoutineProvider = Provider.of<MorningRoutineProvider>(context, listen: false);
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              morningRoutineProvider.addMorningRoutineToDatabase(_morningRoutineController.text, userProvider.user!.email!);
              Navigator.pop(context);
            },
            child: Text(
              'Submit new routine',
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
    );
  }
}
