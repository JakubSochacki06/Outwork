import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:outwork/screens/progress_page/books_page.dart';
import 'package:outwork/screens/progress_page/money_page/money_page.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:outwork/widgets/carousel_item.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'mental_health_page/mental_health_page.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _currentIndex = 0;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AutoSizeText(
              'Never stop progressing',
              style: Theme
                  .of(context)
                  .textTheme
                  .displaySmall,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            SizedBox(height: height*0.03,),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: width / (height / 1.76),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: carouselElements.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: carouselElements[index]['route'],
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: ProgressCard(
                        title: carouselElements[index]['title']!,
                        description: carouselElements[index]['description']!,
                        imageName: carouselElements[index]['imageName']!,
                    ),
                  );
                },),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> carouselElements = [
  {
    'title': 'Money',
    'imageName': 'money',
    'description': 'Track your expenses',
    'route': const MoneyPage(),
  },
  {'title': 'Physique', 'imageName': 'money', 'description': 'Track your physique progress'},
  {
    'title': 'Books',
    'imageName': 'money',
    'description': 'Read all of them!',
    'route': const BooksPage(),
  },
  {
    'title': 'Meditation',
    'imageName': 'meditation',
    'description': 'Clear your mind'
  },
  {
    'title': 'Sleep',
    'imageName': 'meditation2',
    'description': 'Keep your sleeping schedule'
  },
  {
    'title': 'Journal',
    'imageName': 'money',
    'description': 'Track your feelings',
    'route': const MentalHealthPage(),
  },
];
