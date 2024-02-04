import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:outwork/screens/progress_page/money_page.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:outwork/widgets/carousel_item.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Never stop progressing',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          Container(
            height: height * 0.45,
            child: CarouselSlider.builder(
              itemCount: carouselElements.length,
              itemBuilder: (context, index, pageViewIndex) {
                return CarouselItem(
                    title: carouselElements[index]['title']!,
                    description: carouselElements[index]['description']!,
                    imageName: carouselElements[index]['imageName']!,
                    isSelected: index == _currentIndex);
              },
              options: CarouselOptions(
                height: height * 0.4,
                viewportFraction: 0.66,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          FittedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                // maximumSize: Size(width*0.1, height*0.03)
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => carouselElements[_currentIndex]['route']),
                );
              },
              child: Row(
                children: [
                  Text(
                    'Choose!',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> carouselElements = [
  {
    'title': 'Money',
    'imageName': 'money',
    'description': 'Track your expenses',
    'route':const MoneyPage(),
  },
  {'title': 'Physique', 'imageName': 'money', 'description': 'Zyzz is proud'},
  {
    'title': 'Wisdom',
    'imageName': 'money',
    'description': 'You are the smart one',
  },
  {
    'title': 'Meditation',
    'imageName': 'money',
    'description': 'Clear your mind'
  },
  {
    'title': 'Sleep',
    'imageName': 'money',
    'description': 'Keep a good sleeping schedule'
  },
  {
    'title': 'Travel Log',
    'imageName': 'money',
    'description': 'Document travel experiences'
  },
];
