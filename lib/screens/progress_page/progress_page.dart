import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:outwork/screens/progress_page/books_page.dart';
import 'package:outwork/screens/progress_page/money_page/money_page.dart';
import 'package:outwork/services/notifications_service.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:outwork/widgets/carousel_item.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:outwork/constants/constants.dart';
import 'mental_health_page/mental_health_page.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: height * 0.02, left: width * 0.04, right: width * 0.04),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: width / (height / 1.76),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: progressFields.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: progressFields[index]['route'],
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: ProgressCard(
                  title: progressFields[index]['title']!,
                  description: progressFields[index]['description']!,
                  imageName: progressFields[index]['imageName']!,
              ),
            );
          },),
      ),
    );
  }
}


