import 'package:flutter/material.dart';

class DailyCheckinBox extends StatelessWidget {
  const DailyCheckinBox({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:Colors.white,
          border: Border.all(color: Color(0xFFEDEDED)),
          // color: Color(0xFFF0F2F5),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(3, 3),
            )
          ]
        ),
        height: height*0.3,
        width: width*0.45,
        child: Column(
          children: [
            Text('Water')
          ],
        ),
      ),
    );
  }
}
