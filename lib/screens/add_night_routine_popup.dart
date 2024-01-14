import 'package:flutter/material.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class AddNightRoutinePopup extends StatefulWidget {
  const AddNightRoutinePopup({super.key});

  @override
  State<AddNightRoutinePopup> createState() => _AddNightRoutinePopupState();
}

class _AddNightRoutinePopupState extends State<AddNightRoutinePopup> {
  final _nightRoutineController = TextEditingController();

  @override
  void dispose() {
    _nightRoutineController.dispose();
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
            'Night Routine name',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            width: width * 0.8,
            height: height * 0.05,
            child: TextField(
              controller: _nightRoutineController,
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
              final nightRoutineProvider = Provider.of<NightRoutineProvider>(context, listen: false);
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              nightRoutineProvider.addNightRoutineToDatabase(_nightRoutineController.text, userProvider.user!.email!);
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
